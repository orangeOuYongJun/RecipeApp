//
//  Recipe.swift
//  Recipes
//
//  Created by Yongjun Ou on 2/12/25.
//

import Foundation

/// Response model containing array of recipes
struct RecipeResponse: Codable {
   /// List of recipes returned from API
   let recipes: [Recipe]
}

/// Model representing a recipe
struct Recipe: Codable, Identifiable, Equatable {
   /// Optional cuisine type (e.g. "Italian", "Chinese")
   let cuisine: String?
   
   /// Recipe name/title
   let name: String
   
   /// URL for high resolution recipe photo
   let photoUrlLarge: URL?
   
   /// URL for thumbnail recipe photo
   let photoUrlSmall: URL?
   
   /// Unique identifier for recipe
   let id: UUID
   
   /// URL to recipe instructions/source
   let sourceUrl: URL?
   
   /// URL to recipe video tutorial
   let youtubeUrl: URL?
   
   /// Maps JSON keys to Swift property names
   enum CodingKeys: String, CodingKey {
       case cuisine
       case name
       case photoUrlLarge = "photo_url_large"
       case photoUrlSmall = "photo_url_small"
       case id = "uuid"
       case sourceUrl = "source_url"
       case youtubeUrl = "youtube_url"
   }
   
   /// Custom equality implementation
   static func == (lhs: Recipe, rhs: Recipe) -> Bool {
       return lhs.id == rhs.id &&
              lhs.name == rhs.name &&
              lhs.cuisine == rhs.cuisine &&
              lhs.photoUrlLarge == rhs.photoUrlLarge &&
              lhs.photoUrlSmall == rhs.photoUrlSmall &&
              lhs.sourceUrl == rhs.sourceUrl &&
              lhs.youtubeUrl == rhs.youtubeUrl
   }
}
