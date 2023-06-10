//
//  3Dview.swift
//  Pocket-Object
//
//  Created by eden on 2023/06/10.
//

import SwiftUI
import SceneKit
import ARKit

struct Viewer3D: View {
    
    @State var urlLocalModel: URL?
    @State var openFile = false
    @State var fileName: String = ""
    
    var body: some View {
        VStack{
            TextField(text: $fileName, label: {
                Text("열고자하는 파일의 이름을 적어주세요")
            })
            VStack {
                Button {
                    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                    let url = paths[0]
                    urlLocalModel = url.appendingPathComponent("\(fileName).usdz")
                } label: {
                    Text("Open File Local USDZ")
                }
            }
            if (urlLocalModel != nil) {
                let scene = try? SCNScene(url: urlLocalModel!)
                SceneView(scene: scene, options: [.autoenablesDefaultLighting,.allowsCameraControl])
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
            }
        }
    }}
