//
//  Answer.swift
//  GETest
//
//  Created by Mikael Mikaelian on 1/30/23.
//

import Foundation

struct Answer: Identifiable {
    var id = UUID()
    var text: AttributedString
    var isCorrect: Bool
    
    
    mutating func toCorrect () {
        isCorrect.toggle()
    }
}
