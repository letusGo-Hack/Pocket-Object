//
//  ResultView.swift
//  Pocket-Object
//
//  Created by eden on 2023/06/10.
//

import SwiftUI
import RealityKit
import OSLog

struct ResultView: View {
    @StateObject var session: ObjectCaptureSession
    var onDismiss: () -> Void
    let uuidString = UUID().uuidString
    @State var fileName: String = ""
    @State var shouldShowProgressView = false
    @State var reconstructionFinished = true
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                //            ObjectCapturePointCloudView(session: session)
                //                .frame(maxHeight: .infinity)
                VStack {
                    Spacer()
                    Text("TmpText")
                    Spacer()
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.yellow)
                
                if !reconstructionFinished {
                    ZStack {
                        VStack(alignment: .center, spacing: 10) {
                            TextField(text: $fileName, label: {
                                Text("저장할 파일 이름을 입력해주세요.")
                            })
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                            
                            
                            Button {
                                if !fileName.isEmpty {
                                    //TODO: 파일 존재 여부 검증
                                    shouldShowProgressView = true
                                    reconstruction()
                                }
                            } label: {
                                Text("reconstruction")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }
                            .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity)
                        if shouldShowProgressView {
                            ProgressView()
                        }
                    }
                    .padding()
                } else {
                    VStack {
                        Text("reconstructionFinished")
                        NavigationLink("상세뷰 진입") {
                            Viewer3D(fileName: fileName)
                        }
                    }
                    .padding()
                }
            }
        }
        .padding()
        .onDisappear(perform: {
            onDismiss()
        })
    }
    
    func reconstruction() {
        var configuration = PhotogrammetrySession.Configuration()
        configuration.checkpointDirectory = DirectoryManager.getDocumentsDirectory().appendingPathComponent("Snapshots/\(uuidString)")
        let url: URL = DirectoryManager.getDocumentsDirectory().appendingPathComponent("Images/\(uuidString)")
        var session: PhotogrammetrySession
        do {
            session = try PhotogrammetrySession(input: url, configuration: configuration)
            try session.process(requests: [
                PhotogrammetrySession.Request.modelFile(url: DirectoryManager.getDocumentsDirectory().appendingPathComponent("\(fileName).usdz"))
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
