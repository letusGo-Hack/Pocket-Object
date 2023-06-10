//
//  CapturePrimaryView.swift
//  WWDC2023Team2
//
//  Created by 김윤석 on 2023/06/10.
//

import RealityKit
import SwiftUI

struct CapturePrimaryView: View {
    @StateObject var single = CaptureManager.shared
    
    var onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            ObjectCaptureView(session: single.session)
            switch single.session.state {
            case .initializing:
                EmptyView()
                
            case .ready:
                VStack {
                    Text("Ready")
                    
                    Button {
                        single.session.startDetecting()
                    } label: {
                        Text("Start Detecting")
                    }
                }
               
            case .detecting:
                VStack {
                    Text("Detecting")
                    Button {
                        single.session.startCapturing()
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
        .onDisappear(perform: {
            onDismiss()
        })
    }
}
