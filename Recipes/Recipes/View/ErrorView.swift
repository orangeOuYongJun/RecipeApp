//
//  ErrorView.swift
//  Recipes
//
//  Created by Yongjun Ou on 2/12/25.
//

import SwiftUI

/// View for displaying error states with visual feedback
struct ErrorView: View {
   /// Error to display
   let error: Error
   
   var body: some View {
       VStack(spacing: 16) {
           // Error icon
           Image(systemName: "exclamationmark.triangle")
               .font(.system(size: 50))
               .foregroundColor(.red)
           
           // Error message
           Text("Error loading recipes")
               .font(.headline)
           
           // Error details
           Text(error.localizedDescription)
               .font(.subheadline)
               .foregroundColor(.secondary)
               .multilineTextAlignment(.center)
       }
       .padding()
   }
}
