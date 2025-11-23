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
    @Published var languages: [StoryLanguage] = []
    @Published var isLoadingThemes: Bool = false
    @Published var isLoadingTones: Bool = false
    @Published var isLoadingLanguages: Bool = false
    @Published var errorMessage: String?
    @Published var hasError: Bool = false
    @Published var hasTonesError: Bool = false
    @Published var tonesErrorMessage: String?
    @Published var hasLanguagesError: Bool = false
    @Published var languagesErrorMessage: String?
    
    // MARK: - Creation State
    @Published var isCreatingStory: Bool = false
    @Published var creationError: String?
    @Published var createdStoryId: String?
    
    // MARK: - Dependencies
    private let getAllThemesUseCase: GetAllThemesUseCaseProtocol
    private let getAllTonesUseCase: GetAllTonesUseCaseProtocol
    private let getAllLanguagesUseCase: GetAllLanguagesUseCaseProtocol
    private let createStoryUseCase: CreateStoryUseCaseProtocol
    
    // MARK: - Initialization
    init(
        getAllThemesUseCase: GetAllThemesUseCaseProtocol = GetAllThemesUseCase(),
        getAllTonesUseCase: GetAllTonesUseCaseProtocol = GetAllTonesUseCase(),
        getAllLanguagesUseCase: GetAllLanguagesUseCaseProtocol = GetAllLanguagesUseCase(),
        createStoryUseCase: CreateStoryUseCaseProtocol = CreateStoryUseCase()
    ) {
        self.getAllThemesUseCase = getAllThemesUseCase
        self.getAllTonesUseCase = getAllTonesUseCase
        self.getAllLanguagesUseCase = getAllLanguagesUseCase
        self.createStoryUseCase = createStoryUseCase
    }
    
    // MARK: - Create Story
    func createStory(from storyData: StoryData, token: String) async -> String? {
        guard let theme = storyData.theme,
              let language = storyData.language,
              let tone = storyData.tone else {
            creationError = "Veuillez remplir tous les champs requis"
            return nil
        }
        
        isCreatingStory = true
        creationError = nil
        createdStoryId = nil
        
        let request = CreateStoryRequest(
            title: storyData.title,
            synopsis: storyData.synopsis,
            theme: theme.id,
            protagonist: storyData.protagonistName,
            species: storyData.species,
            childAge: storyData.targetAge,
            numberOfChapters: storyData.chapterCount,
            language: language.id,
            tone: tone.id,
            isPrivate: !storyData.isPublic,
            generateCharacters: storyData.autoGenerateProfiles,
            generateChapterImages: storyData.autoGenerateImages
        )
        
        do {
            let response = try await createStoryUseCase.execute(request: request, token: token)
            createdStoryId = response.id
            isCreatingStory = false
            print("✅ Story created with ID: \(response.id)")
            return response.id
        } catch {
            isCreatingStory = false
            creationError = "Erreur lors de la création: \(error.localizedDescription)"
            print("❌ Error creating story: \(error)")
            return nil
        }
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
    
    func loadLanguages() async {
        isLoadingLanguages = true
        hasLanguagesError = false
        languagesErrorMessage = nil
        
        do {
            languages = try await getAllLanguagesUseCase.execute()
            isLoadingLanguages = false
            print("✅ Languages loaded successfully: \(languages.count) languages")
        } catch {
            isLoadingLanguages = false
            hasLanguagesError = true
            languagesErrorMessage = "Erreur lors du chargement des langues: \(error.localizedDescription)"
            print("❌ Error loading languages: \(error)")
        }
    }
    
    func loadAllData() async {
        async let themesTask: () = loadThemes()
        async let tonesTask: () = loadTones()
        async let languagesTask: () = loadLanguages()
        _ = await (themesTask, tonesTask, languagesTask)
    }
    
    func retryLoadingThemes() async {
        await loadThemes()
    }
    
    func retryLoadingTones() async {
        await loadTones()
    }
    
    func retryLoadingLanguages() async {
        await loadLanguages()
    }
}