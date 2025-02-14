//
//  RecipeViewModelTests.swift
//  RecipesTests
//
//  Created by Yongjun Ou on 2/13/25.
//

import XCTest

@testable import Recipes

// Tests for RecipeViewModel functionality and network interactions
@MainActor
class RecipeViewModelTests: XCTestCase {
   var sut: RecipeViewModel! // System under test
   var session: URLSession! // Mock URL session for network requests
   
   @MainActor
   override func setUp() {
       super.setUp()
       
       // Configure mock URL session for controlled network testing
       let config = URLSessionConfiguration.ephemeral
       config.protocolClasses = [MockURLProtocol.self]
       session = URLSession(configuration: config)
       
       sut = RecipeViewModel(urlSession: session)
   }
   
   @MainActor
   override func tearDown() {
       // Clean up mock data and test objects between tests
       MockURLProtocol.mockData = nil
       MockURLProtocol.mockResponse = nil
       MockURLProtocol.mockError = nil
       sut = nil
       session = nil
       super.tearDown()
   }
   
   // Verifies successful recipe fetch and parsing
   func testFetchRecipes_Success() async throws {
       // Given
       let mockData = """
       {
           "recipes": [
               {
                   "name": "Test Recipe",
                   "cuisine": "Italian", 
                   "uuid": "123e4567-e89b-12d3-a456-426614174000"
               }
           ]
       }
       """.data(using: .utf8)!
       
       MockURLProtocol.mockData = mockData
       MockURLProtocol.mockResponse = HTTPURLResponse(
           url: URL(string: "https://test.com")!,
           statusCode: 200,
           httpVersion: nil,
           headerFields: nil
       )
       
       // When
       await sut.fetchRecipes()
       
       // Then
       XCTAssertEqual(sut.recipes.count, 1)
       XCTAssertEqual(sut.recipes.first?.name, "Test Recipe")
       XCTAssertNil(sut.error)
   }
   
   // Verifies error handling during recipe fetch
   func testFetchRecipes_Error() async {
       // Given
       MockURLProtocol.mockError = NSError(domain: "test", code: -1)
       
       // When
       await sut.fetchRecipes()
       
       // Then
       XCTAssertTrue(sut.recipes.isEmpty)
       XCTAssertNotNil(sut.error)
   }
   
   // Verifies handling of invalid JSON response
   func testFetchRecipes_InvalidJSON() async {
       // Given
       let invalidData = "invalid json".data(using: .utf8)!
       MockURLProtocol.mockData = invalidData
       MockURLProtocol.mockResponse = HTTPURLResponse(
           url: URL(string: "https://test.com")!,
           statusCode: 200,
           httpVersion: nil,
           headerFields: nil
       )
       
       // When
       await sut.fetchRecipes()
       
       // Then
       XCTAssertTrue(sut.recipes.isEmpty)
       XCTAssertNotNil(sut.error)
   }
   
   // Verifies fetch prevention during ongoing refresh
   func testRefresh_WhenAlreadyRefreshing_DoesNothing() async {
       // Given
       sut.isLoading = true
       let initialRecipes = sut.recipes
       
       // When
       await sut.fetchRecipes()
       
       // Then
       XCTAssertEqual(sut.recipes, initialRecipes)
   }
   
   // Verifies image loading from cache
   func testLoadImage_CacheHit() async {
       // Given
       let testImage = UIImage(systemName: "star.fill")!
       let testURL = URL(string: "https://test.com/image.jpg")!
       await ImageCacheManager.shared.store(testImage, for: testURL)
       
       // When
       let result = await sut.loadImage(for: testURL)
       
       // Then
       XCTAssertNotNil(result)
   }
   
   // Verifies image loading from network when not in cache
   func testLoadImage_CacheMiss_NetworkSuccess() async {
       // Given
       let testURL = URL(string: "https://test.com/image.jpg")!
       let testImage = UIImage(systemName: "star.fill")!
       let imageData = testImage.pngData()!
       
       MockURLProtocol.mockData = imageData
       MockURLProtocol.mockResponse = HTTPURLResponse(
           url: testURL,
           statusCode: 200,
           httpVersion: nil,
           headerFields: nil
       )
       
       // When
       let result = await sut.loadImage(for: testURL)
       
       // Then
       XCTAssertNotNil(result)
   }
}
