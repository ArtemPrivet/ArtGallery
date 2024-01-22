//
//  ArtworkModel.swift
//  ArtGallery
//
//  Created by Artem Orlov on 19.01.24.
//

import Foundation

struct ArtworkModel: Decodable, Hashable {
    let id: Int
    let title: String
    let artistID: Int?
    let imageID: String?
    let thumbnail: ImageSizeModel?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case artistID = "artist_id"
        case imageID = "image_id"
        case thumbnail
    }
}

struct ImageSizeModel: Decodable, Hashable {
    let width: Int
    let height: Int
}
