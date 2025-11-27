//
//  ErrorView.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 28/09/2025.
//

import SwiftUI

struct ErrorView: View {
    let errorMessage: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text(errorMessage)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding()
            
            Button("Réessayer") {
                onRetry()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    ErrorView(errorMessage: "Une erreur est survenue") {
        print("Retry tapped")
    }
}

