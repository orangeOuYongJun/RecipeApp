//
//  RecipeTests.swift
//  RecipesTests
//
//  Created by Yongjun Ou on 2/13/25.
//

import XCTest
@testable import Recipes

// Tests for Recipe model JSON decoding functionality
class RecipeTests: XCTestCase {
    // Verifies correct decoding of a complete recipe JSON with all fields present
    func testRecipeDecoding() throws {
        // Given
        let json = """
        {
            "name": "Test Recipe",
            "cuisine": "Italian",
            "uuid": "123e4567-e89b-12d3-a456-426614174000",
            "photo_url_large": "https://test.com/large.jpg",
            "photo_url_small": "https://test.com/small.jpg",
            "source_url": "https://test.com/recipe",
            "youtube_url": "https://youtube.com/watch"
        }
        """.data(using: .utf8)!
        
        // When
        let recipe = try JSONDecoder().decode(Recipe.self, from: json)
        
        // Then
        XCTAssertEqual(recipe.name, "Test Recipe")
        XCTAssertEqual(recipe.cuisine, "Italian")
        XCTAssertEqual(recipe.photoUrlLarge?.absoluteString, "https://test.com/large.jpg")
    }
    
    // Verifies decoding works with minimal required fields
    func testRecipeDecoding_OptionalFields() throws {
        // Given
        let json = """
        {
            "name": "Test Recipe",
            "uuid": "123e4567-e89b-12d3-a456-426614174000"
        }
        """.data(using: .utf8)!
        
        // When
        let recipe = try JSONDecoder().decode(Recipe.self, from: json)
        
        // Then
        XCTAssertEqual(recipe.name, "Test Recipe")
        XCTAssertNil(recipe.cuisine)
        XCTAssertNil(recipe.photoUrlLarge)
    }
    
    // Verifies handling of empty recipe lists in API responses
    func testRecipeResponse_EmptyList() throws {
        // Given
        let json = """
        {
            "recipes": []
        }
        """.data(using: .utf8)!
        
        // When
        let response = try JSONDecoder().decode(RecipeResponse.self, from: json)
        
        // Then
        XCTAssertTrue(response.recipes.isEmpty)
    }
}
