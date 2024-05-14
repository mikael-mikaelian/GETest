//
//  SessionTicket.swift
//  GETest
//
//  Created by Mikael Mikaelian on 5/13/24.
//

import Foundation
// MARK: - SessionTicket Class
class SessionTicket: Identifiable, Hashable, ObservableObject {
    // MARK: - Properties
    @Published private var ticket: Ticket
    @Published private(set) var progress: Progress = .incomplete
    @Published private var selectedAnswer = ""
    @Published private var answers: [Answer] = []
    
    let id = UUID()
    
    // MARK: - Initializer
    // Initializes the session ticket with a ticket.
    init(ticket: Ticket) {
        self.ticket = ticket
        self.answers.removeAll()
        
        for answer in ticket.getAnswerChoices() {
            answers.append(Answer(answerText: answer, isSelected: false, isCorrect: answer == ticket.correctAnswer))
            answers.shuffle()
        }
    }
    
    // MARK: - Methods
    // Sets the progress of the session ticket.
    func setProgress (progress: Progress) {
        self.progress = progress
    }
    
    // Gets the progress of the session ticket.
    func getProgress () -> Progress {
        return progress
    }
    
    // Gets the question of the ticket.
    func getTicketQuestion() -> String {
        return ticket.question
    }
    
    // Gets the number of the ticket.
    func getTicketNumber() -> String {
        return ticket.number
    }
    
    // Gets the integer number of the ticket.
    func getTicketIntNumber() -> Int {
        return Int(ticket.number) ?? -1
    }
    
    // Gets the answer choices of the ticket.
    func getAnswerChoices() -> [Answer] {
        return answers
    }
    
    // Gets the question number of the ticket.
    func getQuestionNumber() -> String {
        return ticket.number
    }
    
    // Gets the correct answer of the ticket.
    func getCorrectAnswer() -> String {
        return ticket.correctAnswer
    }
    
    // Equality operator for SessionTicket.
    static func == (lhs: SessionTicket, rhs: SessionTicket) -> Bool {
        return lhs.id == rhs.id
    }
    
    // Hash function for SessionTicket.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
