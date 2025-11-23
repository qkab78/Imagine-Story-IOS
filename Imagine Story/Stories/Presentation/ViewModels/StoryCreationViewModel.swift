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
    @Published var tones: [StoryTone] = []
    @Published var isLoadingThemes: Bool = false
    @Published var isLoadingTones: Bool = false
    @Published var errorMessage: String?
    @Published var hasError: Bool = false
    @Published var hasTonesError: Bool = false
    @Published var tonesErrorMessage: String?
    
    // MARK: - Dependencies
    private let getAllThemesUseCase: GetAllThemesUseCaseProtocol
    private let getAllTonesUseCase: GetAllTonesUseCaseProtocol
    
    // MARK: - Initialization
    init(
        getAllThemesUseCase: GetAllThemesUseCaseProtocol = GetAllThemesUseCase(),
        getAllTonesUseCase: GetAllTonesUseCaseProtocol = GetAllTonesUseCase()
    ) {
        self.getAllThemesUseCase = getAllThemesUseCase
        self.getAllTonesUseCase = getAllTonesUseCase
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
    
    func loadTones() async {
        isLoadingTones = true
        hasTonesError = false
        tonesErrorMessage = nil
        
        do {
            tones = try await getAllTonesUseCase.execute()
            isLoadingTones = false
            print("✅ Tones loaded successfully: \(tones.count) tones")
        } catch {
            isLoadingTones = false
            hasTonesError = true
            tonesErrorMessage = "Erreur lors du chargement des tonalités: \(error.localizedDescription)"
            print("❌ Error loading tones: \(error)")
        }
    }
    
    func loadAllData() async {
        async let themesTask: () = loadThemes()
        async let tonesTask: () = loadTones()
        _ = await (themesTask, tonesTask)
    }
    
    func retryLoadingThemes() async {
        await loadThemes()
    }
    
    func retryLoadingTones() async {
        await loadTones()
    }
}