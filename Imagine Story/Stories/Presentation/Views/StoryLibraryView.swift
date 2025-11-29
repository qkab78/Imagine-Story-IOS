//
//  StoryLibraryView.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 29/11/2025.
//

import SwiftUI

struct StoryLibraryView: View {
    @State private var stories: [Story] = []
    @State private var shouldNavigate = false
    @State private var selectedStoryId: String?
    
    // Données fictives de livres
    private let mockStories: [Story] = [
        Story(
            id: "1",
            title: "RAISE YOUR GAME",
            synopsis: "High-performance secrets from the BEST of the BEST",
            coverImage: "",
            numberOfChapters: 12,
            theme: "1",
            themeName: "Productivité",
            themeDescription: "Stratégies pour améliorer vos performances",
            conclusion: "",
            chapters: [],
            chapterImages: [],
            createdAt: Date().ISO8601Format(),
            isLiked: false,
            language: StoryLanguage(id: "1", code: "EN", name: "English", isFree: true),
            tone: StoryTone(id: "1", name: "educational", description: "")
        ),
        Story(
            id: "2",
            title: "FLOW",
            synopsis: "The psychology of optimal experience",
            coverImage: "",
            numberOfChapters: 15,
            theme: "2",
            themeName: "Développement personnel",
            themeDescription: "Comprendre l'état de flow",
            conclusion: "",
            chapters: [],
            chapterImages: [],
            createdAt: Date().ISO8601Format(),
            isLiked: false,
            language: StoryLanguage(id: "2", code: "EN", name: "English", isFree: true),
            tone: StoryTone(id: "2", name: "calm", description: "")
        ),
        Story(
            id: "3",
            title: "SWITCH",
            synopsis: "How to change things when change is hard",
            coverImage: "",
            numberOfChapters: 10,
            theme: "3",
            themeName: "Productivité",
            themeDescription: "Guide pour le changement",
            conclusion: "",
            chapters: [],
            chapterImages: [],
            createdAt: Date().ISO8601Format(),
            isLiked: false,
            language: StoryLanguage(id: "3", code: "EN", name: "English", isFree: true),
            tone: StoryTone(id: "3", name: "educational", description: "")
        ),
        Story(
            id: "4",
            title: "REST",
            synopsis: "Why you get done when you work less",
            coverImage: "",
            numberOfChapters: 8,
            theme: "4",
            themeName: "Bien-être",
            themeDescription: "L'art du repos productif",
            conclusion: "",
            chapters: [],
            chapterImages: [],
            createdAt: Date().ISO8601Format(),
            isLiked: false,
            language: StoryLanguage(id: "4", code: "EN", name: "English", isFree: true),
            tone: StoryTone(id: "4", name: "calm", description: "")
        ),
        Story(
            id: "5",
            title: "REST",
            synopsis: "Why you get done when you work less",
            coverImage: "",
            numberOfChapters: 8,
            theme: "4",
            themeName: "Bien-être",
            themeDescription: "L'art du repos productif",
            conclusion: "",
            chapters: [],
            chapterImages: [],
            createdAt: Date().ISO8601Format(),
            isLiked: false,
            language: StoryLanguage(id: "4", code: "EN", name: "English", isFree: true),
            tone: StoryTone(id: "4", name: "calm", description: "")
        ),
        Story(
            id: "6",
            title: "REST",
            synopsis: "Why you get done when you work less",
            coverImage: "",
            numberOfChapters: 8,
            theme: "4",
            themeName: "Bien-être",
            themeDescription: "L'art du repos productif",
            conclusion: "",
            chapters: [],
            chapterImages: [],
            createdAt: Date().ISO8601Format(),
            isLiked: false,
            language: StoryLanguage(id: "4", code: "EN", name: "English", isFree: true),
            tone: StoryTone(id: "4", name: "calm", description: "")
        ),
        Story(
            id: "7",
            title: "REST",
            synopsis: "Why you get done when you work less",
            coverImage: "",
            numberOfChapters: 8,
            theme: "4",
            themeName: "Bien-être",
            themeDescription: "L'art du repos productif",
            conclusion: "",
            chapters: [],
            chapterImages: [],
            createdAt: Date().ISO8601Format(),
            isLiked: false,
            language: StoryLanguage(id: "4", code: "EN", name: "English", isFree: true),
            tone: StoryTone(id: "4", name: "calm", description: "")
        ),
        Story(
            id: "8",
            title: "REST",
            synopsis: "Why you get done when you work less",
            coverImage: "",
            numberOfChapters: 8,
            theme: "4",
            themeName: "Bien-être",
            themeDescription: "L'art du repos productif",
            conclusion: "",
            chapters: [],
            chapterImages: [],
            createdAt: Date().ISO8601Format(),
            isLiked: false,
            language: StoryLanguage(id: "4", code: "EN", name: "English", isFree: true),
            tone: StoryTone(id: "4", name: "calm", description: "")
        ),
        Story(
            id: "9",
            title: "REST",
            synopsis: "Why you get done when you work less",
            coverImage: "",
            numberOfChapters: 8,
            theme: "4",
            themeName: "Bien-être",
            themeDescription: "L'art du repos productif",
            conclusion: "",
            chapters: [],
            chapterImages: [],
            createdAt: Date().ISO8601Format(),
            isLiked: false,
            language: StoryLanguage(id: "4", code: "EN", name: "English", isFree: true),
            tone: StoryTone(id: "4", name: "calm", description: "")
        )
    ]
    
    // Couleurs pour les couvertures (utilisant les couleurs de l'app)
    private let coverColors: [Color] = [
        Color(red: 1.0, green: 0.55, blue: 0.4), // Coral-orange (proche de pinkLinearGradientBackground)
        Color(red: 0.129, green: 0.588, blue: 0.953), // Deep blue (blueLinearGradientBackground)
        Color(red: 0.75, green: 0.65, blue: 0.85), // Light lavender
        Color(red: 0.129, green: 0.588, blue: 0.953) // Deep blue (blueLinearGradientBackground)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ], spacing: 24) {
                    ForEach(Array(stories.enumerated()), id: \.element.id) { index, story in
                        BookCoverView(
                            story: story,
                            coverColor: coverColors[index % coverColors.count]
                        )
                        .onTapGesture {
                            selectedStoryId = story.id
                            shouldNavigate = true
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
            .background {
                ViewLinearGradientBackground
                    .ignoresSafeArea()
            }
            .navigationTitle("Librairie")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.hidden, for: .navigationBar)
            .navigationDestination(isPresented: $shouldNavigate) {
                StoryReadView(storyId: selectedStoryId)
            }
        }
        .onAppear {
            stories = mockStories
        }
    }
}

// Vue pour la couverture d'un livre
struct BookCoverView: View {
    let story: Story
    let coverColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Couverture du livre
            ZStack {
                Rectangle()
                    .fill(coverColor)
                    .frame(height: 240)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                
                VStack(alignment: .leading, spacing: 12) {
                    // Titre principal
                    Text(story.title)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                    
                    // Sous-titre
                    Text(story.synopsis)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.white.opacity(0.95))
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
                .padding(20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            
            // Informations du livre (auteur/thème)
            VStack(alignment: .leading, spacing: 4) {
                Text(story.themeName)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
    }
}

#Preview {
    StoryLibraryView()
}
