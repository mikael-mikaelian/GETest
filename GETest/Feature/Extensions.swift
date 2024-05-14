//
//  Extentions.swift
//  GETest
//
//  Created by Mikael Mikaelian on 5/14/24.
//

import SwiftUI

extension View {
    func generateImpact() {
        let impactMed = UIImpactFeedbackGenerator(style: .medium)
        impactMed.impactOccurred()
    }
}

