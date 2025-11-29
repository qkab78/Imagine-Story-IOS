//
//  StoryLibraryViewModel.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 29/11/2025.
//

import Foundation

@MainActor
class StoryLibraryViewModel: ObservableObject {
    @Published var stories: [Story] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let getUserStoriesUseCase = GetUserStoriesUseCase()
    
    func loadUserStories(token: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await getUserStoriesUseCase.execute(token: token)
            stories = result
            print("✅ Successfully loaded \(result.count) user stories")
        } catch {
            if let storyError = error as? StoryRepositoryError {
                switch storyError {
                case .fetchUserStoriesFailed(let underlyingError):
                    print("❌ StoryLibraryViewModel - Failed to fetch user stories: \(underlyingError.localizedDescription)")
                    errorMessage = "Impossible de charger vos histoires. Vérifiez votre connexion internet."
                default:
                    print("❌ StoryLibraryViewModel - Unexpected story repository error: \(storyError)")
                    errorMessage = "Une erreur inattendue s'est produite."
                }
            } else {
                print("❌ StoryLibraryViewModel - Unknown error: \(error.localizedDescription)")
                errorMessage = "Une erreur est survenue lors du chargement de vos histoires."
            }
        }
        
        isLoading = false
    }
    
    func retryLoadStories(token: String) async {
        await loadUserStories(token: token)
    }
}

