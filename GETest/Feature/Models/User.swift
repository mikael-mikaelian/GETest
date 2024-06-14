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
    var historyProgress:  [(String,Progress)] = []  // Progress of the user in history category.
    var languageProgress: [(String,Progress)] = []  // Progress of the user in language category.
    var lawProgress:      [(String,Progress)] = []  // Progress of the user in law category.
    
    var languageBookmarksIds: [String] = []
    var historyBookmarksIds:  [String] = []
    var lawBookmarksIds:      [String] = []
    
    
    func getProgress(for mode: TestMode) -> [(String,Progress)] {
        switch mode {
        case .language:
            return languageProgress
        case .history:
            return historyProgress
        case .law:
            return lawProgress
        }
    }
    
    func getBookmarks(for mode: TestMode) -> [String] {
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
            return languageProgress.filter { $0.1 == .correct }.count
        case .history:
            return historyProgress.filter { $0.1 == .correct }.count
        case .law:
            return lawProgress.filter { $0.1 == .correct }.count
        }
    }
    
    // Method to get the progress of the user based on the mode.
    func getIncorrectProgressCount (mode: TestMode) -> Int {
        switch mode {
        case .language:
            return languageProgress.filter { $0.1 == .incorrect }.count
        case .history:
            return historyProgress.filter { $0.1 == .incorrect }.count
        case .law:
            return lawProgress.filter { $0.1 == .incorrect }.count
        }
    }
    
    // Updates the progress of a specific ticket based on the mode.
    mutating func updateProgress(for mode: TestMode, id: String, progress: Progress) {
        switch mode {
        case .language:
            if let index = languageProgress.firstIndex(where: {$0.0 == id}) {
                languageProgress[index].1 = progress
            } else {
                languageProgress.append((id, progress))
            }
        case .history:
            if let index = historyProgress.firstIndex(where: {$0.0 == id}) {
                historyProgress[index].1 = progress
            } else {
                historyProgress.append((id, progress))
            }
        case .law:
            if let index = lawProgress.firstIndex(where: {$0.0 == id}) {
                lawProgress[index].1 = progress
            } else {
                lawProgress.append((id, progress))
            }
        }
    }

    
    mutating func updateBookmarks(for mode: TestMode, id: String) {
        // Computed property to get and set the appropriate bookmark IDs based on the currentMode
        var bookmarksIds: [String]
        
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

    mutating func updateProgress(progressArray: [(String,Progress)], mode: TestMode) {
        switch mode {
        case .language:
            languageProgress = progressArray
        case .history:
            historyProgress = progressArray
        case .law:
            lawProgress = progressArray
        }
    }

    
    mutating func setBookmarks(for mode: TestMode, bookmarks: [String]) {
        switch mode {
        case .language:
            languageBookmarksIds = bookmarks
        case .history:
            historyBookmarksIds = bookmarks
        case .law:
            lawBookmarksIds = bookmarks
        }
    }
}

// Enum for the progress of a ticket.
enum Progress: String {
    case correct = "correct"
    case incorrect = "incorrect"
    case incomplete = "incomplete"
}
