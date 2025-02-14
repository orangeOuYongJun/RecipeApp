//
//  RecipeDetailView.swift
//  Recipes
//
//  Created by Yongjun Ou on 2/12/25.
//

import SwiftUI

/// Detailed view for displaying a single recipe
struct RecipeDetailView: View {
   /// Recipe to display
   let recipe: Recipe
   
   /// View model for image loading
   let viewModel: RecipeViewModel
   
   /// High resolution image for the recipe
   @State private var largeImage: UIImage?
   
   var body: some View {
       ScrollView {
           VStack(alignment: .leading, spacing: 16) {
               // Recipe image section
               Group {
                   if let image = largeImage {
                       Image(uiImage: image)
                           .resizable()
                           .aspectRatio(contentMode: .fill)
                   } else {
                       ProgressView()
                   }
               }
               .frame(maxWidth: .infinity)
               .frame(height: 300)
               .clipped()
               .background(Color.gray.opacity(0.2))
               .task {
                   // Load high-res image when view appears
                   if let photoUrl = recipe.photoUrlLarge {
                       largeImage = await viewModel.loadImage(for: photoUrl)
                   }
               }
               
               // Recipe details section
               VStack(alignment: .leading, spacing: 8) {
                   Text(recipe.name)
                       .font(.title)
                   if let cuisine = recipe.cuisine {
                       Text(cuisine)
                           .font(.headline)
                           .foregroundColor(.secondary)
                   }
                   
                   // External links section
                   HStack {
                       if let sourceUrl = recipe.sourceUrl {
                           Link(destination: sourceUrl) {
                               Label("View Recipe", systemImage: "link")
                           }
                       }
                       Spacer()
                       if let youtubeUrl = recipe.youtubeUrl {
                           Link(destination: youtubeUrl) {
                               Label("Watch Video", systemImage: "play.circle")
                           }
                       }
                   }
                   .padding(.top)
               }
               .padding()
           }
       }
       .navigationBarTitleDisplayMode(.inline)
   }
}
