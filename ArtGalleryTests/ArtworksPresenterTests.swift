//
//  ArtworksPresenterTests.swift
//  ArtGalleryTests
//
//  Created by Artem Orlov on 22.01.24.
//

import XCTest
import Domain
@testable import ArtGallery

final class ArtworksPresenterTests: XCTestCase {

    private var presenter: ArtworksPresenter!
    private var networking: ArtworksServiceMock!
    private var router: ArtworksRouterMock!
    private let limit = 10

    override func setUpWithError() throws {
        try super.setUpWithError()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.networking = ArtworksServiceMock()
        self.router = ArtworksRouterMock()
        self.presenter = ArtworksPresenter(networking: networking, router: router, limit: limit)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        presenter = nil
        networking = nil
        router = nil
    }

    func testSuccessLoadingArtworks() {
        networking.loadArtworksCompletion = .success(createDummyArtworks(from: 0, to: limit - 1))

        presenter.didLoadView()

        XCTAssertEqual(networking.callCount, 1)
        XCTAssertEqual(networking.page, 1)
        XCTAssertEqual(networking.limit, limit)
        XCTAssertEqual(presenter.artworks.count, limit)
    }

    func testDidScrollEvent() {
        networking.loadArtworksCompletion = .success(createDummyArtworks(from: 0, to: limit - 1))

        presenter.didLoadView()

        XCTAssertEqual(networking.callCount, 1)
        XCTAssertEqual(networking.page, 1)
        XCTAssertEqual(networking.limit, limit)
        XCTAssertEqual(presenter.artworks.count, limit)

        networking.loadArtworksCompletion = .success(createDummyArtworks(from: 11, to: 20))

        presenter.didScroll(to: 5)

        XCTAssertEqual(networking.callCount, 2)
        XCTAssertEqual(networking.page, 2)
        XCTAssertEqual(networking.limit, limit)
        XCTAssertEqual(presenter.artworks.count, 20)

        networking.loadArtworksCompletion = .success(createDummyArtworks(from: 21, to: 30))

        presenter.didScroll(to: 15)

        XCTAssertEqual(networking.callCount, 3)
        XCTAssertEqual(networking.page, 3)
        XCTAssertEqual(networking.limit, limit)
        XCTAssertEqual(presenter.artworks.count, 30)

        networking.loadArtworksCompletion = .success(createDummyArtworks(from: 31, to: 40))

        // shouldn't upload new elements
        presenter.didScroll(to: 20)

        XCTAssertEqual(networking.callCount, 3)
        XCTAssertEqual(networking.page, 3)
        XCTAssertEqual(networking.limit, limit)
        XCTAssertEqual(presenter.artworks.count, 30)
    }

    func testSuccessLoadingDuplicateArtworks() {
        networking.loadArtworksCompletion = .success(createDummyArtworks(from: 0, to: limit - 1))

        presenter.didLoadView()

        XCTAssertEqual(networking.callCount, 1)
        XCTAssertEqual(networking.page, 1)
        XCTAssertEqual(networking.limit, limit)
        XCTAssertEqual(presenter.artworks.count, limit)

        networking.loadArtworksCompletion = .success(createDummyArtworks(from: 0, to: limit - 1))
        presenter.didLoadView()

        XCTAssertEqual(networking.callCount, 2)
        XCTAssertEqual(networking.page, 2)
        XCTAssertEqual(networking.limit, limit)
        XCTAssertEqual(presenter.artworks.count, limit)
    }

    func testSelectItem() {
        networking.loadArtworksCompletion = .success(createDummyArtworks(from: 0, to: limit - 1))

        XCTAssertNil(router.selectedModel)

        presenter.didLoadView()
        presenter.didSelect(item: 3)

        XCTAssertEqual(router.selectedModel?.id, 3)
    }

    func testRefreshArtworks() {
        networking.loadArtworksCompletion = .success(createDummyArtworks(from: 0, to: limit - 1))

        presenter.refreshArtworks()

        XCTAssertEqual(networking.callCount, 1)
        XCTAssertEqual(networking.page, 1)
        XCTAssertEqual(networking.limit, limit)
        XCTAssertEqual(presenter.artworks.count, limit)
    }
}

extension ArtworksPresenterTests {
    private func createDummyArtworks(from: Int, to: Int) -> [ArtworkModel] {
        var models: [ArtworkModel] = []
        for i in from...to {
            models.append(ArtworkModel(id: i, title: "title\(i)", artistID: i, imageID: "imageID\(i)", thumbnail: nil))
        }
        return models
    }
}
