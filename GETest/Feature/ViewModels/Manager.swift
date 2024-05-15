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
    let coreDataManager = CoreDataManager()
    
    // Current mode of the test session.
    private(set) var currentMode: TestMode = .language
    
    // User object for the test session.
    @Published              var user = User()
    // Tickets for the test sessions.
    @Published private(set) var tickets: Tickets?
    // Tickets for a specified test
    @Published private(set) var sessionTickets: [SessionTicket] = []
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
                    fetchSavedBookmarks()
                    fetchSavedProgress()
                }
            } catch {
                print("error:\(error)")
            }
        }
    }
    
    func fetchSavedBookmarks() {
        user.languageBookmarksIds = coreDataManager.fetchSavedBookmarks(for: .language)
        user.historyBookmarksIds = coreDataManager.fetchSavedBookmarks(for: .history)
        user.lawBookmarksIds = coreDataManager.fetchSavedBookmarks(for: .law)
    }
    
    func fetchSavedProgress() {
        user.updateProgress(progressArray: coreDataManager.fetchSavedProgress(for: .language), mode: .language)
        user.updateProgress(progressArray: coreDataManager.fetchSavedProgress(for: .history), mode: .history)
        user.updateProgress(progressArray: coreDataManager.fetchSavedProgress(for: .law), mode: .law)
    }
    
    func updateBookmarks(for mode: TestMode, id: Int) {
        user.updateBookmarks(for: mode, id: id)
        coreDataManager.updateBookmarks(for: mode, id: id)
    }
    
    func updateProgress(for mode: TestMode, id: Int, progress: Progress) {
        user.updateProgress(for: mode, id: id, progress: progress)
        coreDataManager.updateProgress(for: mode, id: id, progress: progress)
    }
    
    // Fetches the test session tickets within a given range
    func fetchTestSessionTickets(from lowerBound: Int, to upperBound: Int) {
        // Clearing the existing session tickets
        sessionTickets.removeAll()
        
        var count = lowerBound-1
        // Fetching the tickets for the current mode
        let currentModeTickets = getTickets(for: currentMode)
        
        // Looping through the range and adding the tickets to the session
        repeat {
            sessionTickets.append(SessionTicket(ticket: currentModeTickets[count]))
            count += 1
        } while (count < upperBound)
    }
    
    // Fetches the session tickets where the user made a mistake
    func fetchMistakeSessionTickets() {
        // Fetching the progress based on the current mode
        let progresses = user.getProgress(for: currentMode)
        
        // Fetching the tickets based on the current mode
        let tickets = getTickets(for: currentMode)
        
        // Clearing the existing session tickets
        sessionTickets.removeAll()
        
        // Looping through the progress and adding the incorrect tickets to the session
        for (id, progress) in progresses.enumerated() {
            if progress == .incorrect {
                sessionTickets.append(SessionTicket(ticket:tickets[id] ))
            }
        }
    }
    
    func fetchBookmarksSessionTickets() {
        // Fetching the progress based on the current mode
        let bookmarks = user.getBookmarks(for: currentMode)
        
        // Fetching the tickets based on the current mode
        let tickets = getTickets(for: currentMode)
        
        // Clearing the existing session tickets
        sessionTickets.removeAll()
        
        // Looping through the progress and adding the incorrect tickets to the session
        for bookmark in bookmarks {
            sessionTickets.append(SessionTicket(ticket:tickets[bookmark] ))
        }
    }
    
    
    // Fetches progress for each category of tickets.
    func fetchProgress() {
        user.languageProgress = Array(repeating: .incomplete, count: tickets?.languageTickets.count ?? 0)
        
        user.historyProgress = Array(repeating: .incomplete, count: tickets?.historyTickets.count ?? 0)
        
        user.lawProgress = Array(repeating: .incomplete, count: tickets?.lawTickets.count ?? 0)
    }
    
    // Sets the mode of the test session.
    func setMode(mode: TestMode) { // Accept a TestMode value
        currentMode = mode
    }
    
    
    
    func getTickets(for mode: TestMode) -> [Ticket] {
        switch mode {
        case .language:
            return tickets?.languageTickets ?? []
        case .history:
            return tickets?.historyTickets ?? []
        case .law:
            return tickets?.lawTickets ?? []
        }
    }
    
}

// Enum for the mode of the test session.
enum TestMode: String {
    case language = "language"
    case history = "history"
    case law = "law"
}
