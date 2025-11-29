//
//  StoryLibraryView.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 29/11/2025.
//

import SwiftUI

struct StoryLibraryView: View {
    @StateObject private var viewModel = StoryLibraryViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var shouldNavigate = false
    @State private var selectedStoryId: String?
    
    // Données fictives de livres (fallback)
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
            Group {
                if viewModel.isLoading {
                    LoadingView()
                } else if let errorMessage = viewModel.errorMessage {
                    ErrorView(errorMessage: errorMessage) {
                        Task {
                            if let token = authViewModel.user?.token {
                                await viewModel.retryLoadStories(token: token)
                            }
                        }
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 24) {
                            ForEach(Array(viewModel.stories.enumerated()), id: \.element.id) { index, story in
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
                }
            }
            .navigationTitle("Librairie")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.hidden, for: .navigationBar)
            .navigationDestination(isPresented: $shouldNavigate) {
                StoryReadView(storyId: selectedStoryId)
            }
        }
        .task {
            if let token = authViewModel.user?.token {
                await viewModel.loadUserStories(token: token)
            } else {
                // Fallback sur les données fictives si pas de token
                viewModel.stories = mockStories
            }
        }
    }
}

// Vue pour la couverture d'un livre
struct BookCoverView: View {
    let story: Story
    let coverColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Couverture du livre avec taille fixe
            ZStack(alignment: .topLeading) {
                // Background avec image ou couleur de fallback
                if !story.coverImage.isEmpty, let url = URL(string: story.coverImage) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            // Placeholder pendant le chargement
                            coverColor
                                .frame(height: 240)
                                .overlay {
                                    ProgressView()
                                        .tint(.white)
                                }
                        case .success(let image):
                            // Image chargée avec succès
                            image
                                .resizable()
                                .frame(height: 240)
                        case .failure:
                            // Fallback sur la couleur en cas d'erreur
                            coverColor
                                .frame(height: 240)
                        @unknown default:
                            coverColor
                                .frame(height: 240)
                        }
                    }
                } else {
                    // Pas d'URL valide, utilise la couleur
                    coverColor
                        .frame(height: 240)
                }
                
                // Overlay gradient pour améliorer la lisibilité du texte
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.6),
                        Color.black.opacity(0.3),
                        Color.clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                // Contenu texte
                VStack(alignment: .leading, spacing: 12) {
                    // Titre principal
                    Text(story.title)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                    
                    Spacer()
                    
                    // Sous-titre
                    Text(story.synopsis)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.white.opacity(0.95))
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                }
                .padding(20)
            }
            .frame(height: 240)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            
            // Informations du livre (auteur/thème)
            Text(story.themeName)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    StoryLibraryView()
        .environmentObject(AuthViewModel())
}
