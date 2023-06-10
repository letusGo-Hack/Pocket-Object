
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
    @StateObject var session = ObjectCaptureSession()
    var onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            
            if session.userCompletedScanPass {
                ObjectCapturePointCloudView(session: session)
                Button {
                    session.finish()
                } label: {
                    Text("Finish")
                }
                
            } else {
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
                        Button {
                            session.startCapturing()
                        } label: {
                            Text("Start Capturing")
                        }
                    }
                    
                case .capturing:
                    Text("capture")
                    
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
        }
        .onAppear(perform: {
            var configuration = ObjectCaptureSession.Configuration()
            configuration.checkpointDirectory = getDocumentsDirectory().appendingPathComponent("Snapshots/\(UUID().uuidString)")
            configuration.isOverCaptureEnabled = true
            let url: URL = getDocumentsDirectory().appendingPathComponent("Images/\(UUID().uuidString)")
            print(url.absoluteString)
            session.start(imagesDirectory: url, configuration: configuration)
        })
        .onDisappear(perform: {
            onDismiss()
        })
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
