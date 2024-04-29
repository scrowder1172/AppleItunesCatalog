//
//  MainView.swift
//  AppleItunesCatalog
//
//  Created by SCOTT CROWDER on 4/29/24.
//

import SwiftUI

struct MainView: View {
    
    @State private var lookupTerm: String = ""
    
    @State private var isShowingSearchResults: Bool = false
    
    @State private var resultsData: [Results] = []
    
    let searchType: [String] = ["Album", "Artist", "Song"]
    @State private var selectedSearchType: String = ""
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [.white, .blue, .indigo], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                VStack(spacing: 0){
                    Text("iTunes Catalog Lookup")
                        .font(.system(size: 30, weight: .heavy))
                        .padding(.top, 20)
                        .foregroundStyle(.black)
                    
                    Rectangle()
                        .frame(height: 1)
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Lookup Term")
                        .font(.caption)
                    HStack{
                        TextField("Term", text: $lookupTerm)
                            .textFieldStyle(.roundedBorder)
                            .textContentType(.name)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.words)
                        Picker("", selection: $selectedSearchType) {
                            ForEach(searchType, id: \.self) { type in
                                Text(type)
                            }
                        }
                        .background(.black)
                        Button {
                            isShowingSearchResults = true
                        } label: {
                            Image(systemName: "chevron.right.square")
                                .imageScale(.large)
                                .background(lookupTerm.isEmpty ? .clear : .black)
                        }
                        .disabled(lookupTerm.isEmpty)
                    }
                }
                
                Spacer()
            }
            .padding()
            .sheet(isPresented: $isShowingSearchResults) {
                SearchResultsView(lookupTerm: lookupTerm, searchType: selectedSearchType)
                    .interactiveDismissDisabled()
            }
        }
    }
}

#Preview {
    MainView()
}
