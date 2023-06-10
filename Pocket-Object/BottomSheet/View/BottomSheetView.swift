//
//  BottomSheetView.swift
//  Pocket-Object
//
//  Created by ZUMIN YOU on 2023/06/10.
//

import SwiftUI
import SwiftData

struct BottomSheetView: View {
    @ObservedObject var viewModel: BottomSheetViewModel
    var onTap: (Content) -> Void
    var isLocationMoveClicked: ((_ lat: String, _ log: String) -> Void)
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    ForEach(viewModel.contents, id: \.self) { item in
                        ListItemView(content: item) {
                            item.bookmark.toggle()
                        } isLocationMoveClicked: { lat, log in
                            isLocationMoveClicked(lat, log)
                        }
                        .onTapGesture {
                            print(item)
                            onTap(item)
                        }

                    }
                }
            }
            .background(.darkNavy)
        }
    }
    
//    func addTestData() {
//        let content = Content(imageUrl: "test", date: Date(), title: "test2", content: "test", lat: "126.9779692", log: "37.566535", bookmark: false)
//        modelContext.insert(content)
//    }
}
