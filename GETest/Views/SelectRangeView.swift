//
//  SelectRangeView.swift
//  GETest
//
//  Created by Mikael Mikaelian on 1/31/23.
//

import SwiftUI

struct SelectRangeView<T: TicketEntityProtocol>: View {
    @EnvironmentObject var questionsManager: QuestionsManager<T>
    var body: some View {
            VStack{
                ScrollView {
                    VStack {
                        ForEach((0...9), id: \.self) { i in
                            NavigationLink{
                                TicketView<T>().environmentObject(questionsManager)
                            } label: {
                                rangeView(text: "\((i)*20+1)-\(i*20+20 == 200 ? questionsManager.getTicketsCount() : i*20+20)")
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                questionsManager.reset()
                                questionsManager.setTicket((i)*20)
                                questionsManager.setStartIndex((i)*20)
                                questionsManager.setEndIndex((i*20+19 == 200 ? questionsManager.getTicketsCount() : i*20+19))
                            })
                        }
                        
                        NavigationLink{
                            TicketView<T>(isMistakesMode: true).environmentObject(questionsManager)
                        } label: {
                            rangeView(text: "ჩემი შეცდომები")
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            questionsManager.reset()
                            questionsManager.setTicket(1)
                            questionsManager.setStartIndex(1)
                            questionsManager.setEndIndex(1)
                        })
                        
                    }
                }
                .scrollIndicators(.hidden)

                .padding(.horizontal)
        }
        
    }
    
}

struct rangeView: View {
    var text: String
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text(text)
                Spacer()
                Image(systemName: "chevron.right")
            }
            Spacer()
        }
            .font(.title2)
            .fontWeight(.heavy)
            .foregroundColor(.white)
            .padding()
            .background(Color.accentColor)
            .cornerRadius(15)
            //.shadow(radius: 10)
        
    }
}

struct SelectRangeView_Previews: PreviewProvider {
    static var previews: some View {
        SelectRangeView<LanguageTicketEntity>().environmentObject(QuestionsManager<LanguageTicketEntity>("language_tickets"))
    }
}


