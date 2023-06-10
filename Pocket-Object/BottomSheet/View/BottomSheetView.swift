//
//  BottomSheetView.swift
//  Pocket-Object
//
//  Created by ZUMIN YOU on 2023/06/10.
//

import SwiftUI
import SwiftData

struct BottomSheetView: View {
    let contents: [Content]
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    ForEach(contents, id: \.self) { item in
                        ListItemView(content: item) {
                            item.bookmark.toggle()
                        }
                    }
                }
            }
        }
    }
    
//    func addTestData() {
//        let content = Content(imageUrl: "test", date: Date(), title: "test2", content: "test", lat: "126.9779692", log: "37.566535", bookmark: false)
//        modelContext.insert(content)
//    }
}

#Preview {
    Text("")
}
