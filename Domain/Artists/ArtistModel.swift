//
//  ArtistModel.swift
//  ArtGallery
//
//  Created by Artem Orlov on 21.01.24.
//

import Foundation

public struct ArtistModel: Decodable {
    public let id: Int
    public let title: String
    public let birthDate: Int?
    public let deathDate: Int?
    public let description: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case birthDate = "birth_date"
        case deathDate = "death_date"
        case description
    }
}
