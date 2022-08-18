//
//  PhotoDetailView.swift
//  PixabaySearchDemo
//
//  Created by Matthew Magee on 18/08/2022.
//

import SwiftUI

struct PhotoDetailView: View {
    
    var viewModel: GenericImage
    
    var body: some View {
        
        GeometryReader() { geo in

            VStack() {
                
                Spacer()
                
                //the main image
                
                AsyncImage(url: URL(string: viewModel.fullImageURL)) { image in
                    image.resizable()
                } placeholder: {
                    Rectangle()
                        .fill(.gray)
                }
                .aspectRatio(contentMode: .fit)
                .scaledToFit()
                .frame(width: geo.size.width * 0.95)
                
                //the image owner and image metadata
                
                
                
                HStack() {
                    
                    Spacer()
                    
                    Image(systemName: "bubble.right")
                    Text("\(viewModel.communityComments)")
                        .foregroundColor(.gray)

                    Spacer()
                    
                    Image(systemName: "eye.circle")
                    Text("\(viewModel.communityViews)")
                        .foregroundColor(.gray)

                    Spacer()
                    
                    Image(systemName: "square.and.arrow.down")
                    Text("\(viewModel.communityDownloads)")
                        .foregroundColor(.gray)

                    Spacer()
                    
                }

                VStack() {
                    AsyncImage(url: URL(string: viewModel.imageOwnerAvatarURL)) { image in
                        image.resizable()
                    } placeholder: {
                        Circle()
                            .fill(.gray)
                    }
                    .frame(width: 96.0, height: 96.0, alignment: .leading)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    
                    Text(viewModel.imageOwnerName)
                }
                
                Spacer()
                
            }
        }.ignoresSafeArea()
        
    }
}

