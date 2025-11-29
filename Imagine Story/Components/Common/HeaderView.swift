//
//  HeaderView.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 28/09/2025.
//

import SwiftUI

struct HeaderView: View {
    let user: User
    
    @State private var selected = true
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Bonjour \(user.firstName) ! 👋")
                    .font(.title)
                    .foregroundColor(greenLinearGradientBackground)
                    .fontWeight(.bold)
                Text("Prêt pour une nouvelle aventure ?")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            Text(user.initials)
                .foregroundColor(.white)
                .font(.title)
                .fontWeight(.bold)
                .background {
                    Circle()
                        .fill(LinearGradient(
                            colors: [pinkLinearGradientBackground, yellowLinearGradientBackground],
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                        .frame(width: 44, height: 44)
                }
                .scaleEffect(selected ? 1.2 : 1)
                .animation(.bouncy, value: selected)
                .onTapGesture {
                    selected.toggle()
                }
                .padding()
        }
        .padding(.top, 80)
        .padding(.horizontal, 24)
    }
}

#Preview {
    HeaderView(user: User.MOCK_USER)
}

