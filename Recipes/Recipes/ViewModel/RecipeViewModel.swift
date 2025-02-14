//
//  RecipeViewModel.swift
//  Recipes
//
//  Created by Yongjun Ou on 2/12/25.
//

import Foundation
import UIKit

@MainActor
/// ViewModel responsible for managing recipe data and image loading
class RecipeViewModel: ObservableObject {
   /// Array of recipes fetched from the API
   @Published var recipes: [Recipe] = []
   
   /// Loading state indicator for fetch operations
   @Published var isLoading = false
   
   /// Error state from the latest operation
   @Published var error: Error?
   
   /// URLSession for handling network requests
   private let urlSession: URLSession
   
   /// Cache manager for storing and retrieving images
   private let imageCacheManager: ImageCacheManager
   
   /// Initialize with dependencies
   /// - Parameters:
   ///   - urlSession: URL session for network requests
   ///   - imageCacheManager: Cache manager for storing images
   init(
       urlSession: URLSession = .shared,
       imageCacheManager: ImageCacheManager = .shared
   ) {
       self.urlSession = urlSession
       self.imageCacheManager = imageCacheManager
   }
   
   /// Fetches recipe data from API endpoint
   /// Updates recipes array and error state on completion
   func fetchRecipes() async {
       guard !isLoading else { return }
       isLoading = true
       defer { isLoading = false }
       
       do {
           guard let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json") else {
               throw URLError(.badURL)
           }
           
           let (data, _) = try await urlSession.data(from: url)
           let response = try JSONDecoder().decode(RecipeResponse.self, from: data)
           recipes = response.recipes
           error = nil
       } catch {
           self.error = error
       }
   }
       
   /// Loads image from cache or network
   /// - Parameter url: target url for requesting the image
   /// - Returns: the result image loaded from cache or network, nil if failed
   func loadImage(for url: URL) async -> UIImage? {
       if let cached = await imageCacheManager.retrieve(for: url) {
           return cached
       }
       
       do {
           let (data, _) = try await urlSession.data(from: url)
           if let image = UIImage(data: data) {
               await imageCacheManager.store(image, for: url)
               return image
           }
       } catch {
           print("Error loading image: \(error)")
       }
       return nil
   }
   
   /// Clears all cached images
   func clearImageCache() async {
       await imageCacheManager.clearCache()
   }
}
