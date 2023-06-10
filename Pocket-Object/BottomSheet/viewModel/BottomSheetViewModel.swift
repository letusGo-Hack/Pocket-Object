//
//  BottomSheetViewModel.swift
//  Pocket-Object
//
//  Created by ZUMIN YOU on 2023/06/10.
//

import SwiftUI
import SwiftData

class BottomSheetViewModel: ObservableObject {
    @Query(sort: \.title, order: .forward, animation: .default) var allContent: [Content]
}
