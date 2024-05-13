//
//  User.swift
//  GETest
//
//  Created by Mikael Mikaelian on 5/12/24.
//

import Foundation

// MARK: - User Struct
// This struct represents a user in the test session.
struct User {
    
   
    var historyProgress:  [Progress] = []  // Progress of the user in history category.
    var languageProgress: [Progress] = []  // Progress of the user in language category.
    var lawProgress:      [Progress] = []  // Progress of the user in law category.
    
    // Method to get the progress of the user based on the mode.
    func getProgress (mode: TestMode) -> Int {
        switch mode {
        case .language:
            return languageProgress.filter { $0 == .correct }.count
        case .history:
            return historyProgress.filter { $0 == .correct }.count
        case .law:
            return lawProgress.filter { $0 == .correct }.count
        }
    }
}
