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
    var onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            ObjectCaptureView(session: session)
            if case .ready = session.state {
                VStack {
                    Text("Ready")
                    Spacer()
                    Button {
                        session.startDetecting()
                    } label: {
                        Text("Start Detecting")
                    }
                }
            } else if case .detecting = session.state {
                VStack {
                    Text("Detecting")
                    Button {
                        session.startCapturing()
                    } label: {
                        Text("Start Capturing")
                    }
                }
            }
//            switch single.session.state {
//            case .initializing:
//                EmptyView()
//                
//            case .ready:
//                VStack {
//                    Text("Ready")
//                    Spacer()
//                    Button {
//                        single.session.startDetecting()
//                    } label: {
//                        Text("Start Detecting")
//                    }
//                }
//               
//            case .detecting:
//  
//
//            case .capturing:
//                Text("capture")
//                
//            case .finishing:
//                Text("Finishing")
//                
//            case .completed:
//                Text("completed")
//                //사용자가 object 정보를 저장하는 view가 present
//                
//            case .failed(let error):
//                Text(error.localizedDescription)
//                
//            @unknown default:
//                Text("unknown default")
//            }
        }
        .onAppear(perform: {
            var configuration = ObjectCaptureSession.Configuration()
            configuration.checkpointDirectory = getDocumentsDirectory().appendingPathComponent("Snapshots/")
            configuration.isOverCaptureEnabled = true
            let url: URL = getDocumentsDirectory().appendingPathComponent("Images/")
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
