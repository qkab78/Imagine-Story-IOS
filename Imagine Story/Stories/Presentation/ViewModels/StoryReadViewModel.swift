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
        } catch {
            errorMessage = "Une erreur est survenue lors du chargement des histoires : \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
