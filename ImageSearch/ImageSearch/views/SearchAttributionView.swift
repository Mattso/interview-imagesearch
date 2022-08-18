//
//  SearchAttributionView.swift
//  PixabaySearchDemo
//
//  Created by Matthew Magee on 18/08/2022.
//

import SwiftUI

struct SearchAttributionView: View {
    
    var logo: String
    var link: URL
    
    var body: some View {
        Spacer(minLength: 40)
        Group {
            Text("Images provided by")
                .foregroundColor(.gray)
            Image(logo)
            Spacer(minLength: 40)
        }
        .onTapGesture {
            UIApplication.shared.open(link)
        }        
    }
}
