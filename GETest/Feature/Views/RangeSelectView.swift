//
//  RangeSelectView.swift
//  GETest
//
//  Created by Mikael Mikaelian on 5/3/24.
//

import SwiftUI

// MARK: - RangeSelectView
// This view allows the user to select a range of tickets for the test session.
struct RangeSelectView: View {
    // The manager object for the test session.
    @EnvironmentObject var manager: Manager
    
    var body: some View {
        ScrollView {
            VStack {
                HStack() {
                    NavigationLink {
                        // Navigate to the TicketView when the last range is selected.
                        TicketView().environmentObject(manager)
                    } label: {
                        HStack{
                            // Display the range text.
                            Text("შეცდომები")
                            Image(systemName: "xmark.circle")
                        }
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .fontWeight(.heavy)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                    }
                    .simultaneousGesture(TapGesture().onEnded{
                        // Set the range in the manager when a range is selected.
                        manager.fetchMistakeSessionTickets()
                    })
                    .disabled(!manager.user.getProgress(for: manager.currentMode).contains(where: {$0 == .incorrect}))
                    
                    NavigationLink {
                        // Navigate to the TicketView when the last range is selected.
                        TicketView().environmentObject(manager)
                    } label: {
                        HStack{
                            Image(systemName: "bookmark")
                        }
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .fontWeight(.heavy)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                    }
                    .simultaneousGesture(TapGesture().onEnded{
                        // Set the range in the manager when a range is selected.
                        manager.fetchBookmarksSessionTickets()
                    })
                    .disabled(manager.user.getBookmarks(for: manager.currentMode).isEmpty)
                }
                .padding()
                // Display a range selection button for each set of 20 tickets.
                ForEach(1...9, id: \.self) { index in
                    let lowerBound = ((index - 1) * 20) + 1
                    let upperBound = index * 20
                    NavigationLink {
                        // Navigate to the TicketView when a range is selected.
                        TicketView().environmentObject(manager)
                    } label: {
                        // Display the range on the button.
                        RangeSelectionButtonView(text: "\(lowerBound)-\(upperBound)")
                    }.simultaneousGesture(TapGesture().onEnded{
                        // Set the range in the manager when a range is selected.
                        manager.fetchTestSessionTickets(from: lowerBound, to: upperBound)
                    })
                }
                // Display a range selection button for the last set of tickets.
                NavigationLink{
                    // Navigate to the TicketView when the last range is selected.
                    TicketView().environmentObject(manager)
                } label: {
                    // Display the range on the button.
                    RangeSelectionButtonView(text: "180-\(manager.getTickets(for: manager.currentMode).count)")
                }.simultaneousGesture(TapGesture().onEnded{
                    // Set the range in the manager when a range is selected.
                    manager.fetchTestSessionTickets(from: 180, to: manager.getTickets(for: manager.currentMode).count)
                })
            }
        }
    }
}

// MARK: - Preview
#Preview {
    MenuView()
}

// MARK: - RangeSelectionButtonView
// This view represents a button for selecting a range of tickets.
struct RangeSelectionButtonView: View {
    // The text to display on the button.
    var text: String
    // The background color of the button.
    var background: Color = Color("AccentColor")
    
    var body: some View {
        HStack{
            // Display the range text.
            Text(text)
            Spacer()
        }
        .font(.largeTitle)
        .foregroundColor(.white)
        .fontWeight(.heavy)
        .padding()
        .background(background)
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}
