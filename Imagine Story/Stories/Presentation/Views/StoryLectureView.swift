//
//  StoryLectureView.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 01/10/2025.
//

import Foundation
import SwiftUI

struct StoryLectureView: View {
    @StateObject var viewModel = StoryReadViewModel()
    var storyId: String?
    @State private var selectedChapter: Int = 0
    @State private var showConclusion: Bool = false
    
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
                            AsyncImage(url: URL(string: viewModel.story!.chapterImages[selectedChapter].imageUrl)) { image in
                                image
                                    .resizable()
                            } placeholder: {
                                Color.gray
                            }
                            .aspectRatio(contentMode: .fit)
                            .edgesIgnoringSafeArea(.all)
                            .cornerRadius(16)

                        VStack(alignment: .leading, spacing: 8) {
                            if showConclusion {
                                Text("Conclusion")
                                    .font(.title2)
                                    .foregroundColor(greenLinearGradientBackground)
                            } else {
                                Text("Chapitre \(selectedChapter + 1) : \(viewModel.story!.chapters[selectedChapter].title)")
                                    .font(.title2)
                                    .foregroundColor(greenLinearGradientBackground)
                            }
                            
                            if showConclusion {
                                Text(viewModel.story!.conclusion)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                    .lineSpacing(16)
                            } else {
                                Text(viewModel.story!.chapters[selectedChapter].content)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                    .lineSpacing(16)
                            }
                        }
                        .padding()
                    }
                    .background {
                        ViewLinearGradientBackground
                            .edgesIgnoringSafeArea(.all)
                    }
                    .animation(.default)
                    .overlay(alignment: .bottom) {
                        VStack(alignment: .leading) {
                            Divider()
                            
                            HStack {
                                Text("Chapitre \(selectedChapter + 1) sur \(viewModel.story!.numberOfChapters)")
                            }
                            .padding()
                            
                            HStack {
                                Button {
                                    selectedChapter -= 1
                                    showConclusion = false
                                } label: {
                                    HStack(spacing: 8) {
                                        Image(systemName: "arrow.left")
                                            .foregroundColor(.white)
                                        
                                        Text("Précédent")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                    }
                                }
                                .disabled(selectedChapter == 0)
                                .padding()
                                .background(greenLinearGradientBackground)
                                .cornerRadius(8)
                                

                                Button {
                                    if selectedChapter < viewModel.story!.numberOfChapters - 1 {
                                        selectedChapter += 1
                                    } else if selectedChapter == viewModel.story!.numberOfChapters - 1 {
                                        showConclusion = true
                                    }
                                } label: {
                                    HStack(spacing: 8) {
                                        Text(selectedChapter == viewModel.story!.numberOfChapters - 1 ? "Fin" : "Suivant")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                        
                                        Image(systemName: "arrow.right")
                                            .foregroundColor(.white)
                                    }
                                }
                                .disabled(showConclusion == true)
                                .padding()
                                .background(pinkLinearGradientBackground)
                                .cornerRadius(8)
                                
                                Button {} label: {
                                    Image(systemName: "square.and.arrow.up")
                                        .foregroundColor(greenLinearGradientBackground)
                                        .padding()
                                        .background(.white)
                                        .clipShape(Circle())
                                }
                            }
                            .padding()
                            .frame(height: 10)
                        }
                        .padding()
                    }
                }
            }
        }
        .task {
            await viewModel.loadStory(id: storyId ?? "1ed3df18-0bc3-4a08-aa6b-d5eb20e0dbc0")
        }
    }
}

#Preview {
    StoryLectureView()
}
