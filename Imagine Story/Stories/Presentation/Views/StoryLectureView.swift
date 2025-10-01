//
//  StoryLectureView.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 01/10/2025.
//

import Foundation
import SwiftUI

struct StoryLectureView: View {
    @StateObject var viewModel = StoryReadViewModel()
    var storyId: String?
    
    public var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Chargement...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else if viewModel.story != nil {
                    ScrollView {
                        Text("Lisons ensemble : \(viewModel.story!.title)")
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
            await viewModel.loadStory(id: storyId ?? "1ed3df18-0bc3-4a08-aa6b-d5eb20e0dbc0")
        }
    }
}

#Preview {
    StoryLectureView()
}
