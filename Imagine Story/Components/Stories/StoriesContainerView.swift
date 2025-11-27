//
//  StoriesContainerView.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 28/09/2025.
//

import SwiftUI

struct StoriesContainerView: View {
    @Binding var stories: [Story]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("✨ Histoires récentes")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(greenLinearGradientBackground)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            Text("Histoires que vous pourriez aimer lire.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach($stories, id: \.id) { story in
                        StoryCardView(story: story)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.top)
    }
}

#Preview {
    StoriesContainerView(stories: .constant([
        Story(
            id: "7b9892cf-c429-40b9-87fd-eb065b593243",
            title: "Histoire 1",
            synopsis: "Synopsis",
            coverImage: "",
            numberOfChapters: 3,
            theme: "1",
            themeName: "Aventure",
            themeDescription: "Une histoire pleine d'aventures",
            conclusion: "Conclusion de l'histoire",
            chapters: [],
            chapterImages: [],
            createdAt: Date().ISO8601Format(),
            isLiked: false,
            language: StoryLanguage(id: "1", code: "fr", name: "Français", isFree: true),
            tone: StoryTone(id: "1", name: "Épique", description: "")
        )
    ]))
}

