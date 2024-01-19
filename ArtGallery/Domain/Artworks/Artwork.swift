//
//  Artwork.swift
//  ArtGallery
//
//  Created by Artem Orlov on 19.01.24.
//

import Foundation

struct Artwork: Decodable {
    let id: Int
    let title: String
    let artistTitle: String
    let imageID: String
}
