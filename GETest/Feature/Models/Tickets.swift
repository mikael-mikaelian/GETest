//
//  Ticket.swift
//  GETest
//
//  Created by Mikael Mikaelian on 5/3/24.
//

import Foundation

// MARK: - Tickets Struct
// This struct represents a collection of tickets for different categories.
struct Tickets: Codable {
    var languageTickets: [Ticket] // Tickets for language category.
    var historyTickets:  [Ticket] // Tickets for history category.
    var lawTickets:      [Ticket] // Tickets for law category.
}

// MARK: - Ticket Struct
// This struct represents a single ticket.
struct Ticket: Codable, Identifiable, Hashable {
    
    // Unique identifier for each ticket.
    var id: UUID {
        UUID()
    }
    
    var number:   String           // Number of the ticket.
    var question: String           // Question of the ticket.
    var incorrectAnswers: [String] // Incorrect answers for the ticket's question.
    var correctAnswer:     String  // Correct answer for the ticket's question.
    
    // Method to get all answer choices for the ticket's question.
    func getAnswerChoices() -> [String] {
        var answerChoices: [String] = []
        answerChoices = self.incorrectAnswers
        answerChoices.append(correctAnswer)
        return answerChoices
    }
}
