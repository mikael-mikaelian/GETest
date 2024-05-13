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
    
    var languageBookmarksIds: [Int] = []
    var historyBookmarksIds:  [Int] = []
    var lawBookmarksIds:      [Int] = []
    
    
    func getProgress(for mode: TestMode) -> [Progress] {
        switch mode {
        case .language:
            return languageProgress
        case .history:
            return historyProgress
        case .law:
            return lawProgress
        }
    }
    
    func getBookmarks(for mode: TestMode) -> [Int] {
        switch mode {
        case .language:
            return languageBookmarksIds
        case .history:
            return historyBookmarksIds
        case .law:
            return lawBookmarksIds
        }
    }
    
    // Method to get the progress of the user based on the mode.
    func getCorrectProgressCount (mode: TestMode) -> Int {
        switch mode {
        case .language:
            return languageProgress.filter { $0 == .correct }.count
        case .history:
            return historyProgress.filter { $0 == .correct }.count
        case .law:
            return lawProgress.filter { $0 == .correct }.count
        }
    }
    
    // Updates the progress of a specific ticket based on the mode.
    mutating func updateProgress(for mode: TestMode, id: Int, progress: Progress) {
        switch mode {
        case .language:
            languageProgress[id-1] = progress
        case .history:
            historyProgress[id-1] = progress
        case .law:
            lawProgress[id-1] = progress
        }
    }
    
    mutating func updateBookmarks(for mode: TestMode, id: Int) {
        // Computed property to get and set the appropriate bookmark IDs based on the currentMode
        var bookmarksIds: [Int]
        
        switch mode {
        case .language:
            bookmarksIds = languageBookmarksIds
        case .history:
            bookmarksIds = historyBookmarksIds
        case .law:
            bookmarksIds = lawBookmarksIds
        }
        
        if let index = bookmarksIds.firstIndex(of: id) {
            // If it does, remove it
            bookmarksIds.remove(at: index)
        } else {
            // If not, add it
            bookmarksIds.append(id)
        }
        
        switch mode {
        case .language:
            languageBookmarksIds = bookmarksIds
        case .history:
            historyBookmarksIds = bookmarksIds
        case .law:
            lawBookmarksIds = bookmarksIds
        }
    }
    
}
