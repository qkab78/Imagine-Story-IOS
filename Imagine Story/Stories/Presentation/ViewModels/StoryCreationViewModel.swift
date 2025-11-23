//
//  StoryCreationViewModel.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 23/11/2025.
//

import Foundation

@MainActor
class StoryCreationViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var themes: [StoryTheme] = []
    @Published var isLoadingThemes: Bool = false
    @Published var errorMessage: String?
    @Published var hasError: Bool = false
    
    // MARK: - Dependencies
    private let getAllThemesUseCase: GetAllThemesUseCaseProtocol
    
    // MARK: - Initialization
    init(getAllThemesUseCase: GetAllThemesUseCaseProtocol = GetAllThemesUseCase()) {
        self.getAllThemesUseCase = getAllThemesUseCase
    }
    
    // MARK: - Public Methods
    func loadThemes() async {
        isLoadingThemes = true
        hasError = false
        errorMessage = nil
        
        do {
            themes = try await getAllThemesUseCase.execute()
            isLoadingThemes = false
            print("✅ Themes loaded successfully: \(themes.count) themes")
        } catch {
            isLoadingThemes = false
            hasError = true
            errorMessage = "Erreur lors du chargement des thèmes: \(error.localizedDescription)"
            print("❌ Error loading themes: \(error)")
        }
    }
    
    func retryLoadingThemes() async {
        await loadThemes()
    }
}