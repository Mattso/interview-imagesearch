//
//  PhotoSearchAndResultsView.swift
//  PixabaySearchDemo
//
//  Created by Matthew Magee on 18/08/2022.
//

import SwiftUI

struct PhotoSearchAndResultsView: View {
    
    @ObservedObject var viewModel: PhotoSearchAndResultsViewModel
    
    @State var searchTerm: String = ""
    
    var body: some View {
        
        ScrollView() { //NOTE: A List() might be more performant here, but brings some UI baggage

            VStack() {
    
                //results header
                
                if viewModel.errorMessage != "" {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.gray)
                    Spacer(minLength: 20)
                }
                
                if viewModel.lastSuccessfullySearchedTerm != "" {
                    if viewModel.searchResults.count == 0 {
                        Text("Nothing found for \(viewModel.lastSuccessfullySearchedTerm) 😢")
                            .foregroundColor(.gray)
                    } else {
                        Text("Showing results for \(viewModel.lastSuccessfullySearchedTerm)")
                            .foregroundColor(.gray)
                    }
                }

                //searched images
                //(the LazyVGrid will take care of lazy loading and memory reclamation, so we don't need to worry too much about that)
                
                LazyVGrid(columns: [GridItem(),GridItem()]) {
                    
                    ForEach(viewModel.searchResults, id: \.self) { genericImage in
                        
                        NavigationLink(destination: PhotoDetailView(viewModel: genericImage)) {
                                        
                            //TODO: wrap AsyncImage with a cache implementation
                            AsyncImage(url: URL(string: genericImage.thumbnailURL)) { image in
                                image.resizable()
                            } placeholder: {
                                Circle()
                                    .fill(.gray)
                                    .frame(width: CGFloat(genericImage.thumbnailWidth), height: CGFloat(genericImage.thumbnailHeight))
                            }.aspectRatio(contentMode: .fit)
                        }

                    } //ForEach

                } //LazyVGrid
                .searchable(text: $searchTerm, prompt: "What are you looking for?")
                .onChange(of: searchTerm, perform: { latestSearchTerm in
                    //TODO: background searches on partial search terms, rate limited per 500 millis
                })
                .onSubmit(of: .search) {
                    Task(priority: .background) {
                        let success = await viewModel.performSearch(searchTerm)
                        if !success {
                            //TODO: pop a modal if there's a failure (right now there's just some error text above the results)
                        }
                    }
                }
                
                //give credit to the search provider
                
                if (viewModel.searchResults.count > 0) {
                    SearchAttributionView(logo: viewModel.networkService.searchProviderLogo(), link: viewModel.networkService.searchProviderAttributionLink())
                }
                
            } //VStack

        }//ScrollView
        .padding(12.0)
        .navigationTitle("Image Search")
        
    }
}

struct PhotoSearchAndResultsView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoSearchAndResultsView(viewModel: PhotoSearchAndResultsViewModel(networkService: PixabayImageSearchProvider(cacheProvider: GenericCacheProvider())))
    }
}
