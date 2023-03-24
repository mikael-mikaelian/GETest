//
//  TestTypeButton.swift
//  GETest
//
//  Created by Mikael Mikaelian on 1/30/23.
//

import SwiftUI

struct TestTypeButton: View {
    var text: String
    var background: Color = Color("AccentColor")
    
    var body: some View {
        HStack{
            Spacer()
            Text(text)
            Spacer()
        }
        .foregroundColor(.white)
        .fontWeight(.heavy)
        .padding()
        .background(background)
        .cornerRadius(20)
        //.shadow(radius: 10)
    }
}

struct TestTypeButton_Previews: PreviewProvider {
    static var previews: some View {
        TestTypeButton(text: "ქართული ენა")
    }
}
