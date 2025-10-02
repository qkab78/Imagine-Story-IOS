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
    
    public var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Chargement...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else if viewModel.story != nil {
                    ScrollView {
                        StoryHeaderView(story: viewModel.story!)
                        
                        StoryInfoView(viewModel: viewModel, story: viewModel.story!)
                            .padding(.horizontal)
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
            await viewModel.loadStory(id: storyId ?? "1ed3df18-0bc3-4a08-aa6b-d5eb20e0dbc0")
        }
    }
}

struct StoryHeaderView: View {
    var story: Story
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: story.coverImage)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
            }
            .frame(height: 200)
            .clipShape(Rectangle())
            .cornerRadius(20)
            
            Spacer()
            
            Text(story.title)
                .font(.title2)
                .fontWeight(.bold)
        }
            .padding(.top, 80)
            .padding(.horizontal, 24)
    }
}

struct StoryInfoView: View {
    var viewModel: StoryReadViewModel?
    var story: Story
    var body: some View {
        Grid {
            GridRow {
                HStack(spacing: 8) {
                    Image(systemName: "book")
                    Text(story.tone)
                        .font(.caption)
                        .fontWeight(.medium)
                    
                }
                .padding(12)
                .background(Color.gray.opacity(0.2))
                .gridColumnAlignment(.leading)
                
                HStack(spacing: 8) {
                    Image(systemName: "moon.stars")
                    Text(story.theme)
                        .font(.caption)
                        .fontWeight(.medium)
                    
                }
                .padding(12)
                .background(Color.gray.opacity(0.2))
                .gridColumnAlignment(.leading)
                
                HStack(spacing: 8) {
                    Image(systemName: "book")
                    Text("\(story.numberOfChapters) chapitres")
                        .font(.caption)
                        .fontWeight(.medium)
                    
                }
                .padding(12)
                .background(Color.gray.opacity(0.2))
                .gridColumnAlignment(.leading)
                
            }
            
            GridRow {
                HStack(spacing: 8) {
                    Image(systemName: "clock")
                    Text("\(story.numberOfChapters) minutes")
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .padding(12)
                .background(Color.gray.opacity(0.2))
                .gridColumnAlignment(.leading)
                
                
                Button {
                    Task {
                        await viewModel?.likeStory(id: story.id)
                    }
                } label: {
                    Image(systemName: story.isLiked ? "heart.fill" : "heart")
                        .padding()
                        .background(.white)
                        .clipShape(Circle())
                        .frame(width: 44, height: 44)
                        .foregroundColor(.red)
                }
            }
            
            GridRow {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 8) {
                            Image(systemName: "book.pages")
                            Text("Synopsis")
                                .font(.headline)
                                .fontWeight(.medium)
                        }
                        Text(story.synopsis)
                            .lineLimit(3)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
                .background(Color.white)
                .cornerRadius(8)
                .gridColumnAlignment(.leading)
                .gridCellColumns(3)
            }
            
            GridRow {
                NavigationLink {
                    StoryLectureView(storyId: story.id)
                } label: {
                    HStack {
                        Text("Lire l'histoire à mon enfant")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                        Image(systemName: "book.pages.fill")
                            .foregroundStyle(.white)
                    }
                    .padding()
                }
                .background(LinearGradient(colors: [pinkLinearGradientBackground, yellowLinearGradientBackground], startPoint: .top, endPoint: .bottom))
                .cornerRadius(24)
                .gridColumnAlignment(.leading)
                .gridCellColumns(3)
            }

        }
    }
}
#Preview {
    StoryReadView()
}
