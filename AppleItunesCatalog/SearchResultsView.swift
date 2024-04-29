//
//  SearchResultsView.swift
//  AppleItunesCatalog
//
//  Created by SCOTT CROWDER on 4/29/24.
//

import SwiftUI

struct SearchResultsView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var resultsData: [Results] = []
    
    let lookupTerm: String
    let searchType: String
    
    var body: some View {
        NavigationStack{
            Group {
                List {
                    ForEach(resultsData){ result in
                        if (searchType == "Artist" && result.artistName.localizedStandardContains(lookupTerm)) ||
                            (searchType == "Album" && result.collectionName.localizedStandardContains(lookupTerm)) ||
                            (searchType == "Song" && result.trackName.localizedStandardContains(lookupTerm)){
                            HStack{
                                AsyncImage(url: URL(string: result.artworkUrl60), scale: 1) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .scaledToFill()
                                    } else if phase.error != nil {
                                        VStack {
                                            Image(systemName: "iphone.slash.circle")
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                            Text("Album art not available")
                                        }
                                        .foregroundStyle(.red)
                                    } else {
                                        ProgressView()
                                    }
                                }
                                VStack(alignment: .leading) {
                                    HStack{
                                        Text("Song: \(result.trackName)")
                                            .font(.title3)
                                        if result.trackExplicitness == "explicit" {
                                            Text("EXPLICIT")
                                                .font(.system(size: 6))
                                                .padding(2)
                                                .foregroundStyle(.red)
                                                .border(.red)
                                        }
                                    }
                                    Text("Artist: \(result.artistName)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    HStack{
                                        Text("Album: \(result.collectionName)")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                        if result.collectionExplicitness == "explicit" {
                                            Text("EXPLICIT")
                                                .font(.system(size: 6))
                                                .padding(2)
                                                .foregroundStyle(.red)
                                                .border(.red)
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                }
            }
            .onAppear {
                Task {
                    await getSongs()
                }
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
    
    func getSongs() async {
        
        let baseURL: String = "https://itunes.apple.com/search?entity=song&term="
        let artistLookup: String = lookupTerm.replacing(" ", with: "+")
        let lookupURL: String = baseURL + artistLookup
        
        guard let url = URL(string: lookupURL) else {
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse else {
                return
            }
            
            print("Response code: \(response.statusCode)")
            
            let decodedResponse = try JSONDecoder().decode(Response.self, from: data)
            resultsData = decodedResponse.results
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    SearchResultsView(lookupTerm: "Pantera", searchType: "Artist")
}
