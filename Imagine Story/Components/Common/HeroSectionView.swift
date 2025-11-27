//
//  HeroSectionView.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 28/09/2025.
//

import SwiftUI

struct HeroSectionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            VStack(alignment: .leading, spacing: 16) {
                NavigationLink {
                    StoryCreationView()
                } label: {
                    HStack(spacing: 32) {
                        Text("✨")
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
                                    .frame(width: 56, height: 56)
                            }
                            .padding()
                        
                        VStack(alignment: .leading) {
                            Text("Créer une histoire")
                                .font(.subheadline)
                                .foregroundColor(greenLinearGradientBackground)
                                .fontWeight(.bold)
                            Text("Invente une nouvelle aventure magique")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                NavigationLink {
                    StorySearchViewWrapper()
                } label: {
                    HStack() {
                        Text("📖")
                            .foregroundColor(.white)
                            .font(.title)
                            .fontWeight(.bold)
                            .background {
                                Circle()
                                    .fill(LinearGradient(
                                        colors: [blueLinearGradientBackground, tealLinearGradientBackground],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    ))
                                    .frame(width: 56, height: 56)
                            }
                            .padding()
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("Lire une histoire")
                                .font(.subheadline)
                                .foregroundColor(greenLinearGradientBackground)
                                .fontWeight(.bold)
                            Text("Découvre tes histoires préférées")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding(.horizontal)
        }
        .padding(.top)
    }
}

#Preview {
    NavigationStack {
        HeroSectionView()
    }
}

