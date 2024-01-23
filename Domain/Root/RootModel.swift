//
//  RootModel.swift
//  ArtGallery
//
//  Created by Artem Orlov on 19.01.24.
//

import Foundation

public struct RootModel<T: Decodable>: Decodable {
    public let data: T
}
