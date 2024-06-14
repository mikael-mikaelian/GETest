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
    var languageTickets: LanguageTickets  // Tickets for language category.
    var historyTickets:  HistoryTickets   // Tickets for history category.
    var lawTickets:      LawTickets       // Tickets for law category.
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

struct LanguageTickets: Codable {
    var chapters: [Chapter]
    
    func getTicketsCount() -> Int {
        var totalCount = 0
        
        for chapter in chapters {
            for topic in chapter.topics {
                totalCount += topic.tickets.count
            }
        }
        
        return totalCount
    }
    
    func getTickets() -> [Ticket] {
        var tickets: [Ticket] = []
        
        for chapter in chapters {
            for topic in chapter.topics {
                tickets += topic.tickets
            }
        }
        
        return tickets
    }
    
    func getTickets(chapterName: String, topicName: String) -> [Ticket] {
        return chapters.first(where:{$0.chapterName == chapterName})?.topics.first(where: {$0.topicName == topicName})?.tickets ?? []
    }
}

struct HistoryTickets: Codable {
    var topics: [Topic]
    
    func getTicketsCount() -> Int {
        var totalCount = 0
        
        for topic in topics {
            totalCount += topic.tickets.count
        }
        
        return totalCount
    }
    
    func getTickets() -> [Ticket] {
        var tickets: [Ticket] = []
        
        for topic in topics {
            tickets += topic.tickets
        }
        
        return tickets
    }
    
    func getTickets(topicName: String) -> [Ticket] {
        
        return topics.first(where:{$0.topicName == topicName})?.tickets ?? []
    }
}
struct LawTickets: Codable {
    var tickets: [Ticket]
    
    func getTicketsCount() -> Int {
        return tickets.count
    }
    
    func getTickets() -> [Ticket] {
        return tickets
    }
}

struct Chapter: Codable {
    
    var chapterName: String
    var topics: [Topic]
}


struct Topic: Codable {
    var id: UUID {
        UUID()
    }
    
    var topicName: String
    var tickets: [Ticket]
}
