//
//  StoryCardView.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 28/09/2025.
//

import SwiftUI

struct StoryCardView: View {
    @Binding var story: Story
    @State private var isPressed = false
    @State private var isOpening = false
    @State private var isFullyOpen = false
    @State private var shouldNavigate = false

    var body: some View {
        // Conteneur fixe avec positionnement absolu pour éviter tout mouvement
        ZStack {
            // Espace réservé invisible pour maintenir la taille dans le LazyHStack
            Rectangle()
                .fill(Color.clear)
                .frame(width: 120, height: 240)
            
            // Page intérieure avec synopsis (derrière la couverture)
            if isOpening {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 120, height: 180)
                    .overlay(
                        VStack(alignment: .leading, spacing: 6) {
                            Text(story.title)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.black)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                            
                            Text(story.synopsis)
                                .font(.system(size: 8))
                                .foregroundColor(.black.opacity(0.8))
                                .lineLimit(15)
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                            
                            Text("\(story.numberOfChapters) chapitres")
                                .font(.system(size: 7))
                                .foregroundColor(.gray)
                        }
                        .padding(8)
                    )
                    .position(x: 60, y: 90)
                    .rotation3DEffect(
                        .degrees(isFullyOpen ? 0 : -90),
                        axis: (x: 0, y: 1, z: 0),
                        anchor: .leading
                    )
                    .animation(.easeInOut(duration: 0.4).delay(0.2), value: isFullyOpen)
            }
            
            // Couverture principale
            AsyncImage(url: URL(string: story.coverImage)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(LinearGradient(
                        colors: [Color.gray.opacity(0.4), Color.gray.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .overlay(
                        Image(systemName: isOpening ? "book.open" : "book.closed")
                            .foregroundColor(.gray)
                            .font(.title2)
                            .animation(.easeInOut(duration: 0.3), value: isOpening)
                    )
            }
            .frame(width: 120, height: 180)
            .clipped()
            .overlay(
                // Reflet très subtil sur la couverture
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.08),
                        Color.clear,
                        Color.black.opacity(0.03)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .shadow(color: .black.opacity(0.12), radius: 4, x: 0, y: 3)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .position(x: 60, y: 90)
            .rotation3DEffect(
                .degrees(isFullyOpen ? -90 : (isOpening ? -15 : 0)),
                axis: (x: 0, y: 1, z: 0),
                anchor: .leading,
                perspective: 0.8
            )
            .animation(.spring(response: 0.4, dampingFraction: 0.7, blendDuration: 0), value: isPressed)
            .animation(.easeInOut(duration: 0.6), value: isOpening)
            .animation(.easeInOut(duration: 0.8), value: isFullyOpen)
            
            // Titre et chapitres (positionnés absolument en bas)
            if !isFullyOpen {
                VStack(alignment: .leading, spacing: 4) {
                    Text(story.title)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text("\(story.numberOfChapters) chapitres")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .frame(width: 120, alignment: .leading)
                .position(x: 60, y: 205) // Position fixe en bas avec espacement
                .opacity(isOpening ? 0 : 1)
                .animation(.easeInOut(duration: 0.3), value: isOpening)
            }
        }
        .frame(width: 120, height: 240) // Taille fixe absolue augmentée
        .clipped() // Contraint tout le contenu
        .onTapGesture {
            if !isOpening {
                // Animation de pression
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = true
                }
                
                // Animation d'ouverture du livre
                withAnimation(.easeInOut(duration: 0.3)) {
                    isOpening = true
                }
                
                // Livre complètement ouvert
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation(.easeInOut(duration: 0.6)) {
                        isFullyOpen = true
                    }
                }
                
                // Navigation après avoir montré le synopsis
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    shouldNavigate = true
                }
                
                // Reset des animations
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        isPressed = false
                        isOpening = false
                        isFullyOpen = false
                    }
                }
            }
        }
        .navigationDestination(isPresented: $shouldNavigate) {
            StoryReadView(storyId: story.id)
        }
    }
}

#Preview {
    NavigationStack {
        ScrollView(.horizontal) {
            HStack {
                StoryCardView(story: .constant(Story(
                    id: "7b9892cf-c429-40b9-87fd-eb065b593243",
                    title: "Histoire 1",
                    synopsis: "Synopsis",
                    coverImage: "",
                    numberOfChapters: 3,
                    theme: "1",
                    themeName: "Aventure",
                    themeDescription: "Une histoire pleine d'aventures",
                    conclusion: "Conclusion de l'histoire",
                    chapters: [],
                    chapterImages: [],
                    createdAt: Date().ISO8601Format(),
                    isLiked: false,
                    language: StoryLanguage(id: "1", code: "fr", name: "Français", isFree: true),
                    tone: StoryTone(id: "1", name: "Épique", description: "")
                )))
            }
        }
    }
}

