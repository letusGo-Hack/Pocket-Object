//
//  TestContentView.swift
//  Pocket-Object
//
//  Created by ZUMIN YOU on 2023/06/10.
//

import SwiftUI

struct TestContentView: View {
    @State private var showSheet = false
    
    var body: some View {
        VStack {
            Button("Show Bottom Sheet") {
                showSheet.toggle()
            }
            .buttonStyle(.borderedProminent)
            .sheet(isPresented: $showSheet) {
                BottomSheetView()
            }
            .presentationDetents([.height(200), .medium, .large])
 
            Spacer()
        }
    }
}

#Preview {
    TestContentView()
}
