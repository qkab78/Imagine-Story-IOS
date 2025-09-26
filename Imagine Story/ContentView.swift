//
//  ContentView.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 22/09/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var stories: [Story] = []
    @State private var user = User(firstName: "Quentin")
    
    var body: some View {
        ScrollView {
            HeaderView(user: $user)
            // HeroSectionView
            HeroSectionView()
            // Stories
            StoriesContainerView(stories: $stories)
            
        }
        .ignoresSafeArea()
        .background {
            ViewLinearGradientBackground
                .edgesIgnoringSafeArea(.all)
        }
        .task {
            do {
                stories = try await getStories()
                print("Stories fetched successfully: \(stories)")
            } catch StoryError.invalidData {
                print("Error fetching stories: Invalid data")
            } catch StoryError.invalidURL {
                print("Error fetching stories: Invalid URL")
            } catch StoryError.invalidResponse {
                print("Error fetching stories: Invalid response")
            } catch {
                print("Unexpected error")
            }
        }
    }
}

let baseURL: String = "http://localhost:3333"
let pinkLinearGradientBackground = Color(red: 1, green: 0.42, blue: 0.616)
let yellowLinearGradientBackground = Color(red: 1, green: 0.718, blue: 0.302)
let greenLinearGradientBackground = Color(red: 0.18, green: 0.49, blue: 0.196)

let blueLinearGradientBackground = Color(red: 0.129, green: 0.588, blue: 0.953)
let tealLinearGradientBackground = Color(red: 0.012, green: 0.855, blue: 0.776)

let ViewLinearGradientBackground = LinearGradient(colors:[Color(red: 1, green: 0.973, blue: 0.882), Color(red: 1, green: 0.878, blue: 0.941)], startPoint: .topLeading, endPoint: .bottomTrailing)

struct Story: Codable {
    let id: String
    let title: String
    let synopsis: String
    let coverImage: String
    let numberOfChapters: Int
}

struct User: Codable {
    let firstName: String
}

func getStories() async throws -> [Story] {
    let endpoint = "\(baseURL)/stories"
    guard let url = URL(string: endpoint) else {
        throw StoryError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from:url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw StoryError.invalidResponse
    }
    
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        
        return try decoder.decode([Story].self, from: data)
    } catch {
        throw StoryError.invalidData
    }
}
func goToStoryCreationPage() {
    print("navigating to story creation page")
}
enum StoryError: Error {
    case invalidResponse
    case invalidData
    case invalidURL
}

struct StoriesContainerView: View {
    @Binding var stories: [Story]
    var body: some View {
        VStack(alignment: .leading) {
            Text("✨ Histoires récentes")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(greenLinearGradientBackground)
            
            LazyVStack(spacing: 32) {
                ForEach($stories, id: \.id) { story in
                     StoryCardView(story: story)
                    Divider()
                }
            }
            .padding()
            .background(.white)
            .frame(width: 370)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .padding(.top)
        
    }
}
struct StoryCardView: View {
    @Binding var story: Story
    
    var body: some View {
        HStack {
            // Cover Image
            AsyncImage(url: URL(string: "\(baseURL)/images/covers/\(story.coverImage)")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Rectangle()
            }
            .frame(width: 56, height: 56)
            .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(story.title)
                    .font(.headline)
                    .foregroundColor(greenLinearGradientBackground)
                Text(story.synopsis)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct HeroSectionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
                VStack(alignment: .leading, spacing: 16) {
                    Button(action: goToStoryCreationPage) {
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
                        
                    }
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Button(action: goToStoryCreationPage) {
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
                        
                    }
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    
                }
                .padding(.horizontal)
        }.padding(.top)
    }
}

struct HeaderView: View {
    @Binding var user: User
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
            Text(user.firstName.first?.uppercased() ?? "")
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
#Preview {
    ContentView()
}
