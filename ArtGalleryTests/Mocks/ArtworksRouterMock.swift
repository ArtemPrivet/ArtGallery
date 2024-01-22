//
//  ArtworksRouterMock.swift
//  ArtGalleryTests
//
//  Created by Artem Orlov on 22.01.24.
//

import XCTest
@testable import ArtGallery

final class ArtworksRouterMock: ArtworksRouterProtocol {
    var selectedModel: ArtGallery.ArtworkModel?

    func didSelectArtwork(_ model: ArtGallery.ArtworkModel) {
        selectedModel = model
    }
}
