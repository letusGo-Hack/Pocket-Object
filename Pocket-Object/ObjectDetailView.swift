//
//  ObjectDetailView.swift
//  Pocket-Object
//
//  Created by 김윤석 on 2023/06/10.
//
import SceneKit
import RealityKit
import QuickLook
import SwiftUI

struct ObjectDetailView: View {
    @Environment(\.presentationMode) var presentationMode
//    var usdzURL: URL
    var content: Content?
    var tapDismiss: () -> Void
    
    var body: some View {
        ZStack{
            Color(uiColor: .darkNavy).ignoresSafeArea()
            
            ScrollView(.vertical) {
                VStack {
                    VStack {
                        ARViewContainer(url: content?.imageUrl ?? "")
                            .frame(
                                width: UIScreen.main.bounds.width,
                                height: UIScreen.main.bounds.width
                            )
                    }
                    .background(RoundedCorners(
                        tl: 0,
                        tr: 30,
                        bl: 30,
                        br: 0
                    ).fill(Color.blue))
                    
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text("Name: \(content?.title ?? "")")
                                .font(.title)
                            Spacer()
                        }
                        
                        HStack {
                            Text("Date: \(content?.date ?? Date())")
                                .font(.subheadline)
                            Spacer()
                        }
                        
                        HStack(alignment: .center) {
                            Button {
                                print("bookmark")
                            } label: {
                                Image(systemName: "bookmark")
                                    .frame(height: 40)
                                    .frame(maxWidth: UIScreen.main.bounds.width / 3)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color.lightNavy)
                                    )
                            }
                        }
                        
                        cellView("lat", content: "\(content?.lat ?? "0")")
                        cellView("long", content: "\(content?.log ?? "0")")
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal)
                }
                
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        tapDismiss()
                    }) {
                        CircleButton(imageString: "xmark")
                    }
                    .padding(.all)
                }
                
                Spacer()
            }
        }
    }
    
    private func cellView(_ title: String, content: String) -> some View {
        VStack {
            HStack {
                Text(title)
                    .foregroundColor(.white)
                    .font(.title3)
                
                Spacer()
                
                Text(content)
                    .foregroundColor(.white)
                    .font(.title3)
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    let url: String
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        
        // 1: Load .obj file
        guard let url = URL(string: url) else { return SCNView() }
        let scene = try? SCNScene(url: url)
        
//        let scene = SCNScene(named: "pie_lemon_meringue.usdz")
        
        // 2: Add camera node
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        // 3: Place camera
        cameraNode.position = SCNVector3(x: 0, y: 10, z: 35)
        // 4: Set camera on scene
        scene?.rootNode.addChildNode(cameraNode)
        
        // 5: Adding light to scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 35)
        scene?.rootNode.addChildNode(lightNode)
        
        // 6: Creating and adding ambien light to scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.color = UIColor.darkGray
        scene?.rootNode.addChildNode(ambientLightNode)
        
        // Allow user to manipulate camera
        sceneView.allowsCameraControl = true
        
        // Show FPS logs and timming
        // sceneView.showsStatistics = true
        
        // Set background color
        sceneView.backgroundColor = UIColor.white
        
        // Allow user translate image
        sceneView.cameraControlConfiguration.allowsTranslation = false
        
        // Set scene settings
        sceneView.scene = scene
        
        return sceneView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        // Update the ARView if needed
        uiView.layer.cornerRadius = 12
        uiView.clipsToBounds = true
    }
}

struct USDZView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> UIView {
        let quickLookController = QLPreviewController()
        quickLookController.dataSource = context.coordinator
    
        return quickLookController.view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, QLPreviewControllerDataSource {
        let parent: USDZView
        
        init(_ parent: USDZView) {
            self.parent = parent
        }
        
        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }
        
        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return parent.url as QLPreviewItem
        }
    }
}

struct CircleButton: View {
    let imageString: String
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(.darkNavy)
                    .frame(width: 50, height: 50)
                    .shadow(color: .gray.opacity(0.5), radius: 10, x: 7, y: 7)
                Image(systemName: imageString)
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .semibold))
            }
        }
    }
}

struct RoundedCorners: Shape {
    var tl: CGFloat = 0.0
    var tr: CGFloat = 0.0
    var bl: CGFloat = 0.0
    var br: CGFloat = 0.0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let w = rect.size.width
        let h = rect.size.height
        
        // Make sure we do not exceed the size of the rectangle
        let tr = min(min(self.tr, h/2), w/2)
        let tl = min(min(self.tl, h/2), w/2)
        let bl = min(min(self.bl, h/2), w/2)
        let br = min(min(self.br, h/2), w/2)
        
        path.move(to: CGPoint(x: w / 2.0, y: 0))
        path.addLine(to: CGPoint(x: w - tr, y: 0))
        path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr,
                    startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
        
        path.addLine(to: CGPoint(x: w, y: h - br))
        path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br,
                    startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
        
        path.addLine(to: CGPoint(x: bl, y: h))
        path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl,
                    startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
        
        path.addLine(to: CGPoint(x: 0, y: tl))
        path.addArc(center: CGPoint(x: tl, y: tl), radius: tl,
                    startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
        path.closeSubpath()

        return path
    }
}
