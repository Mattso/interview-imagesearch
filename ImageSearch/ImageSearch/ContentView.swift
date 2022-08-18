//
//  ContentView.swift
//  PixabaySearchDemo
//
//  Created by Matthew Magee on 18/08/2022.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        //TODO: The NavigationView is fighting with internal constraints, bring peace
        NavigationView {
            PhotoSearchAndResultsView(viewModel: PhotoSearchAndResultsViewModel(networkService: PixabayImageSearchProvider(cacheProvider: GenericCacheProvider())))
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
