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
            print("✅ Successfully loaded \(result.count) stories")
        } catch {
            if let storyError = error as? StoryRepositoryError {
                switch storyError {
                case .fetchAllStoriesFailed(let underlyingError):
                    print("❌ StoryListViewModel - Failed to fetch all stories: \(underlyingError.localizedDescription)")
                    errorMessage = "Impossible de charger les histoires. Vérifiez votre connexion internet."
                default:
                    print("❌ StoryListViewModel - Unexpected story repository error: \(storyError)")
                    errorMessage = "Une erreur inattendue s'est produite."
                }
            } else {
                print("❌ StoryListViewModel - Unknown error: \(error.localizedDescription)")
                errorMessage = "Une erreur est survenue lors du chargement des histoires."
            }
        }
        
        isLoading = false
    }
    
    func retryLoadStories() async {
        await loadStories()
    }
}
