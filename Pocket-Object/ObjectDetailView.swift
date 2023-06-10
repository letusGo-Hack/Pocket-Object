//
//  ObjectDetailView.swift
//  Pocket-Object
//
//  Created by 김윤석 on 2023/06/10.
//
import QuickLook
import SwiftUI

struct ObjectDetailView: View {
    let usdzURL = Bundle.main.url(forResource: "pie_lemon_meringue", withExtension: "usdz")!
        
    var body: some View {
        USDZView(url: usdzURL)
                    .frame(width: 300, height: 400)
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
