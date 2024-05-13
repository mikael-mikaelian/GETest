//
//  Manager.swift
//  GETest
//
//  Created by Mikael Mikaelian on 5/3/24.
//

import Foundation

// MARK: - Manager Class
class Manager: ObservableObject {
    // MARK: - Properties
    // User object for the test session.
    @Published private(set) var user = User()
    // Tickets for the test sessions.
    @Published private(set) var tickets: Tickets?
    // Tickets for a specified test
    @Published private(set) var sessionTickets: [SessionTicket] = []
    // Current mode of the test session.
    private(set) var currentMode: TestMode = .language
    // Range of tickets for the test session.
    @Published private(set) var rangeTickets: [Ticket] = []
    
    // MARK: - Initializer
    // Fetches tickets on initialization.
    init() {
        Task.init {
            fetchTickets()
        }
    }
    
    // MARK: - Methods
    // Fetches tickets from a JSON file.
    func fetchTickets() {
        //JSON decoder
        if let url = Bundle.main.url(forResource: "tickets", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedData = try decoder.decode(Tickets.self, from: data)
                DispatchQueue.main.async { [self] in
                    tickets = decodedData
                    fetchProgress()
                }
            } catch {
                print("error:\(error)")
            }
        }
    }
    
    // Fetches the test session tickets within a given range
    func fetchTestSessionTickets(from lowerBound: Int, to upperBound: Int) {
        // Clearing the existing session tickets
        sessionTickets.removeAll()
        
        var count = lowerBound-1
        // Fetching the tickets for the current mode
        let currentModeTickets = getCurrentModeTickets()
        
        // Looping through the range and adding the tickets to the session
        repeat {
            sessionTickets.append(SessionTicket(ticket: currentModeTickets[count]))
            count += 1
        } while (count < upperBound)
    }

    // Fetches the session tickets where the user made a mistake
    func fetchMistakeSessionTickets() {
        // Fetching the progress based on the current mode
        let progresses: [Progress] =
        switch currentMode {
        case .language:
            user.languageProgress
        case .history:
            user.historyProgress
        case .law:
            user.lawProgress
        }
        
        // Fetching the tickets based on the current mode
        let tickets: [Ticket] =
        switch currentMode {
        case .language:
            tickets!.languageTickets
        case .history:
            tickets!.languageTickets
        case .law:
            tickets!.languageTickets
        }
        
        // Clearing the existing session tickets
        sessionTickets.removeAll()
        
        // Looping through the progress and adding the incorrect tickets to the session
        for (id, progress) in progresses.enumerated() {
            if progress == .incorrect {
                sessionTickets.append(SessionTicket(ticket:tickets[id] ))
            }
        }
    }

    
    // Fetches progress for each category of tickets.
    func fetchProgress() {
        user.languageProgress = Array(repeating: .incomplete, count: tickets?.languageTickets.count ?? 0)
        
        user.historyProgress = Array(repeating: .incomplete, count: tickets?.historyTickets.count ?? 0)
        
        user.lawProgress = Array(repeating: .incomplete, count: tickets?.lawTickets.count ?? 0)
    }
    
    // Returns the current tickets based on the mode.
    func getCurrentModeTickets() -> [Ticket] {
        switch currentMode {
        case .language:
            return tickets!.languageTickets
        case .history:
            return tickets!.historyTickets
        case .law:
            return tickets!.lawTickets
        }
    }
    
    // Sets the mode of the test session.
    func setMode(mode: TestMode) { // Accept a TestMode value
        currentMode = mode
    }
    
    // Updates the progress of a specific ticket based on the mode.
    func updateProgress(id: Int, progress: Progress) {
        
        switch currentMode {
        case .language:
            user.languageProgress[id-1] = progress
        case .history:
            user.historyProgress[id-1] = progress
        case .law:
            user.lawProgress[id-1] = progress
        }
        
    }
}

// Enum for the mode of the test session.
enum TestMode: String {
    case language = "language"
    case history = "history"
    case law = "law"
}

// Enum for the progress of a ticket.
enum Progress: String {
    case correct = "correct"
    case incorrect = "incorrect"
    case incomplete = "incomplete"
}
