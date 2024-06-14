//
//  ActivityWidget.swift
//  GETest
//
//  Created by Mikael Mikaelian on 5/19/24.
//

import Foundation
import ActivityKit

struct ActivityWidget: ActivityAttributes {
    public typealias Status = ContentState
    
    public struct ContentState: Codable, Hashable {
        var startTime: Date
    }
}
