//
//  StorySearchView.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 23/10/2025.
//

import SwiftUI

// Modèle pour les livres/histoires
struct Book: Identifiable {
    let id = UUID()
    let title: String
    let author: String
    let coverGradient: [Color]
    let theme: String
}

// Modèle pour les sections de thèmes avec livres
struct BookSection: Identifiable {
    let id = UUID()
    let title: String
    let books: [Book]
}

struct StorySearchView: View {
    // Données temporaires pour l'UI - chaque thème devient une section
    let bookSections = [
        BookSection(
            title: "Aventure et exploration",
            books: [
                Book(title: "Le Trésor du Pirate", author: "Tom Adventure", coverGradient: [blueLinearGradientBackground, tealLinearGradientBackground], theme: "Aventure et exploration"),
                Book(title: "L'Île Mystérieuse", author: "Sarah Explorer", coverGradient: [Color.blue, Color.cyan], theme: "Aventure et exploration"),
                Book(title: "La Carte Secrète", author: "Jack Discovery", coverGradient: [Color.teal, Color.mint], theme: "Aventure et exploration"),
                Book(title: "Les Explorateurs", author: "Emma Quest", coverGradient: [Color.indigo, Color.blue], theme: "Aventure et exploration")
            ]
        ),
        BookSection(
            title: "Amitié et solidarité",
            books: [
                Book(title: "Les Meilleurs Amis", author: "Julie Heart", coverGradient: [Color.pink, Color.orange], theme: "Amitié et solidarité"),
                Book(title: "Ensemble pour Toujours", author: "Max Friendship", coverGradient: [Color.red, Color.pink], theme: "Amitié et solidarité"),
                Book(title: "L'Entraide", author: "Luna Kind", coverGradient: [Color.orange, Color.yellow], theme: "Amitié et solidarité"),
                Book(title: "Mon Ami Fidèle", author: "Leo Trust", coverGradient: [Color.purple, Color.pink], theme: "Amitié et solidarité")
            ]
        ),
        BookSection(
            title: "Magie et fantastique",
            books: [
                Book(title: "L'École de Magie", author: "Merlin Wizard", coverGradient: [pinkLinearGradientBackground, yellowLinearGradientBackground], theme: "Magie et fantastique"),
                Book(title: "La Baguette Enchantée", author: "Fairy Magic", coverGradient: [Color.purple, Color.blue], theme: "Magie et fantastique"),
                Book(title: "Le Royaume des Fées", author: "Crystal Dream", coverGradient: [Color.pink, Color.purple], theme: "Magie et fantastique"),
                Book(title: "Potion Magique", author: "Spell Caster", coverGradient: [Color.indigo, Color.purple], theme: "Magie et fantastique")
            ]
        ),
        BookSection(
            title: "Animaux et nature",
            books: [
                Book(title: "L'Ours et l'Abeille", author: "Forest Friend", coverGradient: [Color.green, Color.mint], theme: "Animaux et nature"),
                Book(title: "La Famille Renard", author: "Wild Nature", coverGradient: [Color.brown, Color.orange], theme: "Animaux et nature"),
                Book(title: "Les Oiseaux Chanteurs", author: "Sky Melody", coverGradient: [Color.blue, Color.green], theme: "Animaux et nature"),
                Book(title: "Le Jardin Secret", author: "Bloom Writer", coverGradient: [Color.green, Color.yellow], theme: "Animaux et nature")
            ]
        ),
        BookSection(
            title: "Famille et foyer",
            books: [
                Book(title: "Chez Grand-mère", author: "Warm Home", coverGradient: [greenLinearGradientBackground, yellowLinearGradientBackground], theme: "Famille et foyer"),
                Book(title: "Notre Maison", author: "Family Love", coverGradient: [Color.brown, Color.orange], theme: "Famille et foyer"),
                Book(title: "Dimanche en Famille", author: "Together Time", coverGradient: [Color.red, Color.orange], theme: "Famille et foyer"),
                Book(title: "Papa et Moi", author: "Father Bond", coverGradient: [Color.blue, Color.teal], theme: "Famille et foyer")
            ]
        ),
        BookSection(
            title: "Apprentissage et école",
            books: [
                Book(title: "Ma Première École", author: "Teacher Joy", coverGradient: [Color.blue, Color.cyan], theme: "Apprentissage et école"),
                Book(title: "J'Apprends à Lire", author: "Study Smart", coverGradient: [Color.green, Color.blue], theme: "Apprentissage et école"),
                Book(title: "Les Chiffres Magiques", author: "Math Fun", coverGradient: [Color.purple, Color.blue], theme: "Apprentissage et école"),
                Book(title: "L'Alphabet Dansant", author: "Letter Play", coverGradient: [Color.orange, Color.yellow], theme: "Apprentissage et école")
            ]
        ),
        BookSection(
            title: "Courage et dépassement",
            books: [
                Book(title: "Le Petit Héros", author: "Brave Heart", coverGradient: [Color.orange, Color.red], theme: "Courage et dépassement"),
                Book(title: "J'ai Peur du Noir", author: "Fear Fighter", coverGradient: [Color.indigo, Color.purple], theme: "Courage et dépassement"),
                Book(title: "La Grande Aventure", author: "Bold Spirit", coverGradient: [Color.red, Color.orange], theme: "Courage et dépassement"),
                Book(title: "Je Peux le Faire", author: "Can Do", coverGradient: [Color.green, Color.teal], theme: "Courage et dépassement")
            ]
        ),
        BookSection(
            title: "Mystère et enquête",
            books: [
                Book(title: "Le Mystère du Château", author: "Detective Kid", coverGradient: [Color.indigo, Color.purple], theme: "Mystère et enquête"),
                Book(title: "L'Enquête de Luna", author: "Mystery Solver", coverGradient: [Color.purple, Color.blue], theme: "Mystère et enquête"),
                Book(title: "Qui a Volé les Cookies?", author: "Clue Hunter", coverGradient: [Color.brown, Color.orange], theme: "Mystère et enquête"),
                Book(title: "L'Énigme de la Forêt", author: "Secret Seeker", coverGradient: [Color.green, Color.teal], theme: "Mystère et enquête")
            ]
        )
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Header avec titre principal
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Button(action: {}) {
                                Image(systemName: "chevron.left")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        
                        Text("Histoires & Contes")
                            .font(.system(size: 34, weight: .bold, design: .default))
                            .foregroundColor(.black)
                            .padding(.horizontal)
                            .padding(.bottom, 30)
                    }
                    
                    // Sections de livres par thème
                    ForEach(bookSections) { section in
                        bookSectionView(section: section)
                    }
                    
                    // Footer space pour la tab bar
                    Spacer(minLength: 120)
                }
            }
            .background(ViewLinearGradientBackground)
            .navigationBarHidden(true)
        }
    }
    
    // Vue pour une section de livres
    func bookSectionView(section: BookSection) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header de la section avec flèche "See All"
            HStack {
                Text(section.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Spacer()
                
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Text("See All")
                            .font(.subheadline)
                            .foregroundColor(blueLinearGradientBackground)
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(blueLinearGradientBackground)
                    }
                }
            }
            .padding(.horizontal)
            
            // Scroll horizontal des livres
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(section.books) { book in
                        bookCardView(book: book)
                    }
                }
                .padding(.horizontal)
            }
            
            Divider()
                .padding(.horizontal)
                .padding(.top, 20)
                .padding(.bottom, 30)
        }
    }
    
    // Vue pour une carte de livre
    func bookCardView(book: Book) -> some View {
        Button(action: {
            // Action pour ouvrir le livre
        }) {
            VStack(alignment: .leading, spacing: 8) {
                // Couverture du livre
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(LinearGradient(
                        colors: book.coverGradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 120, height: 160)
                    .overlay {
                        VStack {
                            Image(systemName: "book.closed")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                            Text(book.title)
                                .font(.caption2)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .lineLimit(3)
                                .padding(.horizontal, 8)
                        }
                    }
                    .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
                
                // Informations du livre avec hauteurs fixes
                VStack(alignment: .leading, spacing: 4) {
                    Text(book.title)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .frame(width: 120, height: 32, alignment: .topLeading) // Hauteur fixe pour 2 lignes
                    
                    Text(book.author)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .frame(width: 120, height: 16, alignment: .topLeading) // Hauteur fixe pour 1 ligne
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    StorySearchView()
}
