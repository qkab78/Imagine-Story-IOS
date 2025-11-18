//
//  StorySearchView.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 23/10/2025.
//

import SwiftUI

// Modèle pour les sections de thèmes avec histoires
struct StorySection: Identifiable {
    let id = UUID()
    let title: String
    let stories: [Story]
}

struct StorySearchView: View {
    @StateObject private var viewModel = StorySearchViewModel()
    @Environment(\.isSearching) private var isSearching
    @Binding var searchText: String
    
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
        ScrollView {
            VStack(spacing: 0) {
                if isSearching {
                    // Interface de recherche avec Liquid Glass
                    searchContentView
                } else {
                    // Interface normale - Header avec titre principal
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        
                        Text("Histoires & Contes")
                            .font(.system(size: 34, weight: .bold, design: .default))
                            .foregroundColor(.black)
                            .padding(.horizontal)
                            .padding(.bottom, 30)
                    }
                    
                    // Contenu principal normal
                    normalContentView
                }
                
                // Footer space pour la tab bar
                Spacer(minLength: 120)
            }
        }
        .background {
            ViewLinearGradientBackground
                .edgesIgnoringSafeArea(.all)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                // Vide pour masquer le titre mais garder la toolbar
                Text("")
            }
        }
        .task {
            await viewModel.loadStories()
        }
    }
    
    // MARK: - View Components
    
    // Vue pour le contenu de recherche avec Liquid Glass
    private var searchContentView: some View {
        VStack(spacing: 24) {
            // Header de recherche avec Liquid Glass
            VStack(spacing: 16) {
                Text("Rechercher une Histoire")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top)
                    .glassEffect(.regular.tint(.blue.opacity(0.1)), in: .rect(cornerRadius: 12))
                
                // Suggestions de recherche avec Liquid Glass
                if searchText.isEmpty {
                    recentSearchesView
                }
            }
            .padding(.horizontal)
            
            // Résultats de recherche
            if !searchText.isEmpty {
                if filteredStories.isEmpty {
                    // État sans résultat avec Liquid Glass
                    noResultsView
                } else {
                    // Résultats avec Liquid Glass
                    searchResultsView
                }
            }
        }
        .padding(.top, 20)
    }
    
    // Vue pour les recherches récentes
    private var recentSearchesView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recherches Populaires")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(["Aventure", "Romance", "Mystère", "Fantaisie"], id: \.self) { suggestion in
                    Button {
                        searchText = suggestion
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondary)
                                .font(.system(size: 14))
                            
                            Text(suggestion)
                                .foregroundColor(.primary)
                                .font(.callout)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 10))
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    // Vue sans résultats avec Liquid Glass
    private var noResultsView: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
                .glassEffect(.regular.tint(.orange.opacity(0.2)), in: .circle)
            
            VStack(spacing: 8) {
                Text("Aucun résultat")
                    .font(.title2)
                    .fontWeight(.medium)
                
                Text("Essayez de modifier votre recherche")
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
            .glassEffect(.regular.tint(.gray.opacity(0.1)), in: .rect(cornerRadius: 12))
        }
        .padding(.horizontal)
        .padding(.top, 60)
    }
    
    // Vue des résultats de recherche avec Liquid Glass
    private var searchResultsView: some View {
        LazyVStack(spacing: 16) {
            ForEach(filteredStories) { story in
                searchResultRow(story: story)
            }
        }
        .padding(.horizontal)
    }
    
    // Vue pour une ligne de résultat de recherche avec Liquid Glass
    private func searchResultRow(story: Story) -> some View {
        NavigationLink(destination: StoryReadView(storyId: story.id)) {
            HStack(spacing: 12) {
                // Couverture avec effet glass
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [coverColor(for: story.theme), coverColor(for: story.theme).opacity(0.7)],
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
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 8))
                
                // Informations avec effet glass
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
                
                // Bouton LIRE avec effet glass
                Button {
                    // Action pour lire l'histoire
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
                .buttonStyle(.glass)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 12))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // Vue pour le contenu normal (non-recherche)
    private var normalContentView: some View {
        Group {
            if viewModel.isLoading {
                VStack {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                        .glassEffect(.regular.tint(.blue.opacity(0.2)), in: .circle)
                    
                    Text("Chargement des histoires...")
                        .foregroundColor(.secondary)
                        .glassEffect(.regular.tint(.gray.opacity(0.1)), in: .rect(cornerRadius: 8))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 100)
            } else if let errorMessage = viewModel.errorMessage {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.orange)
                        .padding()
                        .glassEffect(.regular.tint(.orange.opacity(0.2)), in: .circle)
                    
                    VStack(spacing: 8) {
                        Text("Erreur")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(errorMessage)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .glassEffect(.regular.tint(.red.opacity(0.1)), in: .rect(cornerRadius: 12))
                    
                    Button("Réessayer") {
                        Task {
                            await viewModel.retryLoading()
                        }
                    }
                    .buttonStyle(.glass)
                    .padding(.top)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 100)
            } else {
                // Sections d'histoires par thème avec Liquid Glass
                ForEach(viewModel.storySections) { section in
                    storySectionView(section: section)
                }
            }
        }
    }
    
    // Fonction utilitaire pour les couleurs des couvertures
    private func coverColor(for theme: String) -> Color {
        switch theme.lowercased() {
        case "romance": return .pink
        case "adventure": return .blue
        case "fantasy": return .purple
        case "mystery": return .teal
        case "quest": return .orange
        default: return .gray
        }
    }
    
    // Vue pour une section d'histoires
    func storySectionView(section: StorySection) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header de la section avec flèche "See All"
            HStack {
                Text(section.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Spacer()
                
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Text("See All")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(.horizontal)
            
            // Scroll horizontal des histoires
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(section.stories) { story in
                        storyCardView(story: story)
                    }
                }
                .padding(.horizontal)
            }
            
            Divider()
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 30)
        }
    }
    
    // Vue pour une carte d'histoire
    func storyCardView(story: Story) -> some View {
        NavigationLink(destination: StoryReadView(storyId: story.id)) {
            VStack(alignment: .leading, spacing: 8) {
                // Couverture de l'histoire
                AsyncImage(url: URL(string: story.coverImage)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .overlay {
                            VStack {
                                Image(systemName: "book.closed")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                Text(story.title)
                                    .font(.caption2)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(3)
                                    .padding(.horizontal, 8)
                            }
                        }
                }
                .frame(width: 120, height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
                
                // Informations de l'histoire avec hauteurs fixes
                VStack(alignment: .leading, spacing: 4) {
                    Text(story.title)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .frame(width: 120, height: 32, alignment: .topLeading) // Hauteur fixe pour 2 lignes
                    
                    Text(story.themeName)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .frame(width: 120, height: 16, alignment: .topLeading) // Hauteur fixe pour 1 ligne
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }

}

#Preview {
    struct PreviewWrapper: View {
        @State private var searchText = ""
        
        var body: some View {
            StorySearchView(searchText: $searchText)
        }
    }
    
    return PreviewWrapper()
}
