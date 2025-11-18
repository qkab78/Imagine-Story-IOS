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
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var searchText: String
    
    
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
        .onChange(of: searchText) { oldValue, newValue in
            if !newValue.isEmpty {
                Task {
                    await viewModel.searchStories(query: newValue, userToken: authViewModel.user?.token ?? "")
                }
            } else {
                viewModel.clearSearchResults()
            }
        }
        .onDisappear {
            viewModel.clearSearchResults()
        }
    }
    
    // MARK: - View Components
    
    // Vue pour le contenu de recherche avec Liquid Glass
    private var searchContentView: some View {
        VStack(spacing: 24) {
            // Header de recherche avec Liquid Glass
            VStack(spacing: 16) {
                
                // Suggestions de recherche avec Liquid Glass
                if searchText.isEmpty {
                    recentSearchesView
                }
            }
            .padding(.horizontal)
            
            // Résultats de recherche
            if !searchText.isEmpty {
                if viewModel.searchResults.isEmpty && !viewModel.isSearching && viewModel.searchErrorMessage == nil {
                    // État sans résultat avec Liquid Glass
                    noResultsView
                } else if viewModel.isSearching || viewModel.searchErrorMessage != nil {
                    // État de chargement ou d'erreur
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
                Text(viewModel.recentSearches.isEmpty ? "Recherches Populaires" : "Recherches Récentes")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            LazyVStack(alignment: .leading, spacing: 12) {
                let suggestions = viewModel.recentSearches.isEmpty ? 
                    ["Aventure", "Romance", "Mystère", "Fantaisie"] : 
                    viewModel.recentSearches
                
                ForEach(suggestions, id: \.self) { suggestion in
                    Button {
                        searchText = suggestion
                        Task {
                            await viewModel.selectRecentSearch(suggestion, userToken: authViewModel.user?.token ?? "")
                        }
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: viewModel.recentSearches.isEmpty ? "magnifyingglass" : "clock")
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
        VStack(spacing: 0) {
            Spacer()
            
            if viewModel.isSearching {
                // État de chargement
                VStack(spacing: 24) {
                    ProgressView()
                        .scaleEffect(1.5)
                        .glassEffect(.regular.tint(.blue.opacity(0.2)), in: .circle)
                    
                    Text("Recherche en cours...")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .glassEffect(.regular.tint(.gray.opacity(0.1)), in: .rect(cornerRadius: 8))
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 80)
                
            } else if let errorMessage = viewModel.searchErrorMessage {
                // État d'erreur
                VStack(spacing: 24) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 50))
                        .foregroundColor(.orange)
                        .glassEffect(.regular.tint(.orange.opacity(0.2)), in: .circle)
                    
                    VStack(spacing: 12) {
                        Text("Erreur de recherche")
                            .font(.title2)
                            .fontWeight(.medium)
                        
                        Text(errorMessage)
                            .font(.callout)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .glassEffect(.regular.tint(.red.opacity(0.1)), in: .rect(cornerRadius: 12))
                    
                    Button("Réessayer") {
                        Task {
                            await viewModel.searchStories(query: searchText, userToken: authViewModel.user?.token ?? "")
                        }
                    }
                    .buttonStyle(.glass)
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 80)
                
            } else {
                // Aucun résultat
                VStack(spacing: 24) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)
                        .glassEffect(.regular.tint(.orange.opacity(0.2)), in: .circle)
                    
                    VStack(spacing: 12) {
                        Text("Aucun résultat")
                            .font(.title2)
                            .fontWeight(.medium)
                        
                        Text("Essayez de modifier votre recherche")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .glassEffect(.regular.tint(.gray.opacity(0.1)), in: .rect(cornerRadius: 12))
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 80)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 300)
        .padding(.horizontal, 20)
    }
    
    // Vue des résultats de recherche avec Liquid Glass
    private var searchResultsView: some View {
        LazyVStack(spacing: 16) {
            ForEach(viewModel.searchResults) { story in
                searchResultRow(story: story)
            }
        }
        .padding(.horizontal)
    }
    
    // Vue pour une ligne de résultat de recherche avec Liquid Glass
    private func searchResultRow(story: Story) -> some View {
        NavigationLink(destination: StoryReadView(storyId: story.id)) {
            HStack(spacing: 12) {
                // Couverture avec image réelle ou placeholder
                Group {
                    if !story.coverImage.isEmpty {
                        AsyncImage(url: URL(string: story.coverImage)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            // Placeholder pendant le chargement
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    LinearGradient(
                                        colors: [coverColor(for: story.theme), coverColor(for: story.theme).opacity(0.7)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .overlay {
                                    VStack {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .scaleEffect(0.8)
                                    }
                                }
                        }
                    } else {
                        // Placeholder quand il n'y a pas d'image
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [coverColor(for: story.theme), coverColor(for: story.theme).opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay {
                                VStack {
                                    Image(systemName: "book.closed")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                    Text(story.title.prefix(1))
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                            }
                    }
                }
                .frame(width: 60, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8))
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
