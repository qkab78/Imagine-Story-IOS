//
//  StorySearchViewModel.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 18/11/2025.
//

import Foundation
import SwiftUI

@MainActor
class StorySearchViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var stories: [Story] = []
    @Published var storySections: [StorySection] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Dependencies
    private let storyRepository: StoryRepository
    
    // MARK: - Initialization
    init(storyRepository: StoryRepository = StoryRepository()) {
        self.storyRepository = storyRepository
    }
    
    // MARK: - Public Methods
    func loadStories() async {
        isLoading = true
        errorMessage = nil
        
        do {
            stories = try await storyRepository.getAllStories()
            storySections = organizeStoriesByTheme(stories)
            isLoading = false
        } catch {
            errorMessage = "Impossible de charger les histoires. Vérifiez votre connexion."
            isLoading = false
            print("Error loading stories: \(error)")
        }
    }
    
    func retryLoading() async {
        await loadStories()
    }
    
    // MARK: - Private Methods
    private func organizeStoriesByTheme(_ stories: [Story]) -> [StorySection] {
        // Grouper les histoires par thème
        let groupedStories = Dictionary(grouping: stories) { $0.themeName }
        
        // Convertir en sections et trier par nom de thème
        return groupedStories.compactMap { (themeName, stories) in
            StorySection(title: themeName, stories: stories)
        }.sorted { $0.title < $1.title }
    }
}
