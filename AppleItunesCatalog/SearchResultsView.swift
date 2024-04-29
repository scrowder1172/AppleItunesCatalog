//
//  SearchResultsView.swift
//  AppleItunesCatalog
//
//  Created by SCOTT CROWDER on 4/29/24.
//

import SwiftUI

struct SearchResultsView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack{
            VStack {
                Text("This will be the search results")
            }
            .navigationTitle("Search Results")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SearchResultsView()
}
