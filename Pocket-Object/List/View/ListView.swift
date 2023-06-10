//
//  ListView.swift
//  Pocket-Object
//
//  Created by ZUMIN YOU on 2023/06/10.
//

import SwiftUI

struct ListView: View {
    let viewModel = DummyListViewModel()
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    ForEach(viewModel.data, id: \.self) { _ in
                        ListItemView()
                    }
                }
            }
        }
    }
}

#Preview {
    ListView()
}
