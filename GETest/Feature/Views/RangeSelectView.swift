//
//  RangeSelectView.swift
//  GETest
//
//  Created by Mikael Mikaelian on 5/3/24.
//

import SwiftUI

// MARK: - RangeSelectView
// A view that allows the user to select a range of tickets for the test session.
struct RangeSelectView: View {
    // The manager object for the test session.
    @EnvironmentObject var manager: Manager
    @State var selectionIsPresented = false
    
    var body: some View {
        ScrollView {
            VStack {
                HStack() {
                    RangeButtonView(imageName: "xmark.circle", text: "შეცდომები: \((manager.user.getIncorrectProgressCount(mode: manager.currentMode)) == 0 ? "არარის" : "\(manager.user.getIncorrectProgressCount(mode: manager.currentMode))" )", fetchTickets: manager.fetchMistakeSessionTickets, isDisabled: !manager.user.getProgress(for: manager.currentMode).contains(where: {$0 == .incorrect}), selectionIsPresented: $selectionIsPresented).environmentObject(manager)
                    
                    RangeButtonView(imageName: "bookmark.fill", text: "", fetchTickets: manager.fetchBookmarksSessionTickets, isDisabled: manager.user.getBookmarks(for: manager.currentMode).isEmpty, selectionIsPresented: $selectionIsPresented).environmentObject(manager)
                }
                .padding()
                // Display a range selection button for each set of 20 tickets.
                ForEach(1...9, id: \.self) { index in
                    let lowerBound = ((index - 1) * 20) + 1
                    let upperBound = index * 20
                    RangeButtonView(lowerBound:lowerBound, upperBound: upperBound, fetchTickets: { manager.fetchTestSessionTickets(from: lowerBound, to: upperBound) }, selectionIsPresented: $selectionIsPresented).environmentObject(manager)
                        .simultaneousGesture(LongPressGesture(minimumDuration: 0.5, maximumDistance: 10).onEnded({ (b) in
                            generateImpact()
                            selectionIsPresented = true
                        }))
                        .padding(.horizontal)
                }
                // Display a range selection button for the last set of tickets.
                RangeButtonView(lowerBound:180, upperBound: manager.getTickets(for: manager.currentMode).count, fetchTickets: { manager.fetchTestSessionTickets(from: 180, to: manager.getTickets(for: manager.currentMode).count) }, selectionIsPresented: $selectionIsPresented).environmentObject(manager)
                    .padding(.horizontal)
            }
        }
        if selectionIsPresented {
            HStack {
                Button {
                    manager.switchShuffle()
                } label: {
                    VStack{
                        Image(systemName: manager.doShuffle ? "shuffle.circle.fill" : "shuffle.circle")
                            .font(.title)
                        Text("ჩარევა")
                            .foregroundColor(.primary)
                    }
                }
                Spacer()
                NavigationLink {
                    // Navigate to the TicketView when the last range is selected.
                    TicketView().environmentObject(manager)
                } label: {
                    VStack {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.title)
                        Text("დაწყება")
                            .foregroundColor(.primary)
                    }
                }
                .simultaneousGesture(TapGesture().onEnded{
                    // When the navigation link is tapped, set the mode in the manager
                    manager.fetchTestSessionTickets()
                })
                Spacer()
                Button {
                    selectionIsPresented = false
                } label: {
                    VStack {
                        Image(systemName: "x.circle")
                            .font(.title)
                        Text("გაუქმება")
                            .foregroundColor(.primary)

                    }
                }
            }.padding()
        }
    }
    
}

// MARK: - RangeButtonView
// A view that represents a button for selecting a range of tickets.
struct RangeButtonView: View {
    var imageName: String = "arrow.right.circle.fill"
    var text: String = ""
    var lowerBound: Int = 0
    var upperBound: Int = 0
    var fetchTickets: () -> Void
    var isDisabled: Bool = false
    @EnvironmentObject var manager: Manager
    @Binding var selectionIsPresented: Bool
    @State var selected = false
    
    var body: some View {
        HStack {
            if imageName == "arrow.right.circle.fill" {
                if selectionIsPresented {
                    Button {
                        selected = !selected
                        manager.switchRange(from: lowerBound, to: upperBound)
                    } label: {
                        if !selected {
                            Image(systemName: "circle")
                                .font(.title)
                        } else {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title)
                        }
                    }
                }
            }
            NavigationLink {
                // Navigate to the TicketView when the last range is selected.
                TicketView().environmentObject(manager)
            } label: {
                HStack{
                    // Display the range text.
                    if (imageName != "bookmark.fill"){
                        Text(imageName == "arrow.right.circle.fill" ? "\(lowerBound)-\(upperBound)" : "შეცდომები")
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
            .disabled(isDisabled || selectionIsPresented)
        }
    }
}
// MARK: - Preview for the main view
#Preview {
    MenuView()
}
