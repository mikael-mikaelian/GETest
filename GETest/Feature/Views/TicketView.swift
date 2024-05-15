//
//  TicketView.swift
//  GETest
//
//  Created by Mikael Mikaelian on 5/3/24.
//

import SwiftUI

// This view represents a question in a test session.
struct TicketView: View {
    // MARK: - Properties
    // Manager object to handle the current mode of the test session.
    @EnvironmentObject var manager: Manager
    // The current question number being displayed.
    @State var currentQuestionNumber: String = ""
    @State var currentQuestionId = 0
    @State var currentQuestionIdProgress = 0
    
    
    // MARK: - Body
    var body: some View {
        VStack {
            
            // MARK: - Header
            HStack {
                // Current mode of the test session.
                Text(manager.currentMode == .language ? "ქარტული ენა" : manager.currentMode == .history ? "ისტორია" : "სამართლის საფუძვლები")
                    .font(.title2)
                    .foregroundColor(.accentColor)
                Spacer()
                // Current question number.
                Text("კითხვა №\(currentQuestionNumber)")
                    .font(.title2)
                    .foregroundColor(.accentColor)
                
                //Display the bookmark button
                Button {
                    withAnimation(.linear(duration: 0.3)) {
                        generateImpact()
                        manager.updateBookmarks(for: manager.currentMode, id: (Int(currentQuestionNumber) ?? 0)-1)
                    }
                } label: {
                    if (manager.user.getBookmarks(for: manager.currentMode).contains((Int(currentQuestionNumber) ?? 0)-1)) {
                        Image(systemName: "bookmark.fill")
                    } else {
                        Image(systemName: "bookmark")
                    }
                }
            }
            .padding()
            
            ProgressView(value: Float(Int(currentQuestionIdProgress) ), total: Float(manager.sessionTickets.count))
                .padding()
            
            // MARK: - Question
            TabView(selection: $currentQuestionId) {
                // Iterate over each ticket in the test session.
                ForEach(Array(manager.sessionTickets.enumerated()), id: \.element) { index, ticket in
                    VStack{
                        HStack {
                            // Display the question of the ticket.
                            Text(ticket.getTicketQuestion())
                                .multilineTextAlignment(.leading)
                                .padding()
                                .font(.title2)
                            Spacer()
                        }
                        
                        //MARK: - Answer Choices
                        ScrollView {
                            // Iterate over each answer choice of the ticket.
                            ForEach(ticket.getAnswerChoices(), id: \.self) { answer in
                                // Display each answer choice as a row button.
                                AnswerRowButton(answer: answer, ticket: ticket, currectTicketId: $currentQuestionId).environmentObject(manager)
                            }
                            .padding(.bottom)
                        }
                    }
                    .onAppear(){
                            // Update the current question number when the ticket appears.
                            currentQuestionNumber = ticket.getTicketNumber()
                        withAnimation(.linear(duration: 0.7)) {
                            currentQuestionIdProgress = index
                        }
                    }
                    .tag(index)
                }
            }.tabViewStyle(PageTabViewStyle())
            
            Button {
                generateImpact()
                currentQuestionId += currentQuestionId == manager.sessionTickets.count-1 ? 0 : 1
            } label: {
                HStack{
                    Spacer()
                    Text("შემდეგი შეკითხვა")
                    Spacer()
                }
                .foregroundColor(Color(.white))
                .padding()
                .background(Color.accentColor)
                .cornerRadius(20)
                .padding(.horizontal)
            }
            
            
            
        }
    }
}

// MARK: - Preview

// Preview provider for the SwiftUI canvas.
#Preview {
    MenuView()
}

// Extension to make String conform to Identifiable protocol.
extension String: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}

// This view represents a row button for an answer choice.
struct AnswerRowButton: View {
    // MARK: - Properties
    // The answer choice to be displayed.
    @StateObject var answer: Answer
    // The ticket associated with the answer choice.
    @StateObject var ticket: SessionTicket
    // Manager object to handle the test session.
    @Binding var currectTicketId: Int
    @EnvironmentObject var manager: Manager
    
    // MARK: - Body
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.3)) {
                generateImpact()
                // When the button is pressed, mark the answer as selected.
                answer.isSelected = true
                // If the answer is correct, update the progress of the ticket and the manager.
                if answer.isCorrect {
                    ticket.setProgress(progress: .correct)
                    manager.updateProgress(for: manager.currentMode, id: ticket.getTicketIntNumber(), progress: .correct)
                    currectTicketId += 1
                    
                } else {
                    // If the answer is incorrect, mark the progress of the ticket as incorrect.
                    ticket.setProgress(progress: .incorrect)
                    manager.updateProgress(for: manager.currentMode, id: ticket.getTicketIntNumber(), progress: .incorrect)
                }
            }
            
        } label: {
            HStack{
                // Display the text of the answer choice.
                Text(answer.answerText)
                Spacer()
            }
            // Set the color of the text based on whether the answer is selected or correct.
            .foregroundColor(answer.isSelected || (ticket.progress == .incorrect && answer.isCorrect) ? Color.white : Color.primary)
            .padding()
            // Set the background color based on whether the answer is selected or correct.
            .background(ticket.progress == .incorrect && answer.isCorrect ? Color.green : answer.isSelected ? answer.isCorrect ? Color.green : Color.red : Color.clear)
            .background(Material.regular)
            .cornerRadius(20)
            .padding(.horizontal)
            
        }
        
        
        // Disable the button if the progress of the ticket is not incomplete.
        .disabled(ticket.progress != .incomplete)
    }
}
