//
//  SearchResultsView.swift
//  AppleItunesCatalog
//
//  Created by SCOTT CROWDER on 4/29/24.
//

import os.log
import SwiftUI

struct SearchResultsView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let lookupTerm: String
    let searchType: String
    
    @State private var resultsData: [Results] = []
    @State private var filteredData: [Results] = []
    @State private var isSearchRunning: Bool = false
    
    var body: some View {
        NavigationStack{
            Group {
                if filteredData.isEmpty {
                    ContentUnavailableView {
                        Label("Data Not Found", systemImage: "cloud.bolt.rain.fill")
                    } description: {
                        Text("Please try another search")
                    } actions: {
                        Button("Search Again") {
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    List(filteredData) { result in
                        HStack{
                            AsyncImage(url: URL(string: result.artworkUrl60), scale: 1) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .scaledToFill()
                                } else if phase.error != nil {
                                    VStack {
                                        Image(systemName: "antenna.radiowaves.left.and.right.slash")
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
                                    Text("\(result.trackName)")
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
            .onAppear {
                isSearchRunning = true
                Task {
                    await getSongs()
                    isSearchRunning = false
                }
            }
            .overlay {
                if isSearchRunning {
                    ProgressView("Searching...")
                        .padding(40)
                        .background(.blue)
                        .foregroundStyle(.white)
                        .tint(.white)
                        .clipShape(.rect(cornerRadius: 25))
                }
            }
            .disabled(isSearchRunning)
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
        
        Logger.general.info("Gather Data | Start | Search term(s): \(lookupTerm)")
        
        let baseURL: String = "https://itunes.apple.com/search?entity=song&term="
        let artistLookup: String = lookupTerm.replacing(" ", with: "+")
        let lookupURL: String = baseURL + artistLookup
        
        guard let url = URL(string: lookupURL) else {
            Logger.networking.error("Gather Data | Error | URL invalid: \(lookupURL)")
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse else {
                Logger.networking.error("Gather Data | Error | HTTP response invalid. Check that correct protocol is referenced.")
                return
            }
            
            guard response.statusCode == 200 else {
                Logger.networking.error("Gather Data | Error | Response status code invalid (\(response.statusCode)")
                return
            }
            
            Logger.networking.info("Gather Data | Response Code | \(response.statusCode)")
            
            let decodedResponse = try JSONDecoder().decode(Response.self, from: data)
            resultsData = decodedResponse.results
            switch searchType {
            case "Artist":
                filteredData = resultsData.filter { $0.artistName.localizedStandardContains(lookupTerm)}.sorted{ $0.artistName < $1.artistName}
            case "Album":
                filteredData = resultsData.filter { $0.collectionName.localizedStandardContains(lookupTerm)}.sorted{ $0.collectionName < $1.collectionName}
            case "Song":
                filteredData = resultsData.filter { $0.trackName.localizedStandardContains(lookupTerm)}.sorted{ $0.trackName < $1.trackName}
            default:
                print("All")
            }
            Logger.general.info("Gather Data | Complete")
        } catch {
            Logger.networking.error("Gather Data | Error | An error occurred gathering the data: \(error.localizedDescription)")
        }
    }
}

#Preview {
    SearchResultsView(lookupTerm: "Katy Perry", searchType: "Artist")
}
