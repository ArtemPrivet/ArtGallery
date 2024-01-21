//
//  RootModel.swift
//  ArtGallery
//
//  Created by Artem Orlov on 19.01.24.
//

import Foundation

struct RootModel<T: Decodable>: Decodable {
    let data: T
}
