//
//  StoryRepository.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 28/09/2025.
//

import Foundation

enum StoryRepositoryError: Error {
    case fetchAllStoriesFailed(Error)
    case fetchLatestStoriesFailed(Error)
    case fetchStoryByIdFailed(Error)
    case likeStoryFailed(Error)
    case searchStoriesFailed(Error)
}

class StoryRepository {
    let storiesDataSource = StoriesApiDataSource()
    
    func getAllStories() async throws -> [Story] {
        do {
            let storiesData = try await storiesDataSource.getAllStories()
            return storiesData.map(StoryMapper.map)
        } catch {
            print("❌ Error fetching all stories: \(error.localizedDescription)")
            throw StoryRepositoryError.fetchAllStoriesFailed(error)
        }
    }
    
    func getLatestStories() async throws -> [Story] {
        do {
            let storiesData = try await storiesDataSource.getLatestStories()
            return storiesData.map(StoryMapper.map)
        } catch {
            print("❌ Error fetching latest stories: \(error.localizedDescription)")
            throw StoryRepositoryError.fetchLatestStoriesFailed(error)
        }
    }
    
    func getStoryById(id: String) async throws -> Story {
        do {
            let storyData = try await storiesDataSource.getStoryById(id: id)
            return StoryMapper.map(storyDTO: storyData)
        } catch {
            print("❌ Error fetching story by id \(id): \(error.localizedDescription)")
            throw StoryRepositoryError.fetchStoryByIdFailed(error)
        }
    }
    
    func LikeStory(id: String) async throws {
        do {
            try await storiesDataSource.getStoryById(id: id)
        } catch {
            print("❌ Error liking story \(id): \(error.localizedDescription)")
            throw StoryRepositoryError.likeStoryFailed(error)
        }
    }
    
    func searchStories(query: String, userToken: String) async throws -> [Story] {
        do {
            let storiesData = try await storiesDataSource.searchSuggestions(payload: query, token: userToken)
            return storiesData.map(StoryMapper.map)
        } catch {
            print("❌ Error searching stories with query '\(query)': \(error.localizedDescription)")
            throw StoryRepositoryError.searchStoriesFailed(error)
        }
    }
}
