//
//  ContentView.swift
//  GETest
//
//  Created by Mikael Mikaelian on 1/30/23.
//

import SwiftUI
import CoreData

struct MenuView: View {
    
    @StateObject var languageQuestionsManager = QuestionsManager<LanguageTicketEntity>("language_tickets")
    @StateObject var historyQuestionsManager  = QuestionsManager<HistoryTicketEntity>("history_tickets")
    @StateObject var lawQuestionsManager      = QuestionsManager<LawTicketEntity>("law_tickets")

    
    var body: some View {
        NavigationView {
            VStack (spacing: 20){
                VStack {
                    Text("🇬🇪").font(.system(size: 120))
                    Text("საქართველოს მოქალაქეობის \n ტესტები")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(.accentColor)
                        .multilineTextAlignment(.center)
                }
                

                
                VStack {
                    
                    HStack {
                        Text("თქვენი პროგრესი")
                            .fontWeight(.bold)
                            .font(.title3)
                        Spacer()
                    }
                    .padding(.bottom)
                    
                    ProgressBox<LanguageTicketEntity>().environmentObject(languageQuestionsManager)
                    ProgressBox<HistoryTicketEntity>().environmentObject(historyQuestionsManager)
                    ProgressBox<LawTicketEntity>().environmentObject(lawQuestionsManager)
                    
                    
                    //MARK: - Overall progress view
                    HStack{
                        Text("საგამოცდო მზადყოფნა")
                        Spacer()
                        Text("\(languageQuestionsManager.getTicketsCount()+historyQuestionsManager.getTicketsCount()+lawQuestionsManager.getTicketsCount())-დან \(languageQuestionsManager.getCorrectCount()+historyQuestionsManager.getCorrectCount()+lawQuestionsManager.getCorrectCount())")
                    }
                    .padding(.top)
                    ProgressView(
                        value: Float(languageQuestionsManager.getCorrectCount()+historyQuestionsManager.getCorrectCount()+lawQuestionsManager.getCorrectCount())/Float(languageQuestionsManager.getTicketsCount()+historyQuestionsManager.getTicketsCount()+lawQuestionsManager.getTicketsCount())
                    )
    
                }
                .padding()
                
                
                Spacer()
                NavigationLink {
                    SelectRangeView<LanguageTicketEntity>().environmentObject(languageQuestionsManager)
                        .navigationTitle("აირჩიეთ ბილეთების ნომრები")

                } label: {
                    TestTypeButton(text: "ქართული ენა").padding(.horizontal)
                }
                
                NavigationLink {
                    SelectRangeView<HistoryTicketEntity>().environmentObject(historyQuestionsManager)
                        .navigationTitle("აირჩიეთ ბილეთების ნომრები")

                } label: {
                    TestTypeButton(text: "ისტორია").padding(.horizontal)
                }
                
                NavigationLink {
                    SelectRangeView<LawTicketEntity>().environmentObject(lawQuestionsManager)
                        .navigationTitle("აირჩიეთ ბილეთების ნომრები")
                } label: {
                    TestTypeButton(text: "ᲡᲐᲛᲐᲠᲗᲚᲘᲡ ᲡᲐᲤᲣᲫᲕᲚᲔᲑᲘ").padding(.horizontal)
                }
                
                
            }

        }

    }
}

struct ProgressBox<T: TicketEntityProtocol> : View {
    
    @EnvironmentObject var questionsManager: QuestionsManager<T>
    
    var body: some View {
        VStack {
            HStack {
                switch(questionsManager.type)
                {
                case "language_tickets":
                    Text("ქართულ ენაში")
                    
                case "history_tickets":
                    Text("ისტორიაში")
                    
                case "law_tickets":
                    Text("სამართლის საფუძვლებში")
                    
                default:
                    Text("error")
                }
                
                Spacer()
                
                Text("\(questionsManager.getTicketsCount())-დან \(questionsManager.getCorrectCount())")

            }
            
            ProgressView(value: Float(questionsManager.getCorrectCount())/Float(questionsManager.getTicketsCount()))

            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
