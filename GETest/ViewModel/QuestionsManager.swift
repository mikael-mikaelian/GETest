//
//  QuestionsManager.swift
//  GETest
//
//  Created by Mikael Mikaelian on 1/30/23.
//

import Foundation
import CoreData

protocol TicketEntityProtocol:NSFetchRequestResult {
    var id: UUID{get}
    var progressStatus: Int16 { get set }
}

extension LanguageTicketEntity: TicketEntityProtocol {
    public var id: UUID {
        return self.id
    }
}
extension HistoryTicketEntity: TicketEntityProtocol {
    public var id: UUID {
        return self.id
    }
}
extension LawTicketEntity: TicketEntityProtocol {
    public var id: UUID {
        return self.id
    }
}

@MainActor class QuestionsManager<T: TicketEntityProtocol>: ObservableObject {
    
    let container: NSPersistentContainer
    
    private(set)            var tickets: [Tickets.Ticket] = []      //array of tickets of type Ticket which is in Tickets struct
    private(set)            var type: String = ""
    
    @Published private(set) var index = 0
    @Published private(set) var question: AttributedString = ""     //current question in the ticket
    @Published private(set) var number: AttributedString = ""       //current ticket number
    @Published private(set) var answerChoices: [Answer] = []        //answer choices to the question in the ticket
    @Published private(set) var isCurrent: [Bool] = [true]          //array of boolean variables, which says if the ticket under the index is current
    @Published private(set) var isCompleted: [Bool] = []            //array of boolean variables, which says if the ticket under the index is completed
    
    @Published private(set) var textOfSelectedAnswer: [AttributedString] = []
    @Published              var isCompletedCorrectly: [Bool] = []
    
    @Published private(set) var startIndex = 0
    @Published private(set) var endIndex = 0
    
    //coredata
    @Published var ticketsCoplitionStatusStorage: [T] = [] // 0 - is not completed, 1 - incorrect, 2 - correct
    
    init (_ type: String) {
        self.type = type
        
        container = NSPersistentContainer (name: "TicketsContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        Task.init {
            fetchQuestions()
            fetchSavedTickets()
        }
    }
    
    func fetchSavedTickets() {
        //MARK: - CoreData
        
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        request.includesSubentities = false

        
        do {
            ticketsCoplitionStatusStorage = try container.viewContext.fetch(request)
        } catch let error {
            print(error.localizedDescription )
        }
    }
    
    //function to fetch the questions from json file
    func fetchQuestions() {

        //JSON decoder
        if let url = Bundle.main.url(forResource: type, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedData = try decoder.decode(Tickets.self, from: data)
                DispatchQueue.main.async {
                    self.tickets = decodedData.tickets
                    self.setTicket()

                    for _ in  1..<self.tickets.count {
                        self.isCurrent.append(false)
                    }
                    
                    for _ in  0..<self.tickets.count {
                        self.isCompleted.append(false)
                        self.textOfSelectedAnswer.append("")
                        self.isCompletedCorrectly.append(false)
                        self.addTicket()
                    }
                    
                }
                

            } catch {
                print("error:\(error)")
            }
        }
    }
    
    func addTicket() {
        if (type == "language_tickets"){
            let newTicket = LanguageTicketEntity(context: container.viewContext)
            newTicket.progressStatus = 0
            saveData()
        }
        
        if (type == "history_tickets"){
            let newTicket = HistoryTicketEntity(context: container.viewContext)
            newTicket.progressStatus = 0
            saveData()
        }
        
        if (type == "law_tickets"){
            let newTicket = LawTicketEntity(context: container.viewContext)
            newTicket.progressStatus = 0
            saveData()
        }
    }
    
    func updateTicket(entity: T, progressStatus: Int16) {
        //let currentProgress = entity.progressStatus
        let newProgress = progressStatus
        entity.progressStatus = newProgress
        saveData()
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            print("\(type) data saved")

            fetchSavedTickets()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    //function to set new current ticket
    func setTicket() {
        let currentTicket   = tickets[index]
        question            = currentTicket.formattedQuestion
        answerChoices       = currentTicket.formattedAnswers
        number              = currentTicket.formattedNumber
    }
    
    
    //function to go to the next question
    func nextTicket() {
        if index<endIndex {
            setTicket(index+1)
        }
    }
    
    func setTicket(_ index: Int) {
        isCurrent[self.index]   = false
        self.index              = index
        isCurrent[index]        = true
        
        let currentTicket   = tickets[index]
        question            = currentTicket.formattedQuestion
        answerChoices       = currentTicket.formattedAnswers
        number              = currentTicket.formattedNumber
    }
    
    func getTicketsCount() -> Int {
        return tickets.count
    }
    
    func completeTicket() {
        isCompleted[index] = true
    }
    
    func setTextOfSelectedAnswer(_ text: AttributedString) {
        textOfSelectedAnswer[self.index] = text
    }
    
    func reset() {
        self.setTicket(0)
        
        for index in  1..<self.tickets.count {
            self.isCurrent[index] = false
        }
        
        for index in  0..<self.tickets.count {
            self.isCompleted[index]             = false
            self.textOfSelectedAnswer[index] = ""
            self.isCompletedCorrectly[index]    = false

        }
        
        startIndex  = -1
        endIndex    = -1
    }
    
    func getStartIndex() -> Int {
        return startIndex
    }
    
    func getEndIndex() -> Int {
        return endIndex
    }
    
    
    func setStartIndex(_ x:Int) {
        startIndex = x
    }
    
    func setEndIndex(_ x: Int) {
        endIndex = x
    }
    
    func getCorrectCount() -> Int {
        var result = 0
        for ticket in ticketsCoplitionStatusStorage {
            if ticket.progressStatus == 2 {
                result += 1
            }
        }
        
        return result
    }
    
}
