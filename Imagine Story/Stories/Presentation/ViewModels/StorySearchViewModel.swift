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
    @Published var searchResults: [Story] = []
    @Published var recentSearches: [String] = []
    @Published var isLoading = false
    @Published var isSearching = false
    @Published var errorMessage: String?
    @Published var searchErrorMessage: String?
    
    // MARK: - Dependencies
    private let storyRepository: StoryRepository
    private let searchStoriesUseCase: SearchStoriesUseCase
    
    // MARK: - Private Properties
    private var searchTask: Task<Void, Never>?
    
    // MARK: - Initialization
    init(storyRepository: StoryRepository = StoryRepository(),
         searchStoriesUseCase: SearchStoriesUseCase = SearchStoriesUseCase()) {
        self.storyRepository = storyRepository
        self.searchStoriesUseCase = searchStoriesUseCase
        loadRecentSearches()
    }
    
    // MARK: - Public Methods
    func loadStories() async {
        isLoading = true
        errorMessage = nil
        
        do {
            stories = try await storyRepository.getAllStories()
            storySections = organizeStoriesByTheme(stories)
            print("✅ StorySearchViewModel - Successfully loaded \(stories.count) stories")
        } catch {
            if let storyError = error as? StoryRepositoryError {
                switch storyError {
                case .fetchAllStoriesFailed(let underlyingError):
                    print("❌ StorySearchViewModel - Failed to fetch all stories: \(underlyingError.localizedDescription)")
                    errorMessage = "Impossible de charger les histoires. Vérifiez votre connexion internet."
                default:
                    print("❌ StorySearchViewModel - Unexpected story repository error: \(storyError)")
                    errorMessage = "Une erreur inattendue s'est produite lors du chargement."
                }
            } else {
                print("❌ StorySearchViewModel - Unknown error: \(error.localizedDescription)")
                errorMessage = "Impossible de charger les histoires. Vérifiez votre connexion."
            }
        }
        
        isLoading = false
    }
    
    func retryLoading() async {
        await loadStories()
    }
    
    func searchStories(query: String, userToken: String) async {
        // Annuler la recherche précédente si elle est en cours
        searchTask?.cancel()
        
        // Vider les résultats si la requête est vide
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            searchResults = []
            searchErrorMessage = nil
            return
        }
        
        searchTask = Task {
            isSearching = true
            searchErrorMessage = nil
            
            do {
                // Délai pour éviter trop de requêtes
                try await Task.sleep(nanoseconds: 300_000_000) // 300ms
                
                // Vérifier si la tâche n'a pas été annulée
                guard !Task.isCancelled else { return }
                
                let results = try await searchStoriesUseCase.execute(query: query, userToken: userToken)
                
                // Vérifier à nouveau si la tâche n'a pas été annulée
                guard !Task.isCancelled else { return }
                
                searchResults = results
                print("✅ StorySearchViewModel - Search completed: \(results.count) results for '\(query)'")
                
                // Sauvegarder la recherche si elle a des résultats
                if !results.isEmpty {
                    saveRecentSearch(query)
                }
                
            } catch {
                guard !Task.isCancelled else { return }
                
                if let storyError = error as? StoryRepositoryError {
                    switch storyError {
                    case .searchStoriesFailed(let underlyingError):
                        print("❌ StorySearchViewModel - Search failed: \(underlyingError.localizedDescription)")
                        searchErrorMessage = "Erreur lors de la recherche. Vérifiez votre connexion."
                    default:
                        print("❌ StorySearchViewModel - Unexpected error during search: \(storyError)")
                        searchErrorMessage = "Une erreur inattendue s'est produite."
                    }
                } else {
                    print("❌ StorySearchViewModel - Unknown search error: \(error.localizedDescription)")
                    searchErrorMessage = "Erreur lors de la recherche. Veuillez réessayer."
                }
            }
            
            isSearching = false
        }
    }
    
    func clearSearchResults() {
        searchTask?.cancel()
        searchResults = []
        searchErrorMessage = nil
        isSearching = false
    }
    
    func selectRecentSearch(_ query: String, userToken: String) async {
        await searchStories(query: query, userToken: userToken)
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
    
    private func loadRecentSearches() {
        recentSearches = UserDefaults.standard.stringArray(forKey: "RecentSearches") ?? []
    }
    
    private func saveRecentSearch(_ query: String) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else { return }
        
        // Retirer la recherche existante si elle existe déjà
        recentSearches.removeAll { $0.lowercased() == trimmedQuery.lowercased() }
        
        // Ajouter la nouvelle recherche au début
        recentSearches.insert(trimmedQuery, at: 0)
        
        // Limiter à 10 recherches récentes
        if recentSearches.count > 10 {
            recentSearches = Array(recentSearches.prefix(10))
        }
        
        // Sauvegarder dans UserDefaults
        UserDefaults.standard.set(recentSearches, forKey: "RecentSearches")
    }
}
