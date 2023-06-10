//
//  ContentView.swift
//  Pocket-Object
//
//  Created by 구본의 on 2023/06/10.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                ToolbarItem {
                    Button(action: deleteItems) {
                        Label("Add Item", systemImage: "-")
                    }
                }
            }
            Text("Select an item")
        }
        .sheet(isPresented: $presentSheet) {
            ObjectDetailView()
        }
        .sheet(isPresented: $presentCaptureView) {
            CapturePrimaryView {
                presentCaptureView = false
            }
        }
    }

    private func addItem() {
//        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
//        }
        presentSheet = true
    }
    
    @State var presentSheet: Bool = false
    @State var presentCaptureView: Bool = false
    
    private func deleteItems() {
        presentCaptureView = true
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
