//
//  Manager.swift
//  GETest
//
//  Created by Mikael Mikaelian on 5/3/24.
//

import Foundation

// MARK: - Manager Class
/// This class manages the test sessions.
class Manager: ObservableObject {
    // MARK: - Properties
    
    /// Core Data manager instance.
    let coreDataManager = CoreDataManager()
    
    /// Current mode of the test session.
    private(set) var currentMode: TestMode = .language
    
    /// User object for the test session.
    @Published var user = User()
    /// Tickets for the test sessions.
    @Published private(set) var tickets: Tickets?
    /// Tickets for a specified test.
    @Published private(set) var sessionTickets: [SessionTicket] = []
    /// Range of tickets for the test session.
    @Published private(set) var ranges: [(Int,Int)] = []
    /// Shuffle state for the test session.
    @Published private(set) var doShuffle: Bool = false
    
    // MARK: - Initializer
    /// Fetches tickets on initialization.
    init() {
        Task.init {
            fetchTickets()
        }
    }
    
    // MARK: - Fetch Methods
    
    /// - Fetches tickets from a JSON file.
    /// - Returns: Void
    func fetchTickets() {
        ///JSON decoder
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
                print("error:\(error.localizedDescription)")
            }
        }
    }
    
    /// Fetches saved bookmarks.
    /// - Returns: Void
    func fetchSavedBookmarks() {
        user.languageBookmarksIds = coreDataManager.fetchSavedBookmarks(for: .language)
        user.historyBookmarksIds = coreDataManager.fetchSavedBookmarks(for: .history)
        user.lawBookmarksIds = coreDataManager.fetchSavedBookmarks(for: .law)
    }
    
    /// Fetches saved progress.
    /// - Returns: Void
    func fetchSavedProgress() {
        user.updateProgress(progressArray: coreDataManager.fetchSavedProgress(for: .language), mode: .language)
        user.updateProgress(progressArray: coreDataManager.fetchSavedProgress(for: .history), mode: .history)
        user.updateProgress(progressArray: coreDataManager.fetchSavedProgress(for: .law), mode: .law)
    }
    
    /// Fetches progress for each category of tickets.
    func fetchProgress() {/*
        user.languageProgress = Array(repeating: .incomplete, count: tickets?.languageTickets.getTicketsCount() ?? 0)
        
        user.historyProgress = Array(repeating: .incomplete, count: tickets?.historyTickets.getTicketsCount() ?? 0)
        
        user.lawProgress = Array(repeating: .incomplete, count: tickets?.lawTickets.getTicketsCount() ?? 0)
                           */
    }
    
    /// Fetches test session tickets.
    func fetchTestSessionTickets(chapterName : String? = nil, topicName: String? = nil, range: (Int, Int)? = nil) {
        // Clearing the existing session tickets
        sessionTickets.removeAll()
        
        switch currentMode {
        case .language:
            sessionTickets = getTickets(for: currentMode, chapterName: chapterName, topicName: topicName).map { ticket in
                SessionTicket(ticket: ticket)
            }
        case .history:
            sessionTickets = getTickets(for: currentMode, topicName: topicName).map { ticket in
                SessionTicket(ticket: ticket)
            }
        case .law:
            guard let range = range else {return}
            sessionTickets = getTickets(for: currentMode).filter({Int($0.number)! >= range.0 && Int($0.number)!<=range.1}).map { ticket in
                SessionTicket(ticket: ticket)
            }
        }
        
        if doShuffle {
            sessionTickets.shuffle()
        }
    }
    
    /// Fetch session tickets where the user made a mistake
        func fetchMistakeSessionTickets() {
            // Fetching the progress based on the current mode
            let progresses = user.getProgress(for: currentMode)
            
            // Fetching the tickets based on the current mode
            let tickets = getTickets(for: currentMode)
            
            // Clearing the existing session tickets
            sessionTickets.removeAll()
            
            // Looping through the progress and adding the incorrect tickets to the session
            for progress in progresses {
                if progress.1 == .incorrect {
                    sessionTickets.append(SessionTicket(ticket: tickets.first(where: {$0.number == progress.0})!))
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
                sessionTickets.append(SessionTicket(ticket:tickets.first(where: {$0.number == bookmark})! ))
            }
        }
    
    // MARK: - Update Methods
    
    /// Toggles shuffle state.
    /// - Returns: Void
    func switchShuffle() {
        doShuffle = !doShuffle
    }
    
    /// Updates bookmarks.
    /// - Parameters:
    ///   - mode: The test mode.
    ///   - id: The id of the bookmark.
    /// - Returns: Void
    func updateBookmarks(for mode: TestMode, id: String) {
        user.updateBookmarks(for: mode, id: id)
        coreDataManager.updateBookmarks(for: mode, id: id)
    }
    
    /// Updates progress.
    /// - Parameters:
    ///   - mode: The test mode.
    ///   - id: The id of the progress.
    ///   - progress: The progress state.
    /// - Returns: Void
    func updateProgress(for mode: TestMode, id: String, progress: Progress) {
        user.updateProgress(for: mode, id: id, progress: progress)
        coreDataManager.updateProgress(for: mode, key: (id, progress))
    }
    
    /// Shuffles sessionTickets.
    /// - Returns: Void
    func shuffleTestSessionTickets() {
        sessionTickets.shuffle()
    }
    
    // MARK: - Switch and Set Methods
    
    /// Switches range.
    /// - Parameters:
    ///   - from: The start of the range.
    ///   - to: The end of the range.
    /// - Returns: Void
    func switchRange(from: Int, to: Int) {
        if ranges.contains(where: { $0 == (from, to) }) {
            // If the range is already in the array, remove it
            ranges.removeAll(where: { $0 == (from, to) })
        } else {
            // If the range is not in the array, append it
            ranges.append((from, to))
        }
    }
    
    /// Sets the mode of the test session.
    /// - Parameter mode: The test mode.
    /// - Returns: Void
    func setMode(mode: TestMode) {
        currentMode = mode
    }
    
    // MARK: - Get Methods
    
    /// Gets tickets for a specific mode.
    /// - Parameter mode: The test mode.
    /// - Returns: An array of tickets.
    func getTickets(for mode: TestMode) -> [Ticket] {
        switch mode {
        case .language:
            return tickets?.languageTickets.getTickets() ?? []
        case .history:
            return tickets?.historyTickets.getTickets() ?? []
        case .law:
            return tickets?.lawTickets.getTickets() ?? []
        }
    }
    
    /// Gets chapters for a specific mode.
    /// - Parameter mode: The test mode.
    /// - Returns: An array of chapter names.
    func getChapters(for mode: TestMode) -> [String] {
        guard let tickets = tickets else {return []}
        if currentMode == .language {
            return tickets.languageTickets.chapters.map { $0.chapterName }
        } else {
            return []
        }
    }
    
    /// Gets topics for a specific mode.
    /// - Parameters:
    ///   - mode: The test mode.
    ///   - chapterName: The name of the chapter.
    /// - Returns: An array of topic names.
    func getTopics(for mode: TestMode, chapterName: String? = nil) -> [String] {
        guard let tickets = tickets else {return []}
        switch mode {
        case .language:
            guard let chapterName = chapterName else {return []}
            return tickets.languageTickets.chapters.first(where: {$0.chapterName == chapterName})?.topics.map({$0.topicName}) ?? []
        case .history:
            return tickets.historyTickets.topics.map { $0.topicName }
        case .law:
            return []
        }
    }
    
    /// Gets tickets for a specific mode, chapter, and topic.
    /// - Parameters:
    ///   - mode: The test mode.
    ///   - chapterName: The name of the chapter.
    ///   - topicName: The name of the topic.
    /// - Returns: An array of tickets.
    func getTickets(for mode: TestMode, chapterName: String? = nil, topicName: String? = nil) -> [Ticket] {
        guard let tickets = tickets else { return [] }
        
        switch mode {
        case .language:
            guard let chapterName = chapterName, let topicName = topicName else {return []}
            return tickets.languageTickets.getTickets(chapterName: chapterName, topicName: topicName)
        case .history:
            guard let topicName = topicName else {return []}
            return tickets.historyTickets.getTickets(topicName: topicName)
        case .law:
            return tickets.lawTickets.getTickets()
        }
    }
}

// Enum for the mode of the test session.
enum TestMode: String {
    case language = "language"
    case history = "history"
    case law = "law"
}
