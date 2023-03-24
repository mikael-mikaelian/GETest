//
//  QuestionView.swift
//  GETest
//
//  Created by Mikael Mikaelian on 1/30/23.
//

import SwiftUI

struct TicketView<T: TicketEntityProtocol>: View {
    @EnvironmentObject var questionsManager: QuestionsManager<T>
    var body: some View {
        VStack {
            
            HStack {
                Text("ქართული ენა")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(.accentColor)
                Spacer()
                Text("ბილეთი ნ.\(questionsManager.number)")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(.accentColor)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    //MARK: - create chosen view
                    ForEach(questionsManager.getStartIndex()..<questionsManager.getEndIndex()+1, id: \.self) { index in
                        ticketBoxView<T>(index: index, isCurrent: questionsManager.isCurrent[index])
                            .onTapGesture {
                                questionsManager.setTicket(index)
                            }
                    }
                }
                
            }
            
            HStack {
                Text(questionsManager.question)
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
                Spacer()
            }
            .padding()
            .background(Material.regularMaterial)
            
            ScrollView {
                
                ForEach(questionsManager.answerChoices.indices, id:\.self) { index in
                    AnswerRow<T>(index: index, answer: questionsManager.answerChoices[index]).environmentObject(questionsManager)
                }
                
                Button {
                    questionsManager.nextTicket()
                } label: {
                    HStack {
                        Spacer()
                        Text("შემდეგი")
                        Spacer()
                    }
                    .padding()
                    .background(Material.regular)
                    .cornerRadius(15)
                    .fontWeight(.semibold)
                    .padding(.horizontal)
                }
                Spacer()
            }
        }
    }
}


struct ticketBoxView<T : TicketEntityProtocol> : View {
    var index: Int
    var isCurrent: Bool
    @EnvironmentObject var questionsManager: QuestionsManager<T>
    
    var body: some View {
        Text("\(index+1)")
            .frame(width: isCurrent ? 30 : 25, height: isCurrent ? 30  : 25)
            .foregroundColor(.white)
            .padding(.maximum(5, 5))
            .background(questionsManager.isCompleted[index] ? questionsManager.isCompletedCorrectly[index] ? Color.green : Color.red : Color.gray.opacity(0.3))
            .cornerRadius(10)
        
    }
}
