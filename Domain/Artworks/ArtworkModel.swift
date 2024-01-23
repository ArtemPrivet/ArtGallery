//
//  ArtworkModel.swift
//  ArtGallery
//
//  Created by Artem Orlov on 19.01.24.
//

import Foundation

public struct ArtworkModel: Decodable, Hashable {
    public let id: Int
    public let title: String
    public let artistID: Int?
    public let imageID: String?
    public let thumbnail: ImageSizeModel?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case artistID = "artist_id"
        case imageID = "image_id"
        case thumbnail
    }

    public init(id: Int, title: String, artistID: Int?, imageID: String?, thumbnail: ImageSizeModel?) {
        self.id = id
        self.title = title
        self.artistID = artistID
        self.imageID = imageID
        self.thumbnail = thumbnail
    }
}

public struct ImageSizeModel: Decodable, Hashable {
    public let width: Int
    public let height: Int

    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
}
