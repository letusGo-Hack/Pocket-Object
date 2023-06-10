//
//  DummyListViewModel.swift
//  Pocket-Object
//
//  Created by ZUMIN YOU on 2023/06/10.
//

import SwiftUI

struct ListItem: Hashable {
    let objectName: String
    let data: String
    
    init(objectName: String, data: String) {
        self.objectName = objectName
        self.data = data
    }
}

class DummyListViewModel: ObservableObject {
    let data: [ListItem] = [
        ListItem(objectName: "1", data: "2"),
        ListItem(objectName: "1", data: "2"),
        ListItem(objectName: "1", data: "2"),
        ListItem(objectName: "1", data: "2"),
        ListItem(objectName: "1", data: "2"),
        ListItem(objectName: "1", data: "2"),
        ListItem(objectName: "1", data: "2"),
        ListItem(objectName: "1", data: "2"),
        
    ]
}
