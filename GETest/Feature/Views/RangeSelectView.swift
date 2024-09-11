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
    
    //
    var body: some View {
        ScrollView {
            VStack {
                HStack() {
                    RangeButtonView(mistakes: manager.user.getIncorrectProgressCount(mode: manager.currentMode), imageName: "xmark.circle", isDisabled: !manager.user.getProgress(for: manager.currentMode).contains(where: {$0.1 == .incorrect}), selectionIsPresented: $selectionIsPresented).environmentObject(manager)
                    
                    RangeButtonView(imageName: "bookmark.fill", isDisabled: manager.user.getBookmarks(for: manager.currentMode).isEmpty, selectionIsPresented: $selectionIsPresented).environmentObject(manager)
                    
                    RangeButtonView(exam: true, imageName: "arrow.triangle.2.circlepath.doc.on.clipboard", selectionIsPresented: $selectionIsPresented).environmentObject(manager)
                    
                }.padding()
                // Display a range selection button for each set of 20 tickets.
                 
                if manager.currentMode == .language {
                    ForEach(manager.getChapters(for: manager.currentMode), id: \.self) { chapter in
                        Text(chapter)
                            .font(.title3)
                        ForEach(manager.getTopics(for: manager.currentMode, chapterName: chapter)) { topic in
                            RangeButtonView(topic: topic, chapter: chapter, selectionIsPresented: $selectionIsPresented)
                                .padding(.horizontal)
                        }
                    }
                } else if manager.currentMode == .history {
                    ForEach(manager.getTopics(for: manager.currentMode)) { topic in
                        RangeButtonView(topic: topic, selectionIsPresented: $selectionIsPresented)
                            .padding(.horizontal)
                    }
                } else if manager.currentMode == .law {
                    ForEach(1...10, id: \.self) { index in
                        RangeButtonView(range: (((index - 1) * 20) + 1,index * 20), selectionIsPresented: $selectionIsPresented)
                            .padding(.horizontal)
                    }
                }
                
                
                RangeButtonView(all: true, selectionIsPresented: $selectionIsPresented)
                    .padding()
            }
        }
        if selectionIsPresented {
            HStack {
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        manager.switchShuffle()
                    }
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
                    //manager.fetchTestSessionTickets(from: <#[Ticket]#>)
                })
                Spacer()
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectionIsPresented = false
                    }
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
    var topic       : String?
    var chapter     : String?
    var range       : (Int, Int)?
    var mistakes    : Int?
    var exam        : Bool?
    var all         : Bool?
    var imageName   : String = "arrow.right.circle.fill"
    var isDisabled  : Bool = false
    @EnvironmentObject var manager: Manager
    @Binding var selectionIsPresented: Bool
    @State var selected = false
    
    var body: some View {
        HStack {
            if imageName == "arrow.right.circle.fill" {
                if selectionIsPresented {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selected = !selected
                            //manager.switchRange(from: lowerBound, to: upperBound)
                        }
                    } label: {
                        if !selected {
                            Image(systemName: "circle")
                                .font(.title)
                                .transition(.scale)
                        } else {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title)
                                .transition(.scale)
                        }
                    }
                }
            }
            NavigationLink {
                // Navigate to the TicketView when the last range is selected.
                TicketView().environmentObject(manager)
            } label: {
                HStack {
                    if let topic = topic {
                        Text(topic)
                            .font(.title2)
                        Spacer(minLength: 20)
                        
                    } else if let range = range {
                        Text("\(range.0)-\(range.1)")
                        Spacer(minLength: 20)
                    } else if let mistakes = mistakes {
                        Text("შეცდომები: \(mistakes == 0 ? "არარის" : "\(mistakes)")")
                           
                        Spacer()
                    } else if let all = all {
                        Text("ყვალა კითხვა")
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
                if exam == true {
                    manager.fetchExamTickets()
                } else if all == true {
                    manager.fetchAllTickets() }
                else {
                    switch imageName {
                    case "bookmark.fill":
                        manager.fetchBookmarksSessionTickets()
                    case "xmark.circle":
                        manager.fetchMistakeSessionTickets()
                    default:
                        manager.fetchTestSessionTickets(chapterName: chapter, topicName: topic, range: range)
                    }
                }
            })
            
            .disabled(isDisabled || selectionIsPresented)
        }
    }
}
// MARK: - Preview for the main view
#Preview {
    MenuView()
}
