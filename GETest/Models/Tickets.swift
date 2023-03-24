//
//  Question.swift
//  GETest
//
//  Created by Mikael Mikaelian on 1/30/23.
//

import Foundation

//MARK: - Arrray of the questions

struct Tickets: Decodable {
    var tickets: [Ticket]
    
    //MARK: - Ticket's structure
    
    struct Ticket: Decodable, Identifiable{
        
        var id: UUID {
            UUID()
        }
        var number: String
        var question: String
        var incorrectAnswers: [String]
        var correctAnswer: String
        
        
        var formattedNumber: AttributedString {
            do {
                return try AttributedString(markdown: number)
            } catch {
                print(error)
                return ""
            }
        }
        
        var formattedQuestion: AttributedString {
            do {
                return try AttributedString(markdown: question)
            } catch {
                print(error)
                return ""
            }
        }
        
        var formattedAnswers: [Answer] {
            do {
                var allAnswers = try incorrectAnswers.map { answer in
                    Answer(text: try AttributedString(markdown: answer), isCorrect: false)
                }
                
                allAnswers.append(Answer(text: try AttributedString(markdown: correctAnswer), isCorrect: true))
                
                allAnswers.shuffle()
                
                return allAnswers
                
            } catch {
                return[]
            }
        }
    }
}
