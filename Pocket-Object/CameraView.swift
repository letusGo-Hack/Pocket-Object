//
//  CapturePrimaryView.swift
//  WWDC2023Team2
//
//  Created by 김윤석 on 2023/06/10.
//
import GeoTrackKit
import RealityKit
import SwiftUI
import OSLog

struct CapturePrimaryView: View {
    @StateObject var session = ObjectCaptureSession()
    let uuidString = UUID().uuidString
    @State var fileName: String = ""
    var onDismiss: () -> Void
    @State var shouldShowProgressView = false
    @State var mockCompleteScanPass = false
    @State var reconstructionFinished = false
    
    var body: some View {
        if session.userCompletedScanPass || mockCompleteScanPass {
            VStack {
                ObjectCapturePointCloudView(session: session)
                
                Spacer()
                
                VStack(alignment: .center) {
                    TextField(text: $fileName, label: {
                        Text("저장할 파일 이름을 입력해주세요.")
                    })
                    .border(.black, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                    .frame(width: 300, height: 200)
                    
                    Button {
                        if !fileName.isEmpty {
                            shouldShowProgressView = true
                            reconstruction()
                        }
                    } label: {
                        Text("reconstruction")
                            .border(.black, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                            .frame(width: 300, height: 200)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
            }
            .onDisappear(perform: {
                onDismiss()
            })
            if shouldShowProgressView {
                ProgressView()
            }
            if reconstructionFinished {
                VStack {
                    Text("reconstructionFinished")
                    NavigationLink("상세뷰 진입", destination: {
                        Viewer3D(fileName: fileName)
                    })
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
                    }
                case .finishing:
                    Text("Finishing")
                    
                case .completed:
                    Text("completed")
                    //사용자가 object 정보를 저장하는 view가 present
                    
                case .failed(let error):
                    Text(error.localizedDescription)
                    
                @unknown default:
                    Text("unknown default")
                }
            }
            .onAppear(perform: {
                var configuration = ObjectCaptureSession.Configuration()
                configuration.checkpointDirectory = getDocumentsDirectory().appendingPathComponent("Snapshots/\(uuidString)")
                configuration.isOverCaptureEnabled = true
                let url: URL = getDocumentsDirectory().appendingPathComponent("Images/\(uuidString)")
                session.start(imagesDirectory: url, configuration: configuration)
            })
        }
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func reconstruction() {
        var configuration = PhotogrammetrySession.Configuration()
        configuration.checkpointDirectory = getDocumentsDirectory().appendingPathComponent("Snapshots/\(uuidString)")
        let url: URL = getDocumentsDirectory().appendingPathComponent("Images/\(uuidString)")
        var session: PhotogrammetrySession
        do {
            session = try PhotogrammetrySession(input: url, configuration: configuration)
            try session.process(requests: [
                PhotogrammetrySession.Request.modelFile(url: getDocumentsDirectory().appendingPathComponent("testModel.usdz"))
            ])
        } catch {
            return
        }
        Task {
            do {
                for try await output in session.outputs {
                    switch output {
                    case .processingComplete:
                        os_log(.debug, "[log]: RealityKit has processed all requests.")
                    case .requestError(let request, let error):
                        os_log(.debug, "[log]: Request encountered an error.")
                    case .requestComplete(let request, let result):
                        reconstructionFinished = true
                        shouldShowProgressView = false
                        os_log(.debug, "[log]: RealityKit has finished processing a request.")
                    case .requestProgress(let request, let fractionComplete):
                        os_log(.debug, "[log]: Periodic progress update \(fractionComplete). Update UI here.")
                    case .requestProgressInfo(let request, let progressInfo):
                        os_log(.debug, "[log]: Periodic progress info update.")
                    case .inputComplete:
                        os_log(.debug, "[log]: Ingestion of images is complete and processing begins.")
                    case .invalidSample(let id, let reason):
                        os_log(.debug, "[log]: RealityKit deemed a sample invalid and didn't use it.")
                    case .skippedSample(let id):
                        os_log(.debug, "[log]: RealityKit was unable to use a provided sample.")
                    case .automaticDownsampling:
                        os_log(.debug, "[log]: RealityKit downsampled the input images because of resource constraints.")
                    case .processingCancelled:
                        os_log(.debug, "[log]: Processing was canceled.")
                    @unknown default:
                        os_log(.debug, "[log]: Unrecognized output.")
                    }
                }
            } catch {
                os_log(.debug, "Output: ERROR = \(String(describing: error))")
                // Handle error.
            }
        }
    }
}
