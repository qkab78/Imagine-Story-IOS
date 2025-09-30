//
//  StoryListView.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 28/09/2025.
//

import SwiftUI


struct StoryListView: View {
    @StateObject var viewModel = StoryListViewModel()
    @State private var user = User(firstName: "Quentin")
    
    var body: some View {
        NavigationView {
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
                        HeaderView(user: $user)
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
        VStack(alignment: .leading) {
            Text("✨ Histoires récentes")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(greenLinearGradientBackground)
            
            LazyVStack(spacing: 32) {
                ForEach($stories, id: \.id) { story in
                     StoryCardView(story: story)
                    Divider()
                }
            }
            .padding()
            .background(.white)
            .frame(width: 370)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .padding(.top)
        
    }
}

struct StoryCardView: View {
    @Binding var story: Story

    var body: some View {
        HStack(spacing: 8) {
            // Cover Image
            AsyncImage(url: URL(string: story.coverImage)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Circle()
            }
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text(story.title)
                    .font(.headline)
                    .foregroundColor(greenLinearGradientBackground)
                    .frame(maxWidth: 300, alignment: .leading)
                
                Text("\(story.numberOfChapters) chapitres")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
        }

    }
}

#Preview {
    StoryListView()
}
