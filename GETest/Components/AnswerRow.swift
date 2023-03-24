//
//  AnswerRow.swift
//  GETest
//
//  Created by Mikael Mikaelian on 1/30/23.
//

import SwiftUI

struct AnswerRow<T: TicketEntityProtocol>: View {
    var index: Int
    @EnvironmentObject var questionsManager: QuestionsManager<T>
    var answer: Answer

    var body: some View {
        
        Button {
            if !questionsManager.isCompleted[questionsManager.index] {
                questionsManager.setTextOfSelectedAnswer(answer.text)
                questionsManager.completeTicket()
                if answer.isCorrect {
                    questionsManager.isCompletedCorrectly[questionsManager.index] = true
                    questionsManager.updateTicket(entity: questionsManager.ticketsCoplitionStatusStorage[questionsManager.index], progressStatus: 2)
                    questionsManager.nextTicket()
                }
                else {
                    questionsManager.isCompletedCorrectly[questionsManager.index] = false
                    questionsManager.updateTicket(entity: questionsManager.ticketsCoplitionStatusStorage[questionsManager.index], progressStatus: 1)
                }
            }
        } label: {
            HStack {
                Text(answer.text)
                Spacer()
            }
            .padding()
            .background(questionsManager.isCompleted[questionsManager.index] ? (answer.isCorrect ? (Color.green) : ( questionsManager.textOfSelectedAnswer[questionsManager.index] == answer.text ? Color.red : nil )) : (nil) )
            .background(Material.regularMaterial)
            .foregroundColor(questionsManager.isCompleted[questionsManager.index] ? (answer.isCorrect ? (Color.white) : ( questionsManager.textOfSelectedAnswer[questionsManager.index] == answer.text ? Color.white : Color(uiColor: .label) )) : (Color(uiColor: .label)) )
            .cornerRadius(15)
            .padding(.horizontal)
        }
    }
}
