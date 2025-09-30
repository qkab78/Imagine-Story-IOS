//
//  StoryListViewModel.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 28/09/2025.
//

import Foundation

@MainActor
class StoryListViewModel: ObservableObject {
    @Published var stories: [Story] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let getAllStoriesUseCase = GetAllStoriesUseCase()
    
    func loadStories() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await getAllStoriesUseCase.execute()
            stories = result
        } catch {
            errorMessage = "Une erreur est survenue lors du chargement des histoires : \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
