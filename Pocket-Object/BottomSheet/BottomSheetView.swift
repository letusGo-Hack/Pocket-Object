//
//  BottomSheetView.swift
//  Pocket-Object
//
//  Created by ZUMIN YOU on 2023/06/10.
//

import SwiftUI
import SwiftData

struct BottomSheetView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Content]
    
    var body: some View {
        VStack {
            Button {
                addTestData()
            } label: {
                Text("test")
            }
            
            ScrollView {
                VStack {
                    ForEach(items, id: \.self) { item in
                        ListItemView(content: item)
                    }
                }
            }
        }
    }
    
    func addTestData() {
        let content = Content(imageUrl: "test", date: Date(), title: "test2", content: "test", lat: "126.9779692", log: "37.566535", bookmark: false)
        modelContext.insert(content)
    }
}

#Preview {
    BottomSheetView()
}
