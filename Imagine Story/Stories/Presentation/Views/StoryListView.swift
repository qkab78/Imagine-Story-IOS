//
//  StoryListView.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 28/09/2025.
//

import SwiftUI


struct StoryListView: View {
    @StateObject var viewModel = StoryListViewModel()
    @State private var user = User.MOCK_USER
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Chargement...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    ScrollView {
                        HeaderView(user: user)
                        // HeroSectionView
                        HeroSectionView()
                        // Stories
                        StoriesContainerView(stories: $viewModel.stories)
                        
                    }
                    .ignoresSafeArea()
                    .background {
                        ViewLinearGradientBackground
                            .edgesIgnoringSafeArea(.all)
                    }
                }
            }
        }
        .task {
            await viewModel.loadStories()
        }
    }
}
struct StoriesContainerView: View {
    @Binding var stories: [Story]
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("✨ Histoires récentes")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(greenLinearGradientBackground)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            Text("Histoires que vous pourriez aimer lire.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach($stories, id: \.id) { story in
                        StoryCardView(story: story)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.top)
    }
}

struct StoryCardView: View {
    @Binding var story: Story

    var body: some View {
        NavigationLink {
            StoryReadView(storyId: story.id)
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                // Cover Image avec effet livre subtil
                ZStack {
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
                                Image(systemName: "book.closed")
                                    .foregroundColor(.gray)
                                    .font(.title2)
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
                }
                
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
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    StoryListView()
        .environmentObject(StoryListViewModel())
}
