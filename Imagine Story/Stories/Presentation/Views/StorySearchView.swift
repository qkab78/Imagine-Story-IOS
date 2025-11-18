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
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Header avec titre principal
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Button(action: {}) {
                                Image(systemName: "chevron.left")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                            }
                            
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
                    
                    // Contenu principal
                    if viewModel.isLoading {
                        VStack {
                            ProgressView()
                                .scaleEffect(1.5)
                                .padding()
                            Text("Chargement des histoires...")
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, 100)
                    } else if let errorMessage = viewModel.errorMessage {
                        VStack {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 50))
                                .foregroundColor(.orange)
                                .padding()
                            Text("Erreur")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text(errorMessage)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            Button("Réessayer") {
                                Task {
                                    await viewModel.retryLoading()
                                }
                            }
                            .padding(.top)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, 100)
                    } else {
                        // Sections d'histoires par thème
                        ForEach(viewModel.storySections) { section in
                            storySectionView(section: section)
                        }
                    }
                    
                    // Footer space pour la tab bar
                    Spacer(minLength: 120)
                }
            }
            .background {
                ViewLinearGradientBackground
                    .edgesIgnoringSafeArea(.all)
            }
            .navigationBarHidden(true)
            .task {
                await viewModel.loadStories()
            }
        }
    }
    
    // MARK: - View Components
    
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
    StorySearchView()
}
