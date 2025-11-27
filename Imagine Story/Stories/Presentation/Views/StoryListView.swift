//
//  StoryListView.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 28/09/2025.
//

import SwiftUI

struct StoryListView: View {
    @StateObject var viewModel = StoryListViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    LoadingView()
                } else if let errorMessage = viewModel.errorMessage {
                    ErrorView(errorMessage: errorMessage) {
                        Task {
                            await viewModel.retryLoadStories()
                        }
                    }
                } else {
                    ScrollView {
                        HeaderView(user: authViewModel.user ?? User.MOCK_USER)
                        HeroSectionView()
                        StoriesContainerView(stories: $viewModel.stories)
                    }
                    .ignoresSafeArea()
                    .background {
                        ViewLinearGradientBackground
                            .edgesIgnoringSafeArea(.all)
                    }
                }
            }
        }
        .task {
            await viewModel.loadStories()
        }
    }
}

#Preview {
    StoryListView()
        .environmentObject(StoryListViewModel())
        .environmentObject(AuthViewModel())
}
