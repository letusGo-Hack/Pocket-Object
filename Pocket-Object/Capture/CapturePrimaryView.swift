
//
//  CapturePrimaryView.swift
//  WWDC2023Team2
//
//  Created by 김윤석 on 2023/06/10.
//
import RealityKit
import SwiftUI
import OSLog

struct CapturePrimaryView: View {
    @StateObject var session = ObjectCaptureSession()
    let uuidString = UUID().uuidString
    var onDismiss: () -> Void
    
    @State var mockCompleteScanPass = false
    
    var body: some View {
        if session.userCompletedScanPass || mockCompleteScanPass {
            CaptureResultView(session: session, onDismiss: onDismiss, uuidString: uuidString)
        }
        else {
            ZStack {
                ObjectCaptureView(session: session)
                switch session.state {
                case .initializing:
                    EmptyView()
                    
                case .ready:
                    VStack {
                        Spacer()
                        Button {
                            session.startDetecting()
                        } label: {
                            Text("Start Detecting")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(.darkNavy)
                        .clipShape(Capsule())
                    }
                    
                case .detecting:
                    VStack {
                        Spacer()
                        Button {
                            session.startCapturing()
                        } label: {
                            Text("Start Capturing")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(.darkNavy)
                        .clipShape(Capsule())
                    }
                    
                case .capturing:
                    VStack {
                        Spacer()
                        Button {
                            session.requestImageCapture()
                        } label: {
                            Text("requestImageCapture")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(.darkNavy)
                        .clipShape(Capsule())
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
                configuration.checkpointDirectory = DirectoryManager.getDocumentsDirectory().appendingPathComponent("Snapshots/\(uuidString)")
                configuration.isOverCaptureEnabled = true
                let url: URL = DirectoryManager.getDocumentsDirectory().appendingPathComponent("Images/\(uuidString)")
                session.start(imagesDirectory: url, configuration: configuration)
            })
        }
    }
}
