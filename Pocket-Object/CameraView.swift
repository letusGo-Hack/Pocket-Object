//
//  CapturePrimaryView.swift
//  WWDC2023Team2
//
//  Created by 김윤석 on 2023/06/10.
//
import GeoTrackKit
import RealityKit
import SwiftUI

struct CapturePrimaryView: View {
    //    @StateObject var single = CaptureManager.shared
    @StateObject var session = ObjectCaptureSession()
    @State var captureCount: Int = 1
    var onDismiss: () -> Void
    @State var shouldShowProgressView = false
    
    var body: some View {
        if session.userCompletedScanPass {
            VStack {
                ObjectCapturePointCloudView(session: session)
                Button {
                    session.beginNewScanPassAfterFlip()
                } label: {
                    Text("돌려서 다시 찍기")
                }
                Spacer()
                    .frame(height: 50)
                Button {
                    session.beginNewScanPass()
                } label: {
                    Text("한번 더 찍기")
                }
                
                Spacer()
                    .frame(height: 50)
                
                if case .completed = session.state {
                    Button {
                        shouldShowProgressView = true
                    } label: {
                        Text("reconstruction")
                    }
                } else {
                    Button {
                        session.finish()
                    } label: {
                        Text("finish")
                    }
                }
            }
            .onDisappear(perform: {
                onDismiss()
            })
            if shouldShowProgressView {
                ProgressView().task {
                    Task {
                        var configuration = PhotogrammetrySession.Configuration()
                        configuration.checkpointDirectory = getDocumentsDirectory().appendingPathComponent("Snapshots/\(UUID().uuidString)")
                        let url: URL = getDocumentsDirectory().appendingPathComponent("Images/\(UUID().uuidString)")
                        let session = try PhotogrammetrySession(input: url, configuration: configuration)
                        try session.process(requests: [
                            PhotogrammetrySession.Request.modelFile(url: getDocumentsDirectory().appendingPathComponent("model.usdz"))
                        ])
                        
                        let waiter = Task {
                            do {
                                for try await output in session.outputs {
                                    switch output {
                                    case .processingComplete:
                                        print("RealityKit has processed all requests.")
                                    case .requestError(let request, let error):
                                        print("Request encountered an error.")
                                    case .requestComplete(let request, let result):
                                        print("RealityKit has finished processing a request.")
                                    case .requestProgress(let request, let fractionComplete):
                                        print("Periodic progress update. Update UI here.")
                                    case .requestProgressInfo(let request, let progressInfo):
                                        print("Periodic progress info update.")
                                    case .inputComplete:
                                        print("Ingestion of images is complete and processing begins.")
                                    case .invalidSample(let id, let reason):
                                        print("RealityKit deemed a sample invalid and didn't use it.")
                                    case .skippedSample(let id):
                                        print("RealityKit was unable to use a provided sample.")
                                    case .automaticDownsampling:
                                        print("RealityKit downsampled the input images because of resource constraints.")
                                    case .processingCancelled:
                                        print("Processing was canceled.")
                                    @unknown default:
                                        print("Unrecognized output.")
                                    }
                                }
                            } catch {
                                print("Output: ERROR = \(String(describing: error))")
                                // Handle error.
                            }
                        }
                    }
                }
            }
        }
        else {
            ZStack {
                ObjectCaptureView(session: session)
                switch session.state {
                case .initializing:
                    EmptyView()
                    
                case .ready:
                    VStack {
                        Text("Ready")
                        Spacer()
                        Button {
                            session.startDetecting()
                        } label: {
                            Text("Start Detecting")
                        }
                    }
                    
                case .detecting:
                    VStack {
                        Text("Detecting")
                        Spacer()
                        Button {
                            session.startCapturing()
                        } label: {
                            Text("Start Capturing")
                        }
                    }
                    
                case .capturing:
                    VStack {
                        Text("capture")
                        Spacer()
                        Button {
                            session.requestImageCapture()
                        } label: {
                            Text("requestImageCapture")
                        }
                        Spacer()
                            .frame(height: 50)
                        
                    }
                case .finishing:
                    Text("Finishing")
                    
                case .completed:
                    Text("completed")
                    if captureCount != 3 {
                        Button {
                            captureCount += 1
                            session.startCapturing()
                        } label: {
                            Text("Start Capturing")
                        }
                    }
                    
                    //사용자가 object 정보를 저장하는 view가 present
                    
                case .failed(let error):
                    Text(error.localizedDescription)
                    
                @unknown default:
                    Text("unknown default")
                }
            }
            .onAppear(perform: {
                var configuration = ObjectCaptureSession.Configuration()
                configuration.checkpointDirectory = getDocumentsDirectory().appendingPathComponent("Snapshots/\(UUID().uuidString)")
                configuration.isOverCaptureEnabled = true
                let url: URL = getDocumentsDirectory().appendingPathComponent("Images/\(UUID().uuidString)")
                session.start(imagesDirectory: url, configuration: configuration)
            })
        }
    }
    
}
func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
