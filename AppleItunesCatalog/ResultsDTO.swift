//
//  ResultsDTO.swift
//  AppleItunesCatalog
//
//  Created by SCOTT CROWDER on 4/29/24.
//

import Foundation

struct Response: Codable {
    var results: [Results]
}

struct Results: Codable, Identifiable {
    var trackId: Int
    var trackName: String
    var collectionName: String
    var artistName: String
    var artistViewUrl: String
    var collectionViewUrl: String
    var artworkUrl100: String
    var artworkUrl60: String
    var collectionExplicitness: String
    var trackExplicitness: String
    
    
    var id: Int { trackId }
}
