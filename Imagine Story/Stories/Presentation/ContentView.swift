//
//  ContentView.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 22/09/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @SceneStorage("selectedTab") var selectedTab: Int = 0
    @State private var searchText = ""

    var body: some View {
        if viewModel.user == nil {
            LoginView()
        } else {
            TabView(selection: $selectedTab) {
                Tab("Home", systemImage: "house", value: 0) {
                    NavigationStack {
                        HomeView()
                    }
                }
                Tab("Library", systemImage: "book.pages", value: 1) {
                    NavigationStack {
                        StoryLibraryView()
//                        StorySearchView(searchText: $searchText)
//                            .searchable(text: $searchText, prompt: "Rechercher une histoire...")
//                            .searchToolbarBehavior(.minimize)
//                            .searchSuggestions {
//                                // Suggestions vides pour éviter le background par défaut
//                            }
                    }
                }
                
                Tab("Store", systemImage: "storefront", value: 3) {
                    NavigationStack {
                        StorySearchView(searchText: $searchText)
                            .searchable(text: $searchText, prompt: "Rechercher dans le store...")
                            .searchToolbarBehavior(.minimize)
                            .searchSuggestions {
                                // Suggestions vides pour éviter le background par défaut
                            }
                    }
                }
                
                Tab("Profile", systemImage: "gear", value: 4) {
                    NavigationStack {
                        ProfileView()
                    }
                }
            }
            .tabViewStyle(.sidebarAdaptable)
            .tabBarMinimizeBehavior(.onScrollDown)
            .onAppear {
                // Configuration de l'apparence de la barre de recherche sans background
                configureSearchBarAppearance()
            }
            .task {
                // Configuration supplémentaire au cas où onAppear ne suffit pas
                DispatchQueue.main.async {
                    configureSearchBarAppearance()
                }
            }
        }
    }
    
    private func configureSearchBarAppearance() {
        let appearance = UISearchBar.appearance()
        
        // Supprimer TOUS les backgrounds et bordures
        appearance.backgroundColor = UIColor.clear
        appearance.barTintColor = UIColor.clear
        appearance.backgroundImage = UIImage()
        appearance.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        appearance.setBackgroundImage(UIImage(), for: .any, barMetrics: .compact)
        appearance.scopeBarBackgroundImage = UIImage()
        
        // Configuration du champ de texte - complètement transparent
        appearance.searchTextField.backgroundColor = UIColor.clear
        appearance.searchTextField.layer.cornerRadius = 0
        appearance.searchTextField.layer.borderWidth = 0
        appearance.searchTextField.layer.masksToBounds = true
        appearance.searchTextField.borderStyle = .none
        
        // Supprimer les séparateurs et bordures
        appearance.setSearchFieldBackgroundImage(UIImage(), for: .normal)
        appearance.setSearchFieldBackgroundImage(UIImage(), for: .highlighted)
        
        // Couleur du texte et du placeholder
        appearance.searchTextField.textColor = UIColor.label
        appearance.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        )
        
        // Couleur de la loupe - plus discrète
        if let leftView = appearance.searchTextField.leftView as? UIImageView {
            leftView.tintColor = UIColor.systemGray
        }
        
        // Focus - couleur d'accent (bleu)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.systemBlue
        
        // Configuration supplémentaire pour supprimer tous les effets visuels
        UISearchBar.appearance().searchBarStyle = .minimal
        UISearchBar.appearance().isTranslucent = true
    }
}

struct HomeView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        StoryListView()
    }
}

let baseURL: String = "http://localhost:3333"

enum StoryError: Error {
    case invalidResponse
    case invalidData
    case invalidURL
}


struct StorySearchViewWrapper: View {
    @State private var localSearchText = ""
    
    var body: some View {
        NavigationStack {
            StorySearchView(searchText: $localSearchText)
                .searchable(text: $localSearchText, prompt: "Rechercher une histoire...")
                .searchToolbarBehavior(.minimize)
                .searchSuggestions {
                    // Suggestions vides pour éviter le background par défaut
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
