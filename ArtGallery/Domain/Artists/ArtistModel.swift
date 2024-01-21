//
//  ArtistModel.swift
//  ArtGallery
//
//  Created by Artem Orlov on 21.01.24.
//

import Foundation

struct ArtistModel: Decodable {
    let id: Int
    let title: String
    let birthDate: Int?
    let deathDate: Int?
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case birthDate = "birth_date"
        case deathDate = "death_date"
        case description
    }
}
