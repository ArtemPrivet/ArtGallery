//
//  ArtworksServiceProtocol.swift
//  ArtGallery
//
//  Created by Artem Orlov on 19.01.24.
//

import Foundation

protocol ArtworksServiceProtocol: AnyObject {
    func loadArtworks(page: Int, limit: Int, completion: @escaping (Result<[ArtworkModel], NetworkError>) -> Void)
}
