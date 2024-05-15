// ContentView.swift
// GETest
// Created by Mikael Mikaelian on 5/3/24.

import SwiftUI

// MARK: - Main view of the application
struct MenuView: View {
    @StateObject var manager = Manager() // Manager object to handle data
    let totalTestPreparations = 611 // Total number of test preparations

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HeaderView() // Header view with emoji and title

                ProgressViewContainer().environmentObject(manager) // Container for progress views

                Spacer() // Spacer for layout

                TestSelectionButtons().environmentObject(manager) // Buttons for test selection
            }
        }
        
    }
}

// MARK: - Header view with emoji and title
struct HeaderView: View {
    var body: some View {
        VStack {
            /*
            Image("Flag")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 120)
                .padding()*/
            Text("🇬🇪").font(.system(size: 120)) // Emoji text
            Text("საქართველოს მოქალაქეობის ტესტები") // Title text
                .font(.title3)
                .fontWeight(.heavy)
                .foregroundColor(.accentColor)
                .multilineTextAlignment(.center)
        }
    }
}

// MARK: - Container for progress views
struct ProgressViewContainer: View {
    @EnvironmentObject var manager: Manager // Manager object to handle data

    var body: some View {
        VStack(spacing: 20){
            // Progress views for each category
            ProgressViewRow(title: "თქვენი პროგრესი", count: 611, value: manager.user.getCorrectProgressCount(mode: .history) + manager.user.getCorrectProgressCount(mode: .law) + manager.user.getCorrectProgressCount(mode: .language))
                .padding(.bottom)
            ProgressViewRow(title: "ქართულ ენაში", count: manager.tickets?.languageTickets.count ?? 0, value: manager.user.getCorrectProgressCount(mode: .language))
            ProgressViewRow(title: "ისტორიაში", count: manager.tickets?.historyTickets.count ?? 0, value: manager.user.getCorrectProgressCount(mode: .history))
            ProgressViewRow(title: "სამართლის საფუძვლებში", count: manager.tickets?.lawTickets.count ?? 0, value: manager.user.getCorrectProgressCount(mode: .law))
        }
        .padding() // Padding for layout
    }
}

// MARK: - Single row of progress view
struct ProgressViewRow: View {
    let title: String // Title for the row
    let count: Int // Count for the progress
    let value: Int

    var body: some View {
        VStack {
            HStack {
                Text(title) // Title text
                Spacer() // Spacer for layout
                Text("\(count)-დან \(value)") // Count text
            }

            ProgressView(value: Float(value), total: Float(count))
        }
    }
}

// MARK: - Buttons for test selection
struct TestSelectionButtons: View {
    @EnvironmentObject var manager: Manager // An observed object that manages the data

    // A list of test modes and their corresponding titles
    // Each tuple contains a mode and a title
    let testModes: [(mode: TestMode, title: String)] = [
        (.language, "ქარტული ენა"), // Georgian language test
        (.history, "ისტორია"), // History test
        (.law, "სამართლის საფუძვლები") // Law foundations test
    ]

    var body: some View {
        VStack(spacing: 20) {
            // Iterate over the test modes
            ForEach(testModes, id: \.mode) { testMode in
                // For each test mode, create a navigation link to the RangeSelectView
                NavigationLink {
                    RangeSelectView().environmentObject(manager) // Pass the manager to the RangeSelectView
                } label: {
                    TestSelectionButtonView(text: testMode.title)
                }.simultaneousGesture(TapGesture().onEnded{
                    // When the navigation link is tapped, set the mode in the manager
                    manager.setMode(mode: testMode.mode)
                })
            }
        }
    }
}

// MARK: - Preview for the main view
#Preview {
    MenuView()
}

// MARK: - Test Selection Button View
struct TestSelectionButtonView: View {
    var text: String
    var background: Color = Color("AccentColor")
    
    var body: some View {
        HStack{
            Spacer()
            Text(text)
            Spacer()
        }
        .foregroundColor(Color(.white))
        .fontWeight(.heavy)
        .padding()
        .background(background)
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}
