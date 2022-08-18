//
//  PhotoSearchAndResultsViewModel.swift
//  PixabaySearchDemo
//
//  Created by Matthew Magee on 18/08/2022.
//

import Foundation

class PhotoSearchAndResultsViewModel: ObservableObject {
    
    var networkService: ImageSearchAPIContract
    
    @Published var searchResults: [GenericImage] = []
    
    @Published var lastSuccessfullySearchedTerm: String = ""
    
    @Published var errorMessage: String = ""
    
    init(networkService: ImageSearchAPIContract) {
        self.networkService = networkService
    }
    
    func performSearch(_ searchTerm: String) async -> Bool {
        
        self.errorMessage = ""
        
        let result = await networkService.searchFor(query: searchTerm, type: "photo")
        
        switch(result) {
        case .failure(_):
            self.errorMessage = "Oops! Something went wrong, please try again later."
            return false
        case .success(let searchResponse):
            
            DispatchQueue.main.async {
                self.searchResults = searchResponse
                self.lastSuccessfullySearchedTerm = searchTerm
            }
            
            return true
            
        }
        
    }
    
}
