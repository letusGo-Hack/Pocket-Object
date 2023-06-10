//
//  BottomSheetViewModel.swift
//  Pocket-Object
//
//  Created by ZUMIN YOU on 2023/06/10.
//

import SwiftUI
import SwiftData

class BottomSheetViewModel: ObservableObject {
    @Published var contents: [Content] = []
    
    init() {
        
    }
}
