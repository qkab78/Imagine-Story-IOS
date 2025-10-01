//
//  StoryRepository.swift
//  Imagine Story
//
//  Created by Quentin Kabasele on 28/09/2025.
//

import Foundation

class StoryRepository {
    let storiesDataSource = StoriesApiDataSource()
    
    func getAllStories() async throws -> [Story] {
        do {
            let storiesData = try await storiesDataSource.getAllStories()
            return storiesData.map(StoryMapper.map)
        } catch {
            fatalError("Error fetching stories: \(error)")
        }
    }
    
    func getLatestStories() async throws -> [Story] {
        do {
            let storiesData = try await storiesDataSource.getLatestStories()
            return storiesData.map(StoryMapper.map)
        } catch {
            fatalError("Error fetching latest stories: \(error)")
        }
    }
    
    func getStoryById(id: String) async throws -> Story {
        do {
            let storyData = try await storiesDataSource.getStoryById(id: id)
            return StoryMapper.map(storyDTO: storyData)
        } catch {
            fatalError("Error fetching story by id: \(error)")
        }
    }
}
