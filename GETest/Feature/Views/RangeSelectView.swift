//
//  RangeSelectView.swift
//  GETest
//
//  Created by Mikael Mikaelian on 5/3/24.
//

import SwiftUI

struct RangeSelectView: View {
    // The manager object for the test session.
    @EnvironmentObject var manager: Manager
    
    var body: some View {
        ScrollView {
            VStack {
                HStack() {
                    RangeButtonView(imageName: "xmark.circle", text: "შეცდომები: \((manager.user.getIncorrectProgressCount(mode: manager.currentMode)) == 0 ? "არარის" : "\(manager.user.getIncorrectProgressCount(mode: manager.currentMode))" )", fetchTickets: manager.fetchMistakeSessionTickets, isDisabled: !manager.user.getProgress(for: manager.currentMode).contains(where: {$0 == .incorrect})).environmentObject(manager)
                    
                    RangeButtonView(imageName: "bookmark.fill", text: "", fetchTickets: manager.fetchBookmarksSessionTickets, isDisabled: manager.user.getBookmarks(for: manager.currentMode).isEmpty).environmentObject(manager)
                }
                .padding()
                // Display a range selection button for each set of 20 tickets.
                ForEach(1...9, id: \.self) { index in
                    let lowerBound = ((index - 1) * 20) + 1
                    let upperBound = index * 20
                    RangeButtonView(text: "\(lowerBound)-\(upperBound)", fetchTickets: { manager.fetchTestSessionTickets(from: lowerBound, to: upperBound) }).environmentObject(manager)
                        .padding(.horizontal)

                }
                // Display a range selection button for the last set of tickets.
                RangeButtonView(text: "180-\(manager.getTickets(for: manager.currentMode).count)", fetchTickets: { manager.fetchTestSessionTickets(from: 180, to: manager.getTickets(for: manager.currentMode).count) }).environmentObject(manager)
                    .padding(.horizontal)
            }
        }
    }
}

struct RangeButtonView: View {
    var imageName: String = "arrow.right.circle.fill"
    var text: String
    var fetchTickets: () -> Void
    var isDisabled: Bool = false
    @EnvironmentObject var manager: Manager

    
    var body: some View {
        NavigationLink {
            // Navigate to the TicketView when the last range is selected.
            TicketView().environmentObject(manager)
        } label: {
            HStack{
                // Display the range text.
                if (imageName != "bookmark.fill"){
                    Text(text)
                        .font(.title2)
                    Spacer()
                }
                Image(systemName: imageName)
                    .font(.largeTitle)
                    .foregroundStyle(Color.accentColor)
                
            }
            .padding()
            .foregroundColor(.primary)
            .background(Material.regular)
            .cornerRadius(20)
        }
        .simultaneousGesture(TapGesture().onEnded{
            // Set the range in the manager when a range is selected.
            fetchTickets()
            generateImpact()
        })
        .disabled(isDisabled)
    }
}
