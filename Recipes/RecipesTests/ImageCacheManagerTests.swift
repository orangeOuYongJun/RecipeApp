//
//  ImageCacheManagerTests.swift
//  RecipesTests
//
//  Created by Yongjun Ou on 2/13/25.
//

import XCTest

@testable import Recipes

// Tests for ImageCacheManager's caching functionality
class ImageCacheManagerTests: XCTestCase {
   var sut: ImageCacheManager! // System under test
   
   override func setUp() {
       super.setUp()
       sut = ImageCacheManager.shared
   }
   
   override func tearDown() {
       // Clean cache between tests to ensure isolation
       Task {
           await sut.clearCache()
       }
       super.tearDown()
   }
   
   // Verifies storing and retrieving images from cache
   func testStoreAndRetrieveImage() async {
       // Given
       let testImage = UIImage(systemName: "star.fill")!
       let testURL = URL(string: "https://test.com/image.jpg")!
       
       // When
       await sut.store(testImage, for: testURL)
       let retrievedImage = await sut.retrieve(for: testURL)
       
       // Then
       XCTAssertNotNil(retrievedImage)
   }
   
   // Verifies cache clearing functionality
   func testClearCache() async {
       // Given
       let testImage = UIImage(systemName: "star.fill")!
       let testURL = URL(string: "https://test.com/image.jpg")!
       await sut.store(testImage, for: testURL)
       
       // When
       await sut.clearCache()
       let retrievedImage = await sut.retrieve(for: testURL)
       
       // Then
       XCTAssertNil(retrievedImage)
   }
}
