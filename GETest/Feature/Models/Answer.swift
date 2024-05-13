//
//  Answer.swift
//  GETest
//
//  Created by Mikael Mikaelian on 5/13/24.
//

import Foundation

// MARK: - Answer Class
class Answer: Identifiable, Hashable, ObservableObject {
    // MARK: - Properties
    let id = UUID()
    var answerText: String = ""
    @Published var isSelected = false
    var isCorrect: Bool
    
    // MARK: - Initializer
    // Initializes the answer with an answer text, selection status, and correctness.
    init(answerText: String, isSelected: Bool = false, isCorrect: Bool) {
        self.answerText = answerText
        self.isSelected = isSelected
        self.isCorrect = isCorrect
    }
    
    // Equality operator for Answer.
    static func == (lhs: Answer, rhs: Answer) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Hash function for Answer.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
