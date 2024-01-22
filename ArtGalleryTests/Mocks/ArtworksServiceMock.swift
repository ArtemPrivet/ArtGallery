//
//  ArtworksServiceMock.swift
//  ArtGalleryTests
//
//  Created by Artem Orlov on 22.01.24.
//

import XCTest
@testable import ArtGallery

final class ArtworksServiceMock: ArtworksServiceProtocol {
    private(set) var callCount = 0
    private(set) var page: Int?
    private(set) var limit: Int?
    var loadArtworksCompletion: (Result<[ArtGallery.ArtworkModel], ArtGallery.NetworkError>)!

    func loadArtworks(page: Int, limit: Int, completion: @escaping (Result<[ArtGallery.ArtworkModel], ArtGallery.NetworkError>) -> Void) {
        callCount += 1
        self.page = page
        self.limit = limit
        completion(loadArtworksCompletion)
    }
}
