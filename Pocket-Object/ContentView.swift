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
    @State var presentDetailView = false
    
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
                    Button{
                        edit()
                    } label: {
                        Text("Edit")
                    }
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
        .sheet(isPresented: $presentDetailView, content: {
            Viewer3D()
        })
        .sheet(isPresented: $presentCaptureView, content: {
            CapturePrimaryView(onDismiss: {
                presentCaptureView = false
            })
        })
        .onAppear {
            CaptureManager.shared.start()
        }
    }

    private func addItem() {
        presentCaptureView = true
    }
    
    private func edit() {
        presentDetailView = true
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
