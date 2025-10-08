//
//  Imagine_StoryApp.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 22/09/2025.
//

import SwiftUI

@main
struct Imagine_StoryApp: App {
    @StateObject var viewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
