
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
                configuration.checkpointDirectory = DirectoryManager.getDocumentsDirectory().appendingPathComponent("Snapshots/\(uuidString)")
                configuration.isOverCaptureEnabled = true
                let url: URL = DirectoryManager.getDocumentsDirectory().appendingPathComponent("Images/\(uuidString)")
                session.start(imagesDirectory: url, configuration: configuration)
            })
        }
    }
}
