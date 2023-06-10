//
//  ObjectDetailView.swift
//  Pocket-Object
//
//  Created by 김윤석 on 2023/06/10.
//
import QuickLook
import SwiftUI

struct ObjectDetailView: View {
    
    var usdzURL: URL
   
    var body: some View {
        ScrollView(.vertical) {
            VStack {
               
                USDZView(url: usdzURL)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                
                Text("Name")
                Text("Description")
                Text("Date")
            }
        }
        .onAppear {
            print(usdzURL.absoluteString)
        }
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
