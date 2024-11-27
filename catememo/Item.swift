//
//  Item.swift
//  catememo
//
//  Created by Yuma on 2024/11/27.
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
