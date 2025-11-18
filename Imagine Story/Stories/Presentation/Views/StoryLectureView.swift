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
    @State private var selectedChapter: Int = -1 // -1 pour la couverture, 0+ pour les chapitres
    @State private var showConclusion: Bool = false

    
    public var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Chargement...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background {
                            ViewLinearGradientBackground
                                .ignoresSafeArea()
                        }
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background {
                        ViewLinearGradientBackground
                            .ignoresSafeArea()
                    }
                } else if viewModel.story != nil {
                    GeometryReader { geometry in
                        mainView(geometry: geometry)
                    }
                }
            }
        }
        .task {
            await viewModel.loadStory(id: storyId ?? "1ed3df18-0bc3-4a08-aa6b-d5eb20e0dbc0")
        }
    }
    
    private func canGoToPrevious() -> Bool {
        return selectedChapter > -1 || showConclusion
    }
    
    private func canGoToNext() -> Bool {
        if selectedChapter == -1 {
            return true
        } else if showConclusion {
            return false
        } else {
            return selectedChapter < viewModel.story!.numberOfChapters - 1 || !showConclusion
        }
    }
    
    @ViewBuilder
    private func mainView(geometry: GeometryProxy) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                // Image 
                if selectedChapter == -1 {
                    // Page de couverture
                    AsyncImage(url: URL(string: viewModel.story!.chapterImages.first?.imageUrl ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: geometry.size.height * 0.6)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.5)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.top, 40)
                } else if !showConclusion {
                    // Page de chapitre
                    AsyncImage(url: URL(string: viewModel.story!.chapterImages[selectedChapter].imageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: geometry.size.height * 0.5)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.4)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.top, 20)
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    // Titre
                    if selectedChapter == -1 {
                        // Titre de l'histoire sur la couverture
                        Text(viewModel.story!.title ?? "Histoire")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(greenLinearGradientBackground)
                            
                        
                        
                    } else if showConclusion {
                        Text("Conclusion")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(greenLinearGradientBackground)
                    } else {
                        Text("Chapitre \(selectedChapter + 1) : \(viewModel.story!.chapters[selectedChapter].title)")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(greenLinearGradientBackground)
                    }
                    
                    // Contenu
                    if selectedChapter == -1 {
                        // Message d'invitation sur la couverture
                        Text(viewModel.story!.synopsis)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    } else if showConclusion {
                        Text(viewModel.story!.conclusion)
                            .font(.subheadline)
                            .lineSpacing(16)
                            .foregroundColor(.primary)
                    } else {
                        Text(viewModel.story!.chapters[selectedChapter].content)
                            .font(.subheadline)
                            .lineSpacing(16)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding()
            }
        }
        .background {
            ViewLinearGradientBackground
                .ignoresSafeArea()
        }
        .overlay(alignment: .bottom) {
            VStack(spacing: 8) {
                // Texte de statut et barre de progression
                VStack(alignment: .leading, spacing: 4) {
                    // Texte du statut à gauche
                    HStack {
                        if selectedChapter == -1 {
                            Text("Couverture")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else if showConclusion {
                            Text("Conclusion")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else {
                            Text("Page \(selectedChapter + 1) sur \(viewModel.story!.numberOfChapters)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        if selectedChapter == -1 {
                            Text("\(viewModel.story!.numberOfChapters) chapitres")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else if !showConclusion && selectedChapter >= 0 {
                            let pagesRestantes = viewModel.story!.numberOfChapters - selectedChapter - 1
                            if pagesRestantes > 0 {
                                Text("page suivante")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Conclusion")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    // Barre de progression
                    HStack {
                        let totalPages = viewModel.story!.numberOfChapters + 2 // +1 couverture +1 conclusion
                        let currentPage = selectedChapter + (showConclusion ? 2 : 1) + 1 // +1 pour index, +1 pour couverture
                        
                        Rectangle()
                            .fill(greenLinearGradientBackground)
                            .frame(width: CGFloat(currentPage) / CGFloat(totalPages) * (geometry.size.width - 40), height: 3)
                        
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 3)
                    }
                }
                .padding(.horizontal, 20)
                
                // Navigation avec flèches
                HStack {
                    // Flèche précédente
                    Button(action: {
                        if showConclusion {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showConclusion = false
                            }
                        } else if selectedChapter > -1 {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedChapter -= 1
                            }
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(canGoToPrevious() ? greenLinearGradientBackground : .gray.opacity(0.5))
                    }
                    .disabled(!canGoToPrevious())
                    
                    Spacer()
                    
                    // Flèche suivante
                    Button(action: {
                        if selectedChapter == -1 {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedChapter = 0
                            }
                        } else if selectedChapter < viewModel.story!.numberOfChapters - 1 {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedChapter += 1
                            }
                        } else if selectedChapter == viewModel.story!.numberOfChapters - 1 && !showConclusion {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showConclusion = true
                            }
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .foregroundColor(canGoToNext() ? greenLinearGradientBackground : .gray.opacity(0.5))
                    }
                    .disabled(!canGoToNext())
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            }
        }
        .onTapGesture { location in
            let screenWidth = geometry.size.width
            if location.x < screenWidth / 3 {
                // Tap à gauche - page précédente
                if showConclusion {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showConclusion = false
                    }
                } else if selectedChapter > -1 {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedChapter -= 1
                    }
                }
            } else if location.x > screenWidth * 2/3 {
                // Tap à droite - page suivante
                if selectedChapter == -1 {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedChapter = 0
                    }
                } else if selectedChapter < viewModel.story!.numberOfChapters - 1 {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedChapter += 1
                    }
                } else if selectedChapter == viewModel.story!.numberOfChapters - 1 && !showConclusion {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showConclusion = true
                    }
                }
            }
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    let threshold: CGFloat = 50
                    if value.translation.width > threshold {
                        // Swipe vers la droite - page précédente
                        if showConclusion {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showConclusion = false
                            }
                        } else if selectedChapter > -1 {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedChapter -= 1
                            }
                        }
                    } else if value.translation.width < -threshold {
                        // Swipe vers la gauche - page suivante
                        if selectedChapter == -1 {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedChapter = 0
                            }
                        } else if selectedChapter < viewModel.story!.numberOfChapters - 1 {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedChapter += 1
                            }
                        } else if selectedChapter == viewModel.story!.numberOfChapters - 1 && !showConclusion {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showConclusion = true
                            }
                        }
                    }
                }
        )
    }
}

#Preview {
    StoryLectureView()
        .environmentObject(StoryReadViewModel())
}
