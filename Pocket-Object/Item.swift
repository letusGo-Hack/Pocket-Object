//
//  Item.swift
//  Pocket-Object
//
//  Created by 구본의 on 2023/06/10.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
