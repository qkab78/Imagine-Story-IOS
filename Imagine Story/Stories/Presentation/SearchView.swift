//
//  SearchView.swift
//  Imagine Story
//
//  Created by Assistant on 18/11/2025.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var recentSearches = ["Pride", "Adventure", "Magic"]
    @FocusState private var isSearchFocused: Bool
    
    // Données d'exemple pour les résultats de recherche
    private let sampleStories = [
        Story(
            id: "1", 
            title: "Pride and Prejudice", 
            synopsis: "Une histoire d'amour et de fierté dans l'Angleterre du 19ème siècle",
            coverImage: "",
            numberOfChapters: 12,
            tone: "romantique",
            theme: "romance",
            themeName: "Romance",
            themeDescription: "Histoire d'amour",
            conclusion: "Un mariage heureux",
            chapters: [],
            chapterImages: [],
            createdAt: "2023-01-01",
            isLiked: false
        ),
        Story(
            id: "2", 
            title: "The Great Adventure", 
            synopsis: "Une aventure épique à travers des terres mystérieuses",
            coverImage: "",
            numberOfChapters: 8,
            tone: "aventureux",
            theme: "adventure",
            themeName: "Aventure",
            themeDescription: "Histoire d'aventure",
            conclusion: "Le héros triomphe",
            chapters: [],
            chapterImages: [],
            createdAt: "2023-02-01",
            isLiked: true
        ),
        Story(
            id: "3", 
            title: "Magical Journey", 
            synopsis: "Un voyage magique dans un monde fantastique",
            coverImage: "",
            numberOfChapters: 15,
            tone: "magique",
            theme: "fantasy",
            themeName: "Fantaisie",
            themeDescription: "Histoire fantastique",
            conclusion: "La magie sauve le monde",
            chapters: [],
            chapterImages: [],
            createdAt: "2023-03-01",
            isLiked: false
        ),
        Story(
            id: "4", 
            title: "Ocean's Mystery", 
            synopsis: "Un mystère sous les océans profonds",
            coverImage: "",
            numberOfChapters: 10,
            tone: "mystérieux",
            theme: "mystery",
            themeName: "Mystère",
            themeDescription: "Histoire mystérieuse",
            conclusion: "Le mystère est résolu",
            chapters: [],
            chapterImages: [],
            createdAt: "2023-04-01",
            isLiked: true
        ),
        Story(
            id: "5", 
            title: "Mountain Quest", 
            synopsis: "Une quête périlleuse dans les montagnes",
            coverImage: "",
            numberOfChapters: 7,
            tone: "épique",
            theme: "quest",
            themeName: "Quête",
            themeDescription: "Histoire de quête",
            conclusion: "La quête est accomplie",
            chapters: [],
            chapterImages: [],
            createdAt: "2023-05-01",
            isLiked: false
        )
    ]
    
    var filteredStories: [Story] {
        if searchText.isEmpty {
            return []
        }
        return sampleStories.filter { story in
            story.title.lowercased().contains(searchText.lowercased()) ||
            story.synopsis.lowercased().contains(searchText.lowercased()) ||
            story.themeName.lowercased().contains(searchText.lowercased())
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header avec titre
                VStack(spacing: 16) {
                    Text("Rechercher une Histoire")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top)
                    
                    // Barre de recherche
                    HStack(spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondary)
                                .font(.system(size: 16))
                            
                            TextField("Titre, auteur...", text: $searchText)
                                .focused($isSearchFocused)
                                .textFieldStyle(.plain)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                                isSearchFocused = false
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                                    .font(.system(size: 16))
                            }
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding(.horizontal)
                    .animation(.spring(response: 0.3), value: searchText.isEmpty)
                }
                .padding(.bottom, 8)
                
                // Contenu principal
                if searchText.isEmpty {
                    // État sans recherche - Recherches récentes
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Recherches Récentes")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Button("Effacer") {
                                recentSearches.removeAll()
                            }
                            .foregroundColor(.secondary)
                            .font(.callout)
                        }
                        .padding(.horizontal)
                        
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(recentSearches, id: \.self) { search in
                                Button {
                                    searchText = search
                                } label: {
                                    HStack(spacing: 12) {
                                        Image(systemName: "magnifyingglass")
                                            .foregroundColor(.secondary)
                                            .font(.system(size: 14))
                                        
                                        Text(search)
                                            .foregroundColor(.primary)
                                            .font(.callout)
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 24)
                } else if filteredStories.isEmpty {
                    // État sans résultat
                    VStack(spacing: 16) {
                        Spacer()
                        
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        
                        Text("Aucun résultat")
                            .font(.title2)
                            .fontWeight(.medium)
                        
                        Text("Essayez de modifier votre recherche")
                            .font(.callout)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                } else {
                    // État avec résultats
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredStories) { story in
                                StorySearchResultRow(story: story)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)
                    }
                }
            }
            .background(Color(.systemBackground))
        }
        .navigationBarHidden(true)
        .onAppear {
            // Auto-focus sur la barre de recherche
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isSearchFocused = true
            }
        }
    }
}

struct StorySearchResultRow: View {
    let story: Story
    
    // Couleurs pour les couvertures basées sur le thème
    private var coverColor: Color {
        switch story.theme.lowercased() {
        case "romance": return .pink
        case "adventure": return .blue
        case "fantasy": return .purple
        case "mystery": return .teal
        case "quest": return .orange
        default: return .gray
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Image de couverture
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    LinearGradient(
                        colors: [coverColor, coverColor.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 60, height: 80)
                .overlay {
                    Text(story.title.prefix(1))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            
            // Informations du livre
            VStack(alignment: .leading, spacing: 4) {
                Text(story.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(story.themeName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(story.synopsis)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack(spacing: 4) {
                    Image(systemName: "book.pages")
                        .foregroundColor(.blue)
                        .font(.caption)
                    
                    Text("\(story.numberOfChapters) chapitres")
                        .font(.caption)
                        .fontWeight(.medium)
                    
                    if story.isLiked {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
            }
            
            Spacer()
            
            // Bouton d'action
            Button {
                // Action pour ouvrir/télécharger l'histoire
            } label: {
                Text("LIRE")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .clipShape(Capsule())
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    SearchView()
}