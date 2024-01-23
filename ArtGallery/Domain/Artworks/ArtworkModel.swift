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

extension ArtworkModel {
    init(artworkDataModel: ArtworkDataModel) {
        self.id = Int(artworkDataModel.id)
        self.title = artworkDataModel.title ?? ""
        self.artistID = Int(artworkDataModel.artistID)
        self.imageID = artworkDataModel.imageID
        if let width = artworkDataModel.thumbnail?.width, let height = artworkDataModel.thumbnail?.height {
            self.thumbnail = ImageSizeModel(width: Int(width), height: Int(height))
        } else {
            self.thumbnail = nil
        }
    }
}
