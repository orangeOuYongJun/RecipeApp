//
//  RecipeListView.swift
//  Recipes
//
//  Created by Yongjun Ou on 2/12/25.
//

import SwiftUI

/// Main view for displaying the list of recipes
struct RecipeListView: View {
   /// View model for managing recipe data and operations
   @StateObject private var viewModel = RecipeViewModel()
   
   var body: some View {
       NavigationView {
           Group {
               // Display loading state when no recipes are loaded
               if viewModel.isLoading && viewModel.recipes.isEmpty {
                   ProgressView()
               }
               // Display error view when fetch fails
               else if let error = viewModel.error {
                   ErrorView(error: error)
                       .refreshable {
                           await viewModel.fetchRecipes()
                       }
               }
               // Display empty state when no recipes available
               else if viewModel.recipes.isEmpty {
                   EmptyStateView()
                       .refreshable {
                           await viewModel.fetchRecipes()
                       }
               }
               // Display recipe list when data is available
               else {
                   List(viewModel.recipes) { recipe in
                       NavigationLink(destination: RecipeDetailView(recipe: recipe, viewModel: viewModel)) {
                           LazyRecipeRowView(recipe: recipe, viewModel: viewModel)
                       }
                   }
                   .refreshable {
                       await viewModel.fetchRecipes()
                   }
               }
           }
           .navigationTitle("Recipes")
       }
       // Initial fetch when view appears
       .task {
           await viewModel.fetchRecipes()
       }
   }
}

/// Preview provider for RecipeListView
#Preview {
   RecipeListView()
}
