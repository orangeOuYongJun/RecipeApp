//
//  EmptyStateView.swift
//  Recipes
//
//  Created by Yongjun Ou on 2/13/25.
//

import SwiftUI

/// View displayed when no recipes are available
struct EmptyStateView: View {
   var body: some View {
       VStack(spacing: 16) {
           // Empty state icon
           Image(systemName: "fork.knife.circle")
               .font(.system(size: 50))
               .foregroundColor(.gray)
           
           // Primary message
           Text("No Recipes Available")
               .font(.headline)
           
           // Secondary message
           Text("Check back later for delicious recipes!")
               .font(.subheadline)
               .foregroundColor(.secondary)
               .multilineTextAlignment(.center)
       }
       .padding()
   }
}
