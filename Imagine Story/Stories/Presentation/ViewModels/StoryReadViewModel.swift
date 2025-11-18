//
//  StoryReadView.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 30/09/2025.
//

import Foundation

@MainActor
class StoryReadViewModel: ObservableObject {
    @Published var story: Story?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let getStoryByIdUseCase = GetStoryByIdUseCase()
    
    func loadStory(id: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await getStoryByIdUseCase.execute(id: id)
            story = result
            print("✅ StoryReadViewModel - Successfully loaded story: \(result.title)")
        } catch {
            if let storyError = error as? StoryRepositoryError {
                switch storyError {
                case .fetchStoryByIdFailed(let underlyingError):
                    print("❌ StoryReadViewModel - Failed to fetch story \(id): \(underlyingError.localizedDescription)")
                    errorMessage = "Impossible de charger cette histoire. Vérifiez votre connexion."
                default:
                    print("❌ StoryReadViewModel - Unexpected error loading story \(id): \(storyError)")
                    errorMessage = "Une erreur inattendue s'est produite."
                }
            } else {
                print("❌ StoryReadViewModel - Unknown error loading story \(id): \(error.localizedDescription)")
                errorMessage = "Une erreur est survenue lors du chargement de l'histoire."
            }
        }
        
        isLoading = false
    }
    
    func retryLoadStory(id: String) async {
        await loadStory(id: id)
    }
    
    func likeStory(id: String) async {
        // TODO: Implémenter la logique de like avec le repository
        do {
            // Ici vous devriez appeler un use case pour liker l'histoire
            print("✅ Story \(id) liked!")
        } catch {
            print("❌ Error liking story \(id): \(error.localizedDescription)")
            errorMessage = "Impossible d'ajouter cette histoire aux favoris."
        }
    }
}
