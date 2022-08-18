//
//  GenericModels.swift
//  PixabaySearchDemo
//
//  Created by Matthew Magee on 18/08/2022.
//

import Foundation

struct GenericImage: Codable, Hashable {
    
    //thumbnail
    var thumbnailURL: String
    var thumbnailWidth: Int
    var thumbnailHeight: Int
    //full image
    var fullImageURL: String
    //community metadata
    var communityTags: String
    var communityViews: Int
    var communityDownloads: Int
    var communityComments: Int
    //image originator
    var imageOwnerName: String
    var imageOwnerAvatarURL: String

}
