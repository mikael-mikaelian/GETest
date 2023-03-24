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
                Text("აირჩიეთ ბილეთების ნომრები")
                    .padding(.top)
                    .font(.title2)
                    .fontWeight(.heavy)
                    .foregroundColor(.accentColor)
                Grid {
                    GridRow {
                        NavigationLink{
                            TicketView<T>().environmentObject(questionsManager)
                        } label: {
                            rangeView(text: "1-20")
                                
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            questionsManager.reset()
                            questionsManager.setStartIndex(0)
                            questionsManager.setEndIndex(19)
                        })
                        
                        NavigationLink{
                            TicketView<T>().environmentObject(questionsManager)
                        } label: {
                            rangeView(text: "21-40")
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            questionsManager.reset()
                            questionsManager.setTicket(20)
                            questionsManager.setStartIndex(20)
                            questionsManager.setEndIndex(39)
                        })
                    }
                    GridRow {
                        NavigationLink{
                            TicketView<T>().environmentObject(questionsManager)
                        } label: {
                        rangeView(text: "41-60")
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            questionsManager.reset()
                            questionsManager.setTicket(40)
                            questionsManager.setStartIndex(40)
                            questionsManager.setEndIndex(59)
                        })
                        
                        NavigationLink {
                            TicketView<T>().environmentObject(questionsManager)
                        } label: {
                            rangeView(text: "61-80")
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            questionsManager.reset()
                            questionsManager.setTicket(60)
                            questionsManager.setStartIndex(60)
                            questionsManager.setEndIndex(79)
                        })
                    }
                    GridRow {
                        NavigationLink {
                            TicketView<T>().environmentObject(questionsManager)
                        } label: {
                            rangeView(text: "81-100")
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            questionsManager.reset()
                            questionsManager.setTicket(80)
                            questionsManager.setStartIndex(80)
                            questionsManager.setEndIndex(99)
                        })
                        
                        rangeView(text: "101-120")
                    }
                    GridRow {
                        rangeView(text: "121-140")
                        rangeView(text: "141-160")
                    }
                    GridRow {
                        rangeView(text: "161-180")
                        rangeView(text: "181-200(+)")
                    }
                }
                .padding()
        }
    }
}

struct rangeView: View {
    var text: String
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text(text)
                Spacer()
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


