//
//  MainView.swift
//  AppleItunesCatalog
//
//  Created by SCOTT CROWDER on 4/29/24.
//

import SwiftUI

struct MainView: View {
    
    @State private var artistName: String = ""
    
    @State private var isShowingSearchResults: Bool = false
    
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
                    Text("Artist Lookup")
                        .font(.caption)
                    HStack{
                        TextField("Artist", text: $artistName)
                            .textFieldStyle(.roundedBorder)
                        Button {
                            isShowingSearchResults = true
                        } label: {
                            Image(systemName: "chevron.right.square")
                                .imageScale(.large)
                                .background(.black)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .sheet(isPresented: $isShowingSearchResults) {
                SearchResultsView()
                    .interactiveDismissDisabled()
            }
        }
    }
}

#Preview {
    MainView()
}
