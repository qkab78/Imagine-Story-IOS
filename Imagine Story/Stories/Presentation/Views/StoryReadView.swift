//
//  StoryReadView.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 30/09/2025.
//

import Foundation
import SwiftUI

struct StoryReadView: View {
    @StateObject var viewModel = StoryReadViewModel()
    var storyId: String?
    @Environment(\.dismiss) private var dismiss
    
    public var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Chargement...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(ViewLinearGradientBackground)
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(ViewLinearGradientBackground)
                } else if let story = viewModel.story {
                    AppleBooksStyleView(story: story, viewModel: viewModel)
                }
            }
        }
        .navigationBarHidden(true)
        .task {
            await viewModel.loadStory(id: storyId ?? "1ed3df18-0bc3-4a08-aa6b-d5eb20e0dbc0")
        }
    }
}

struct AppleBooksStyleView: View {
    let story: Story
    @ObservedObject var viewModel: StoryReadViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Background avec le gradient pour continuité
            ViewLinearGradientBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header avec bouton share en haut à droite
                    HStack {
                        Spacer()
                        Button {
                            // Action share
                            print("Share action triggered")
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                                .font(.title2)
                                .foregroundColor(.black)
                                .frame(width: 32, height: 32)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Cover Image - grande et centrée comme Apple Books
                    VStack(spacing: 20) {
                        AsyncImage(url: URL(string: story.coverImage)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.3))
                                .overlay(
                                    Image(systemName: "book.closed")
                                        .font(.system(size: 40))
                                        .foregroundColor(.gray)
                                )
                        }
                        .frame(width: 200, height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                        
                        // Titre et sous-titre
                        VStack(spacing: 8) {
                            Text(story.title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            
                            Text(story.themeName)
                                .font(.title3)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Boutons principaux
                    VStack(spacing: 12) {
                        // Bouton principal "LIRE"
                        NavigationLink {
                            StoryLectureView(storyId: story.id)
                        } label: {
                            HStack {
                                Spacer()
                                Text("LIRE")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.vertical, 16)
                            .background(Color.black)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                        // Bouton favoris centré
                        Button {
                            Task {
                                await viewModel.likeStory(id: story.id)
                            }
                        } label: {
                            HStack {
                                Image(systemName: story.isLiked ? "heart.fill" : "heart")
                                    .font(.title3)
                                    .foregroundColor(story.isLiked ? .red : .primary)
                                Text(story.isLiked ? "DANS VOS FAVORIS" : "AJOUTER AUX FAVORIS")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.primary)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 20)
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.8))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Catégories/Tags
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            CategoryTag(text: story.tone, icon: "book.closed")
                            CategoryTag(text: story.themeName, icon: "moon")
                            CategoryTag(text: "\(story.numberOfChapters) chapitres", icon: "list.number")
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Synopsis
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Synopsis")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text(story.synopsis)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 100)
                }
            }
        }
    }
}

struct CategoryTag: View {
    let text: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.white.opacity(0.7))
        .clipShape(Capsule())
    }
}

#Preview {
    StoryReadView()
}
