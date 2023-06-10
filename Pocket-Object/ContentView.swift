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
                .onDelete(perform: deleteItems)
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
            }
            Text("Select an item")
        }
        .sheet(isPresented: $presentCaptureView, content: {
            CapturePrimaryView(onDismiss: {
                presentCaptureView = false
            })
        })
    }

    private func addItem() {
        presentCaptureView = true
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
    
    @State var presentCaptureView: Bool = false
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
