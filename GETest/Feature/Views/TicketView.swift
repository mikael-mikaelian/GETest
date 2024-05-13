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
    // Manager object to handle the test session.
    
    
    // MARK: - Body
    var body: some View {
        VStack {
            
            // MARK: - Header
            HStack {
                // Display the current mode of the test session.
                Text(manager.currentMode == .language ? "ქარტული ენა" : manager.currentMode == .history ? "ისტორია" : "სამართლის საფუძვლები")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(.accentColor)
                Spacer()
                // Display the current question number.
                Text("კითხვა №\(currentQuestionNumber)")
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(.accentColor)
            }
            .padding(.horizontal)
                
            // MARK: - Question
            TabView(){
                // Iterate over each ticket in the test session.
                ForEach(manager.sessionTickets, id: \.self) {ticket in
                    VStack{
                        HStack {
                            // Display the question of the ticket.
                            Text(ticket.getTicketQuestion())
                                .multilineTextAlignment(.leading)
                                .padding()
                            Spacer()
                        }
                        .background(Material.regular)

                        //MARK: - Answer Choices
                        ScrollView {
                            // Iterate over each answer choice of the ticket.
                            ForEach(ticket.getAnswerChoices(), id: \.self) { answer in
                                // Display each answer choice as a row button.
                                AnswerRowButton(answer: answer, ticket: ticket).environmentObject(manager)
                            }
                            .padding(.top)
                        }
                    }
                    .onAppear(){
                        // Update the current question number when the ticket appears.
                        currentQuestionNumber = ticket.getTicketNumber()
                    }
                    
                }
            }.tabViewStyle(PageTabViewStyle())
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
    @EnvironmentObject var manager: Manager
    
    // MARK: - Body
    var body: some View {
        Button {
            // When the button is pressed, mark the answer as selected.
            answer.isSelected = true
            // If the answer is correct, update the progress of the ticket and the manager.
            if answer.isCorrect {
                ticket.setProgress(progress: .correct)
                manager.updateProgress(id: ticket.getTicketIntNumber(), progress: .correct)
            } else {
                // If the answer is incorrect, mark the progress of the ticket as incorrect.
                ticket.setProgress(progress: .incorrect)
                manager.updateProgress(id: ticket.getTicketIntNumber(), progress: .incorrect)
            }
            
        } label: {
            HStack{
                Spacer()
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
