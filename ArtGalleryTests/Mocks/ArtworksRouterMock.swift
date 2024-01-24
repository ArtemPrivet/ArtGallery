//
//  ArtworksRouterMock.swift
//  ArtGalleryTests
//
//  Created by Artem Orlov on 22.01.24.
//

import XCTest
import Domain
@testable import ArtGallery

final class ArtworksRouterMock: ArtworksRouterProtocol {
    var selectedModel: ArtworkModel?

    func didSelectArtwork(_ model: ArtworkModel) {
        selectedModel = model
    }
}
