//
//  LazyRecipeRowView.swift
//  Recipes
//
//  Created by Yongjun Ou on 2/12/25.
//

import SwiftUI

/// Row view for displaying recipe in a list with lazy loaded image
struct LazyRecipeRowView: View {
   /// Recipe to display
   let recipe: Recipe
   
   /// View model for image loading
   let viewModel: RecipeViewModel
   
   /// Thumbnail image for the recipe
   @State private var image: UIImage?
   
   var body: some View {
       HStack {
           // Thumbnail image section
           Group {
               if let image = image {
                   Image(uiImage: image)
                       .resizable()
                       .aspectRatio(contentMode: .fill)
               } else {
                   Image(systemName: "photo")
                       .foregroundColor(.gray)
               }
           }
           .frame(width: 60, height: 60)
           .background(Color.gray.opacity(0.2))
           .clipShape(RoundedRectangle(cornerRadius: 8))
           
           // Recipe details section
           VStack(alignment: .leading) {
               Text(recipe.name)
                   .font(.headline)
               if let cuisine = recipe.cuisine {
                   Text(cuisine)
                       .font(.subheadline)
                       .foregroundColor(.secondary)
               }
           }
       }
       .padding(.vertical, 4)
       // Load thumbnail image when row appears
       .onAppear {
           if let photoUrl = recipe.photoUrlSmall {
               Task {
                   image = await viewModel.loadImage(for: photoUrl)
               }
           }
       }
       // Unique identifier for view reuse
       .id(recipe.photoUrlSmall?.absoluteString ?? recipe.id.uuidString)
   }
}
