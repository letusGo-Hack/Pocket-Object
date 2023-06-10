//
//  DirectoryManager.swift
//  Pocket-Object
//
//  Created by eden on 2023/06/10.
//

import Foundation

struct DirectoryManager {
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
