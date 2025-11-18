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
                        StorySearchView(searchText: $searchText)
                            .searchable(text: $searchText, prompt: "Rechercher une histoire...")
                            .searchToolbarBehavior(.minimize)
                            .searchSuggestions {
                                // Suggestions vides pour éviter le background par défaut
                            }
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
let pinkLinearGradientBackground = Color(red: 1, green: 0.42, blue: 0.616)
let yellowLinearGradientBackground = Color(red: 1, green: 0.718, blue: 0.302)
let greenLinearGradientBackground = Color(red: 0.18, green: 0.49, blue: 0.196)

let blueLinearGradientBackground = Color(red: 0.129, green: 0.588, blue: 0.953)
let tealLinearGradientBackground = Color(red: 0.012, green: 0.855, blue: 0.776)

let ViewLinearGradientBackground = LinearGradient(colors:[Color(red: 1, green: 0.973, blue: 0.882), Color(red: 1, green: 0.878, blue: 0.941)], startPoint: .topLeading, endPoint: .bottomTrailing)

func goToStoryCreationPage() {
    print("navigating to story creation page")
}
enum StoryError: Error {
    case invalidResponse
    case invalidData
    case invalidURL
}

struct HeroSectionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
                VStack(alignment: .leading, spacing: 16) {
                    NavigationLink {
                        StoryCreationView()
                    } label: {
                        HStack(spacing: 32) {
                            Text("✨")
                                .foregroundColor(.white)
                                .font(.title)
                                .fontWeight(.bold)
                                .background {
                                    Circle()
                                        .fill(LinearGradient(colors: [pinkLinearGradientBackground, yellowLinearGradientBackground], startPoint: .top, endPoint: .bottom))
                                        .frame(width: 56, height: 56)
                                }
                                .padding()
                            
                            VStack(alignment: .leading) {
                                Text("Créer une histoire")
                                    .font(.subheadline)
                                    .foregroundColor(greenLinearGradientBackground)
                                    .fontWeight(.bold)
                                Text("Invente une nouvelle aventure magique")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }.frame(maxWidth: .infinity)
                        }
                        .padding()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    NavigationLink {
                        StorySearchViewWrapper()
                    } label: {
                        HStack() {
                            Text("📖")
                                .foregroundColor(.white)
                                .font(.title)
                                .fontWeight(.bold)
                                .background {
                                    Circle()
                                        .fill(LinearGradient(colors: [blueLinearGradientBackground, tealLinearGradientBackground], startPoint: .top, endPoint: .bottom))
                                        .frame(width: 56, height: 56)
                                }
                                .padding()
                            
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                Text("Lire une histoire")
                                    .font(.subheadline)
                                    .foregroundColor(greenLinearGradientBackground)
                                    .fontWeight(.bold)
                                Text("Découvre tes histoires préférées")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }.frame(maxWidth: .infinity)
                        }
                        .padding()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                }
                .padding(.horizontal)
        }.padding(.top)
    }
}

struct HeaderView: View {
    let user: User

    @State private var selected = true
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Bonjour \(user.firstName) ! 👋")
                    .font(.title)
                    .foregroundColor(greenLinearGradientBackground)
                    .fontWeight(.bold)
                Text("Prêt pour une nouvelle aventure ?")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        
            Spacer()
            Text(user.initials)
                .foregroundColor(.white)
                .font(.title)
                .fontWeight(.bold)
                .background {
                    Circle()
                        .fill(LinearGradient(colors: [pinkLinearGradientBackground, yellowLinearGradientBackground], startPoint: .top, endPoint: .bottom))
                        .frame(width: 44, height: 44)
                }
                .scaleEffect(selected ? 1.2 : 1)
                .animation(.bouncy, value: selected)
                .onTapGesture {
                    selected.toggle()
                }
                .padding()
            
        }
        .padding(.top, 80)
        .padding(.horizontal, 24)
    }
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
