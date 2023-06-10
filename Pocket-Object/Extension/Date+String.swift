//
//  Date+String.swift
//  Pocket-Object
//
//  Created by eden on 2023/06/10.
//

import Foundation

extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }

}
