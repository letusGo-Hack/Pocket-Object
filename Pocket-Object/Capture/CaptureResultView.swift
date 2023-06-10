//
//  CaptureResultView.swift
//  Pocket-Object
//
//  Created by eden on 2023/06/10.
//

import SwiftUI
import RealityKit
import OSLog

struct CaptureResultView: View {
    @StateObject var session: ObjectCaptureSession
    var onDismiss: () -> Void
    let uuidString: String
    @State var fileName: String = ""
    var savedFileName: String {
        return "\(uuidString)/\(fileName)"
    }
    @State var shouldShowProgressView: Bool = false
    @State var reconstructionFinished: Bool = false
    @State var reconstructionProgress: Double = 0.0
    @State var errorMessage: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                ObjectCapturePointCloudView(session: session)
                    .frame(maxHeight: .infinity)
                
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
                                if !fileName.isEmpty, !isFileExist() {
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
                            VStack {
                                ProgressView(value: reconstructionProgress)
                                    .progressViewStyle(.automatic)
                                Text("\(reconstructionProgress)")
                            }
                        }
                    }
                    .padding()
                } else {
                    NavigationLink(destination: ReconstructionResultView(url: DirectoryManager.getDocumentsDirectory().appendingPathComponent("\(savedFileName).usdz"))) {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.blue)
                            Text("Go to Detail View")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
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
    
    func isFileExist() -> Bool {
        let url = DirectoryManager.getDocumentsDirectory().appendingPathComponent("\(savedFileName).usdz")
        return FileManager.default.fileExists(atPath: url.absoluteString)
    }
    
    func reconstruction() {
        var configuration = PhotogrammetrySession.Configuration()
        configuration.checkpointDirectory = DirectoryManager.getDocumentsDirectory().appendingPathComponent("Snapshots/\(uuidString)")
        let url: URL = DirectoryManager.getDocumentsDirectory().appendingPathComponent("Images/\(uuidString)")
        var session: PhotogrammetrySession
        do {
            session = try PhotogrammetrySession(input: url, configuration: configuration)
            try session.process(requests: [
                PhotogrammetrySession.Request.modelFile(url: DirectoryManager.getDocumentsDirectory().appendingPathComponent("\(savedFileName).usdz"))
            ])
        } catch {
            errorMessage = error.localizedDescription
            os_log("[log] processFail: \(error.localizedDescription)")
            return
        }
        Task {
            do {
                for try await output in session.outputs {
                    switch output {
                    case .processingComplete:
                        os_log("[log]: RealityKit has processed all requests.")
                    case .requestError(let request, let error):
                        os_log("[log]: Request encountered an error.")
                    case .requestComplete(let request, let result):
                        reconstructionFinished = true
                        shouldShowProgressView = false
                        os_log("[log]: RealityKit has finished processing a request.")
                    case .requestProgress(let request, let fractionComplete):
                        reconstructionProgress = fractionComplete
                        os_log("[log]: Periodic progress update \(fractionComplete). Update UI here.")
                    case .requestProgressInfo(let request, let progressInfo):
                        os_log("[log]: Periodic progress info update.")
                    case .inputComplete:
                        os_log("[log]: Ingestion of images is complete and processing begins.")
                    case .invalidSample(let id, let reason):
                        os_log("[log]: RealityKit deemed a sample invalid and didn't use it.")
                    case .skippedSample(let id):
                        os_log("[log]: RealityKit was unable to use a provided sample.")
                    case .automaticDownsampling:
                        os_log("[log]: RealityKit downsampled the input images because of resource constraints.")
                    case .processingCancelled:
                        os_log("[log]: Processing was canceled.")
                    @unknown default:
                        os_log("[log]: Unrecognized output.")
                    }
                }
            } catch {
                os_log("Output: ERROR = \(String(describing: error))")
                // Handle error.
            }
        }
    }
}
