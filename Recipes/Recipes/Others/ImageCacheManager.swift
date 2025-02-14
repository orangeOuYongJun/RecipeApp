//
//  ImageCacheManager.swift
//  Recipes
//
//  Created by Yongjun Ou on 2/12/25.
//

import Foundation
import UIKit

/// Actor class for managing image caching in memory and on disk
actor ImageCacheManager {
   /// Shared singleton instance
   static let shared = ImageCacheManager()
   
   /// In-memory cache storage
   private let memoryCache = NSCache<NSURL, UIImage>()
   
   /// File system manager for disk operations
   private let fileManager = FileManager.default
   
   /// Directory URL for disk cache
   private var cacheDirectory: URL? {
       fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("ImageCache")
   }
   
   /// Creates cache directory if needed
   private init() {
       if let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("ImageCache") {
           if !fileManager.fileExists(atPath: cacheDirectory.path) {
               try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
           }
       }
   }
   
   /// Ensures cache directory exists
   private func createCacheDirectory() {
       guard let cacheDirectory else { return }
       if !fileManager.fileExists(atPath: cacheDirectory.path) {
           try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
       }
   }
   
   /// Generates unique file URL for caching image
   private func cacheFileURL(for url: URL) -> URL? {
       let filename = url.absoluteString.data(using: .utf8)?.base64EncodedString() ?? url.lastPathComponent
       return cacheDirectory?.appendingPathComponent(filename)
   }
   
   /// Stores image in memory and disk cache
   func store(_ image: UIImage, for url: URL) {
       memoryCache.setObject(image, forKey: url as NSURL)
       
       Task.detached(priority: .background) {
           guard let data = image.jpegData(compressionQuality: 0.8),
                 let fileURL = await self.cacheFileURL(for: url) else { return }
           try? data.write(to: fileURL)
       }
   }
   
   /// Retrieves image from cache, checking memory then disk
   func retrieve(for url: URL) -> UIImage? {
       if let cached = memoryCache.object(forKey: url as NSURL) {
           return cached
       }
       
       guard let fileURL = cacheFileURL(for: url),
             let data = try? Data(contentsOf: fileURL),
             let image = UIImage(data: data) else {
           return nil
       }
       
       memoryCache.setObject(image, forKey: url as NSURL)
       return image
   }
   
   /// Clears all cached images from memory and disk
   func clearCache() {
       memoryCache.removeAllObjects()
       guard let cacheDirectory else { return }
       try? fileManager.removeItem(at: cacheDirectory)
       createCacheDirectory()
   }
}
