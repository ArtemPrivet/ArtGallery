//
//  ArtworkModel+Extension.swift
//  ArtGallery
//
//  Created by Artem Orlov on 23.01.24.
//

import Domain

extension ArtworkModel {
    init(artworkDataModel: ArtworkDataModel) {
        let thumbnail: ImageSizeModel?
        if let width = artworkDataModel.thumbnail?.width, let height = artworkDataModel.thumbnail?.height {
            thumbnail = ImageSizeModel(width: Int(width), height: Int(height))
        } else {
            thumbnail = nil
        }
        self.init(
            id: Int(artworkDataModel.id),
            title: artworkDataModel.title ?? "",
            artistID: Int(artworkDataModel.artistID),
            imageID: artworkDataModel.imageID,
            thumbnail: thumbnail
        )
    }
}
