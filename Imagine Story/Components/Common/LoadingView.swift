//
//  LoadingView.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 28/09/2025.
//

import SwiftUI

struct LoadingView: View {
    let message: String
    
    init(message: String = "Chargement...") {
        self.message = message
    }
    
    var body: some View {
        ProgressView(message)
    }
}

#Preview {
    LoadingView()
}

