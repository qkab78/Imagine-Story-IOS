//
//  StoryCreationView.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 23/10/2025.
//

import SwiftUI

// MARK: - Models
class StoryData: ObservableObject {
    @Published var title: String = ""
    @Published var synopsis: String = ""
    @Published var theme: StoryTheme?
    @Published var protagonistName: String = ""
    @Published var species: String = ""
    @Published var targetAge: Int = 5
    @Published var chapterCount: Int = 5
    @Published var language: StoryLanguage?
    @Published var tone: StoryTone?
    @Published var autoGenerateProfiles: Bool = true
    @Published var autoGenerateImages: Bool = true
    @Published var isPublic: Bool = false
    
    var isStep1Valid: Bool {
        title.count >= 3 && synopsis.count >= 6 && theme != nil
    }
    
    var isStep2Valid: Bool {
        !protagonistName.isEmpty && !species.isEmpty
    }
    
    var isStep3Valid: Bool {
        tone != nil && language != nil
    }
}


// MARK: - Main View
struct StoryCreationView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var storyData = StoryData()
    @StateObject private var viewModel = StoryCreationViewModel()
    @State private var currentStep = 1
    @State private var isAnimating = false
    @State private var showProcessingView = false
    @State private var showSuccessView = false
    @State private var createdStoryId: String?
    @State private var navigateToStory = false
    private let totalSteps = 5
    
    private var userToken: String {
        authViewModel.user?.token ?? ""
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Progress Bar
                ProgressBarView(currentStep: currentStep, totalSteps: totalSteps)
                
                // Content
                TabView(selection: $currentStep) {
                    StepOneView(storyData: storyData, viewModel: viewModel)
                        .tag(1)
                    
                    StepTwoView(storyData: storyData)
                        .tag(2)
                    
                    StepThreeView(storyData: storyData, viewModel: viewModel)
                        .tag(3)
                    
                    StepFourView(storyData: storyData)
                        .tag(4)
                    
                    StepFiveView(storyData: storyData)
                        .tag(5)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentStep)
                
                // Navigation Buttons
                NavigationButtonsView(
                    currentStep: $currentStep,
                    totalSteps: totalSteps,
                    canProceed: canProceedFromCurrentStep(),
                    storyData: storyData,
                    showProcessingView: $showProcessingView
                )
            }
            .navigationTitle("Créer une Histoire")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(false)
            .background {
                ViewLinearGradientBackground
                    .edgesIgnoringSafeArea(.all)
            }
            .navigationDestination(isPresented: $navigateToStory) {
                if let storyId = createdStoryId {
                    StoryReadView(storyId: storyId)
                }
            }
        }
        .fullScreenCover(isPresented: $showProcessingView) {
            StoryProcessingView(
                storyData: storyData,
                viewModel: viewModel,
                userToken: userToken,
                isPresented: $showProcessingView,
                showSuccess: $showSuccessView,
                createdStoryId: $createdStoryId
            )
        }
        .fullScreenCover(isPresented: $showSuccessView) {
            StorySuccessView(
                storyData: storyData,
                isPresented: $showSuccessView,
                createdStoryId: createdStoryId,
                onReadStory: {
                    showSuccessView = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        navigateToStory = true
                    }
                }
            )
        }
        .task {
            await viewModel.loadAllData()
        }
    }
    
    private func canProceedFromCurrentStep() -> Bool {
        switch currentStep {
        case 1: return storyData.isStep1Valid
        case 2: return storyData.isStep2Valid
        case 3: return storyData.isStep3Valid
        case 4, 5: return true
        default: return false
        }
    }
}

// MARK: - Progress Bar
struct ProgressBarView: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Étape \(currentStep) sur \(totalSteps)")
                    .font(.caption)
                    .foregroundColor(greenLinearGradientBackground)
                    .fontWeight(.medium)
                Spacer()
                Text("\(Int(Double(currentStep) / Double(totalSteps) * 100))%")
                    .font(.caption.weight(.bold))
                    .foregroundColor(greenLinearGradientBackground)
            }
            
            ProgressView(value: Double(currentStep), total: Double(totalSteps))
                .progressViewStyle(.linear)
                .tint(LinearGradient(
                    colors: [pinkLinearGradientBackground, yellowLinearGradientBackground],
                    startPoint: .leading,
                    endPoint: .trailing
                ))
                .background(Color.white.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
        .padding(.bottom, 20)
        .background(Color.clear)
    }
}

// MARK: - Step 1: Story Basics
struct StepOneView: View {
    @ObservedObject var storyData: StoryData
    @ObservedObject var viewModel: StoryCreationViewModel
    @State private var showThemePicker = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                StepHeaderView(
                    title: "Les Bases de l'Histoire",
                    subtitle: "Donnons vie à votre idée !"
                )
                
                VStack(spacing: 20) {
                    // Title Field
                    CustomTextField(
                        title: "Titre de l'histoire",
                        text: $storyData.title,
                        placeholder: "ex: La Grande Aventure de Luna",
                        icon: "book.fill",
                        isValid: storyData.title.count >= 3
                    )
                    
                    // Synopsis Field
                    CustomTextEditor(
                        title: "Synopsis",
                        text: $storyData.synopsis,
                        placeholder: "Racontez-nous votre histoire en quelques mots...",
                        icon: "text.alignleft",
                        isValid: storyData.synopsis.count >= 6
                    )
                    
                    // Theme Selector
                    ThemeSelectorView(
                        selectedTheme: $storyData.theme,
                        showPicker: $showThemePicker,
                        viewModel: viewModel
                    )
                }
            }
            .padding()
        }
        .sheet(isPresented: $showThemePicker) {
            ThemePickerSheet(selectedTheme: $storyData.theme, viewModel: viewModel)
        }
    }
}

// MARK: - Step 2: Character Details
struct StepTwoView: View {
    @ObservedObject var storyData: StoryData
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                StepHeaderView(
                    title: "Le Personnage Principal",
                    subtitle: "Qui sera le héros de cette aventure ?"
                )
                
                VStack(spacing: 20) {
                    CustomTextField(
                        title: "Nom du protagoniste",
                        text: $storyData.protagonistName,
                        placeholder: "ex: Luna, Max, Stella...",
                        icon: "person.fill",
                        isValid: !storyData.protagonistName.isEmpty
                    )
                    
                    CustomTextField(
                        title: "Espèce",
                        text: $storyData.species,
                        placeholder: "ex: Petit garçon, Chat magique, Dragon...",
                        icon: "pawprint.fill",
                        isValid: !storyData.species.isEmpty
                    )
                    
                    AgeSliderView(targetAge: $storyData.targetAge)
                }
            }
            .padding()
        }
    }
}

// MARK: - Step 3: Story Settings  
struct StepThreeView: View {
    @ObservedObject var storyData: StoryData
    @ObservedObject var viewModel: StoryCreationViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                StepHeaderView(
                    title: "Paramètres de l'Histoire",
                    subtitle: "Personnalisons votre création"
                )
                
                VStack(spacing: 20) {
                    TonePickerView(selectedTone: $storyData.tone, viewModel: viewModel)
                    
                    ChapterCounterView(chapterCount: $storyData.chapterCount)
                    
                    LanguagePickerView(selectedLanguage: $storyData.language, viewModel: viewModel)
                }
            }
            .padding()
        }
    }
}

// MARK: - Step 4: Generation Options
struct StepFourView: View {
    @ObservedObject var storyData: StoryData
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                StepHeaderView(
                    title: "Options de Génération",
                    subtitle: "Laissez l'IA vous aider ✨"
                )
                
                VStack(spacing: 16) {
                    ToggleCardView(
                        title: "Profils de Personnages",
                        subtitle: "Génère automatiquement des personnages secondaires",
                        icon: "person.3.fill",
                        isOn: $storyData.autoGenerateProfiles
                    )
                    
                    ToggleCardView(
                        title: "Images de Chapitres",
                        subtitle: "Crée des illustrations pour chaque chapitre",
                        icon: "photo.artframe",
                        isOn: $storyData.autoGenerateImages
                    )
                }
            }
            .padding()
        }
    }
}

// MARK: - Step 5: Final Settings
struct StepFiveView: View {
    @ObservedObject var storyData: StoryData
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                StepHeaderView(
                    title: "Derniers Réglages",
                    subtitle: "Nous y sommes presque ! 🎉"
                )
                
                VStack(spacing: 16) {
                    ToggleCardView(
                        title: "Histoire Publique",
                        subtitle: "Partagez votre création avec la communauté",
                        icon: "globe",
                        isOn: $storyData.isPublic
                    )
                    
                    // Summary Card
                    SummaryCardView(storyData: storyData)
                }
            }
            .padding()
        }
    }
}

// MARK: - Custom Components
struct StepHeaderView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.title2.weight(.bold))
                .foregroundColor(greenLinearGradientBackground)
                .multilineTextAlignment(.center)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.bottom, 8)
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    let icon: String
    let isValid: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label(title, systemImage: icon)
                    .font(.headline)
                    .foregroundColor(greenLinearGradientBackground)
                Spacer()
                if !text.isEmpty {
                    Image(systemName: isValid ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                        .foregroundColor(isValid ? greenLinearGradientBackground : .orange)
                }
            }
            
            TextField(placeholder, text: $text)
                .textFieldStyle(.roundedBorder)
                .font(.body)
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct CustomTextEditor: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    let icon: String
    let isValid: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label(title, systemImage: icon)
                    .font(.headline)
                    .foregroundColor(greenLinearGradientBackground)
                Spacer()
                if !text.isEmpty {
                    Image(systemName: isValid ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                        .foregroundColor(isValid ? greenLinearGradientBackground : .orange)
                }
            }
            
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                        .padding(.leading, 4)
                }
                
                TextEditor(text: $text)
                    .frame(minHeight: 80)
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.separator).opacity(0.3))
            )
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct ThemeSelectorView: View {
    @Binding var selectedTheme: StoryTheme?
    @Binding var showPicker: Bool
    @ObservedObject var viewModel: StoryCreationViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label("Thème", systemImage: "tag.fill")
                    .font(.headline)
                    .foregroundColor(greenLinearGradientBackground)
                Spacer()
                if selectedTheme != nil {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(greenLinearGradientBackground)
                }
            }
            
            Button(action: {
                if viewModel.isLoadingThemes {
                    return // Empêcher l'ouverture pendant le chargement
                }
                showPicker = true
            }) {
                HStack {
                    if viewModel.isLoadingThemes {
                        HStack {
                            ProgressView()
                                .scaleEffect(0.7)
                            Text("Chargement des thèmes...")
                                .foregroundColor(.secondary)
                        }
                    } else if viewModel.hasError {
                        HStack {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundColor(.orange)
                            Text("Erreur - Appuyer pour réessayer")
                                .foregroundColor(.orange)
                        }
                    } else if let theme = selectedTheme {
                        Text("\(theme.icon) \(theme.name)")
                            .foregroundColor(.primary)
                    } else {
                        Text("Choisir un thème...")
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    if !viewModel.isLoadingThemes {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
            .disabled(viewModel.isLoadingThemes)
            
            if viewModel.hasError {
                Button(action: {
                    Task {
                        await viewModel.retryLoadingThemes()
                    }
                }) {
                    Text("Réessayer")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct ThemePickerSheet: View {
    @Binding var selectedTheme: StoryTheme?
    @ObservedObject var viewModel: StoryCreationViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoadingThemes {
                    VStack(spacing: 16) {
                        ProgressView()
                        Text("Chargement des thèmes...")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.hasError {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text("Erreur de chargement")
                            .font(.headline)
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        Button("Réessayer") {
                            Task {
                                await viewModel.retryLoadingThemes()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.themes) { theme in
                            ThemeRowView(
                                theme: theme,
                                isSelected: selectedTheme?.id == theme.id,
                                action: {
                                    selectedTheme = theme
                                    dismiss()
                                }
                            )
                        }
                    }
                }
            }
            .navigationTitle("Choisir un Thème")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") { dismiss() }
                }
            }
        }
        .task {
            if viewModel.themes.isEmpty && !viewModel.isLoadingThemes {
                await viewModel.loadThemes()
            }
        }
    }
}

struct AgeSliderView: View {
    @Binding var targetAge: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label("Âge du lecteur", systemImage: "person.crop.circle")
                    .font(.headline)
                    .foregroundColor(greenLinearGradientBackground)
                Spacer()
                Text("\(targetAge) ans")
                    .font(.headline)
                    .foregroundColor(pinkLinearGradientBackground)
                    .fontWeight(.bold)
            }
            
            Slider(value: Binding(
                get: { Double(targetAge) },
                set: { targetAge = Int($0) }
            ), in: 3...10, step: 1)
            .tint(LinearGradient(
                colors: [pinkLinearGradientBackground, yellowLinearGradientBackground],
                startPoint: .leading,
                endPoint: .trailing
            ))
            
            HStack {
                Text("3 ans")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text("10 ans")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct TonePickerView: View {
    @Binding var selectedTone: StoryTone?
    @ObservedObject var viewModel: StoryCreationViewModel
    @State private var showPicker = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label("Tonalité", systemImage: "theatermasks.fill")
                    .font(.headline)
                    .foregroundColor(greenLinearGradientBackground)
                Spacer()
                if selectedTone != nil {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(greenLinearGradientBackground)
                }
            }
            
            if viewModel.isLoadingTones {
                HStack {
                    ProgressView()
                        .scaleEffect(0.7)
                    Text("Chargement des tonalités...")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
            } else if viewModel.hasTonesError {
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(.orange)
                        Text("Erreur de chargement")
                            .foregroundColor(.orange)
                    }
                    Button("Réessayer") {
                        Task {
                            await viewModel.retryLoadingTones()
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                    ForEach(viewModel.tones) { tone in
                        Button(action: {
                            selectedTone = tone
                        }) {
                            HStack(spacing: 4) {
                                Text(tone.icon)
                                    .font(.caption)
                                Text(tone.displayName)
                                    .font(.subheadline.weight(.medium))
                            }
                            .foregroundColor(selectedTone?.id == tone.id ? .white : .primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(selectedTone?.id == tone.id ? 
                                          LinearGradient(colors: [tone.color.opacity(0.8), tone.color], startPoint: .top, endPoint: .bottom) :
                                          LinearGradient(colors: [Color(.systemGray6)], startPoint: .top, endPoint: .bottom)
                                    )
                            )
                        }
                    }
                }
            }
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct ChapterCounterView: View {
    @Binding var chapterCount: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label("Nombre de chapitres", systemImage: "book.pages")
                    .font(.headline)
                    .foregroundColor(greenLinearGradientBackground)
                Spacer()
                Text("\(chapterCount)")
                    .font(.headline)
                    .foregroundColor(pinkLinearGradientBackground)
                    .fontWeight(.bold)
            }
            
            HStack {
                Button(action: {
                    if chapterCount > 1 {
                        chapterCount -= 1
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundColor(chapterCount > 1 ? blueLinearGradientBackground : .gray)
                }
                .disabled(chapterCount <= 1)
                
                Spacer()
                
                Text("Chapitres")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button(action: {
                    if chapterCount < 10 {
                        chapterCount += 1
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(chapterCount < 10 ? blueLinearGradientBackground : .gray)
                }
                .disabled(chapterCount >= 10)
            }
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct LanguagePickerView: View {
    @Binding var selectedLanguage: StoryLanguage?
    @ObservedObject var viewModel: StoryCreationViewModel
    @State private var showPicker = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label("Langue", systemImage: "globe")
                    .font(.headline)
                    .foregroundColor(greenLinearGradientBackground)
                Spacer()
                if selectedLanguage != nil {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(greenLinearGradientBackground)
                }
            }
            
            if viewModel.isLoadingLanguages {
                HStack {
                    ProgressView()
                        .scaleEffect(0.7)
                    Text("Chargement des langues...")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
            } else if viewModel.hasLanguagesError {
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(.orange)
                        Text("Erreur de chargement")
                            .foregroundColor(.orange)
                    }
                    Button("Réessayer") {
                        Task {
                            await viewModel.retryLoadingLanguages()
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
            } else {
                Button(action: {
                    showPicker = true
                }) {
                    HStack {
                        if let language = selectedLanguage {
                            Text("\(language.flag) \(language.displayName)")
                                .foregroundColor(.primary)
                            if !language.isFree {
                                Image(systemName: "crown.fill")
                                    .foregroundColor(.orange)
                                    .font(.caption)
                            }
                        } else {
                            Text("Choisir une langue...")
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        .sheet(isPresented: $showPicker) {
            LanguagePickerSheet(selectedLanguage: $selectedLanguage, viewModel: viewModel)
        }
    }
}

struct LanguagePickerSheet: View {
    @Binding var selectedLanguage: StoryLanguage?
    @ObservedObject var viewModel: StoryCreationViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoadingLanguages {
                    VStack(spacing: 16) {
                        ProgressView()
                        Text("Chargement des langues...")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.hasLanguagesError {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text("Erreur de chargement")
                            .font(.headline)
                        if let errorMessage = viewModel.languagesErrorMessage {
                            Text(errorMessage)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        Button("Réessayer") {
                            Task {
                                await viewModel.retryLoadingLanguages()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        // Section langues gratuites
                        Section("Langues gratuites") {
                            ForEach(viewModel.languages.filter { $0.isFree }) { language in
                                LanguageRowView(
                                    language: language,
                                    isSelected: selectedLanguage?.id == language.id,
                                    action: {
                                        selectedLanguage = language
                                        dismiss()
                                    }
                                )
                            }
                        }
                        
                        // Section langues premium
                        Section("Langues premium") {
                            ForEach(viewModel.languages.filter { !$0.isFree }) { language in
                                LanguageRowView(
                                    language: language,
                                    isSelected: selectedLanguage?.id == language.id,
                                    action: {
                                        selectedLanguage = language
                                        dismiss()
                                    }
                                )
                            }
                        }
                    }
                }
            }
            .navigationTitle("Choisir une Langue")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fermer") { dismiss() }
                }
            }
        }
    }
}

struct LanguageRowView: View {
    let language: StoryLanguage
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Drapeau
                Text(language.flag)
                    .font(.title2)
                    .frame(width: 40)
                
                // Nom de la langue
                VStack(alignment: .leading, spacing: 2) {
                    Text(language.displayName)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(language.code)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Badge premium si nécessaire
                if !language.isFree {
                    HStack(spacing: 4) {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.orange)
                            .font(.caption)
                        Text("Premium")
                            .font(.caption2)
                            .foregroundColor(.orange)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.orange.opacity(0.1))
                    .clipShape(Capsule())
                }
                
                // Checkmark de sélection
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title3)
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
}

struct ToggleCardView: View {
    let title: String
    let subtitle: String
    let icon: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(pinkLinearGradientBackground)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(greenLinearGradientBackground)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(LinearGradient(
                    colors: [pinkLinearGradientBackground, yellowLinearGradientBackground],
                    startPoint: .leading,
                    endPoint: .trailing
                ))
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct SummaryCardView: View {
    @ObservedObject var storyData: StoryData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Résumé de votre histoire", systemImage: "doc.text")
                .font(.headline)
                .foregroundColor(greenLinearGradientBackground)
            
            VStack(alignment: .leading, spacing: 8) {
                SummaryRowView(title: "Titre", value: storyData.title)
                SummaryRowView(title: "Thème", value: storyData.theme?.name ?? "")
                SummaryRowView(title: "Protagoniste", value: storyData.protagonistName)
                SummaryRowView(title: "Tonalité", value: storyData.tone?.displayName ?? "")
                SummaryRowView(title: "Langue", value: storyData.language != nil ? "\(storyData.language!.flag) \(storyData.language!.displayName)" : "")
                SummaryRowView(title: "Chapitres", value: "\(storyData.chapterCount)")
            }
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(LinearGradient(
                    colors: [pinkLinearGradientBackground.opacity(0.3), yellowLinearGradientBackground.opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ), lineWidth: 1)
        )
    }
}

struct SummaryRowView: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        .font(.subheadline)
    }
}

struct NavigationButtonsView: View {
    @Binding var currentStep: Int
    let totalSteps: Int
    let canProceed: Bool
    @ObservedObject var storyData: StoryData
    @Binding var showProcessingView: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                // Back Button
                if currentStep > 1 {
                    Button(action: {
                        withAnimation(.spring(response: 0.5)) {
                            currentStep -= 1
                        }
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Précédent")
                        }
                        .font(.headline)
                        .foregroundColor(blueLinearGradientBackground)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                    }
                }
                
                // Next/Create Button
                Button(action: {
                    if currentStep < totalSteps {
                        withAnimation(.spring(response: 0.5)) {
                            currentStep += 1
                        }
                    } else {
                        // Create story action
                        showProcessingView = true
                    }
                }) {
                    HStack {
                        Text(currentStep < totalSteps ? "Suivant" : "Créer l'Histoire")
                        if currentStep < totalSteps {
                            Image(systemName: "chevron.right")
                        } else {
                            Image(systemName: "wand.and.stars")
                        }
                    }
                    .font(.headline.weight(.semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        canProceed ? 
                        LinearGradient(colors: [pinkLinearGradientBackground, yellowLinearGradientBackground], startPoint: .leading, endPoint: .trailing) :
                        LinearGradient(colors: [Color.gray], startPoint: .leading, endPoint: .trailing)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: canProceed ? pinkLinearGradientBackground.opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
                }
                .disabled(!canProceed)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 8)
        }
        .background(Color.clear)
    }
}

// MARK: - Story Processing View (Klarna style)
struct StoryProcessingView: View {
    @ObservedObject var storyData: StoryData
    @ObservedObject var viewModel: StoryCreationViewModel
    let userToken: String
    @Binding var isPresented: Bool
    @Binding var showSuccess: Bool
    @Binding var createdStoryId: String?
    @State private var animationProgress: Double = 0
    @State private var currentStep = 0
    @State private var isCompleted = false
    @State private var hasError = false
    @State private var errorMessage: String?
    
    private let processingSteps = [
        "Préparation de votre histoire...",
        "Création de l'univers...",
        "Développement des personnages...",
        "Écriture des chapitres...",
        "Finalisation de l'histoire..."
    ]
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Background similaire au style Klarna
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Icon principal avec animation (style Klarna)
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        hasError ? Color.red.opacity(0.3) : Color.pink.opacity(0.3),
                                        hasError ? Color.red.opacity(0.1) : Color.pink.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 120, height: 120)
                            .scaleEffect(1 + sin(animationProgress * 2) * 0.1)
                        
                        if hasError {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 40, weight: .medium))
                                .foregroundColor(.red)
                        } else if !isCompleted {
                            Image(systemName: "wand.and.stars")
                                .font(.system(size: 40, weight: .medium))
                                .foregroundColor(.pink)
                                .rotationEffect(.degrees(animationProgress * 360))
                        } else {
                            Image(systemName: "checkmark")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.pink)
                                .scaleEffect(1.2)
                        }
                    }
                    
                    // Texte principal
                    VStack(spacing: 12) {
                        if hasError {
                            Text("Une erreur est survenue")
                                .font(.title2.weight(.semibold))
                                .foregroundColor(.primary)
                            
                            if let error = errorMessage {
                                Text(error)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                            }
                        } else if !isCompleted {
                            Text("Création en cours...")
                                .font(.title2.weight(.semibold))
                                .foregroundColor(.primary)
                            
                            if currentStep < processingSteps.count {
                                Text(processingSteps[currentStep])
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                            }
                        } else {
                            Text("Histoire créée !")
                                .font(.title2.weight(.semibold))
                                .foregroundColor(.primary)
                        }
                    }
                    
                    // Barre de progression ou bouton réessayer
                    if hasError {
                        VStack(spacing: 16) {
                            Button(action: {
                                hasError = false
                                errorMessage = nil
                                currentStep = 0
                                startCreationProcess()
                            }) {
                                Text("Réessayer")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.pink)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .padding(.horizontal, 60)
                            
                            Button(action: {
                                isPresented = false
                            }) {
                                Text("Annuler")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }
                        }
                    } else if !isCompleted {
                        VStack(spacing: 8) {
                            ProgressView(value: Double(currentStep), total: Double(processingSteps.count))
                                .progressViewStyle(.linear)
                                .tint(.pink)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                .frame(width: geometry.size.width * 0.6)
                            
                            Text("\(currentStep + 1) sur \(processingSteps.count)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    // Message d'encouragement (style Klarna)
                    if !isCompleted && !hasError {
                        Text("Votre histoire unique est en cours de création.\nCela peut prendre quelques instants...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
        .onAppear {
            startCreationProcess()
        }
    }
    
    private func startCreationProcess() {
        // Animation continue de l'icône
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
            animationProgress = 1
        }
        
        // Démarrer l'appel API
        Task {
            // Animation des étapes pendant l'appel
            let stepTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { timer in
                if currentStep < processingSteps.count - 1 && !isCompleted && !hasError {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        currentStep += 1
                    }
                }
            }
            
            // Appel API réel
            let storyId = await viewModel.createStory(from: storyData, token: userToken)
            
            stepTimer.invalidate()
            
            if let id = storyId {
                // Succès
                withAnimation(.easeInOut(duration: 0.5)) {
                    currentStep = processingSteps.count - 1
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        isCompleted = true
                    }
                    
                    createdStoryId = id
                    
                    // Transition vers la vue de succès
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        isPresented = false
                        showSuccess = true
                    }
                }
            } else {
                // Erreur
                withAnimation(.easeInOut(duration: 0.3)) {
                    hasError = true
                    errorMessage = viewModel.creationError ?? "Une erreur inattendue s'est produite"
                }
            }
        }
    }
}

// MARK: - Story Success View (Monzo style)
struct StorySuccessView: View {
    @ObservedObject var storyData: StoryData
    @Binding var isPresented: Bool
    let createdStoryId: String?
    let onReadStory: () -> Void
    @State private var showConfetti = false
    @State private var buttonScale: CGFloat = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Background couleur douce (style Monzo)
                LinearGradient(
                    colors: [
                        Color(.systemBackground),
                        Color(.systemGray6).opacity(0.3)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 32) {
                    Spacer()
                    
                    // Illustration principale (style Monzo)
                    ZStack {
                        // Éléments décoratifs flottants
                        ForEach(0..<8, id: \.self) { index in
                            Circle()
                                .fill(getRandomColor(for: index))
                                .frame(width: CGFloat.random(in: 4...8))
                                .position(
                                    x: CGFloat.random(in: 50...250),
                                    y: CGFloat.random(in: 50...150)
                                )
                                .opacity(showConfetti ? 1 : 0)
                                .scaleEffect(showConfetti ? 1 : 0)
                                .animation(
                                    .spring(response: 0.8, dampingFraction: 0.6)
                                    .delay(Double(index) * 0.1),
                                    value: showConfetti
                                )
                        }
                        
                        // Icône principale (corne d'abondance créative comme Monzo)
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.blue, Color.blue.opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                                .rotationEffect(.degrees(-15))
                            
                            Image(systemName: "party.popper")
                                .font(.system(size: 35, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .scaleEffect(showConfetti ? 1 : 0.5)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7), value: showConfetti)
                    }
                    .frame(height: 200)
                    
                    // Titre de succès (style Monzo)
                    VStack(spacing: 16) {
                        Text("Votre histoire est prête !")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                        
                        Text("'\(storyData.title)' a été créée avec succès. Vous pouvez maintenant la lire et la partager avec vos proches.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                            .lineLimit(nil)
                    }
                    
                    // Informations sur l'histoire créée
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "book.pages")
                                .foregroundColor(.blue)
                            Text("\(storyData.chapterCount) chapitres")
                                .font(.subheadline.weight(.medium))
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Image(systemName: "person.crop.circle")
                                .foregroundColor(.green)
                            Text("\(storyData.targetAge) ans")
                                .font(.subheadline.weight(.medium))
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 40)
                        
                        if let theme = storyData.theme {
                            HStack {
                                Image(systemName: "tag.fill")
                                    .foregroundColor(.purple)
                                Text("\(theme.icon) \(theme.name)")
                                    .font(.subheadline.weight(.medium))
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            .padding(.horizontal, 40)
                        }
                    }
                    
                    Spacer()
                    
                    // Actions (style Monzo)
                    VStack(spacing: 12) {
                        // Bouton principal - Lire l'histoire
                        Button(action: {
                            onReadStory()
                        }) {
                            HStack {
                                Image(systemName: "book.open")
                                Text("Lire l'Histoire")
                                    .fontWeight(.semibold)
                            }
                            .font(.body)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [Color.blue, Color.blue.opacity(0.9)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .scaleEffect(buttonScale)
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.1)) {
                                buttonScale = 0.95
                            }
                            withAnimation(.easeInOut(duration: 0.1).delay(0.1)) {
                                buttonScale = 1.0
                            }
                        }
                        
                        // Bouton secondaire
                        Button(action: {
                            isPresented = false
                        }) {
                            Text("Retour à l'accueil")
                                .font(.body.weight(.medium))
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.clear)
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            // Animation d'apparition
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showConfetti = true
            }
        }
    }
    
    private func getRandomColor(for index: Int) -> Color {
        let colors: [Color] = [.red, .blue, .green, .orange, .purple, .pink, .yellow]
        return colors[index % colors.count]
    }
}

// MARK: - Theme Row View
struct ThemeRowView: View {
    let theme: StoryTheme
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 12) {
                // Icône du thème
                Text(theme.icon)
                    .font(.title2)
                    .frame(width: 40)
                
                // Contenu principal
                VStack(alignment: .leading, spacing: 4) {
                    Text(theme.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Text(theme.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
                
                Spacer()
                
                // Checkmark de sélection
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title3)
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    StoryCreationView()
}
