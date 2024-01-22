//
//  ArtworksPresenter.swift
//  ArtGallery
//
//  Created by Artem Orlov on 19.01.24.
//

import Foundation

protocol ArtworksPresenterProtocol: AnyObject {
    func didScroll(to item: Int)
    func didSelect(item: Int)

    var artworks: [ArtworkModel] { get }
}

final class ArtworksPresenter {

    private let networking: ArtworksServiceProtocol
    private let router: ArtworksRouterProtocol
    private let limit = 30

    weak var view: ArtworksViewProtocol?

    var artworks: [ArtworkModel] = []

    init(
        networking: ArtworksServiceProtocol,
        router: ArtworksRouterProtocol
    ) {
        self.networking = networking
        self.router = router
        loadArtworks()
    }

    private var isLoading = false

    func loadArtworks() {
        guard isLoading == false else { return }
        isLoading = true
        networking.loadArtworks(page: getNextPage(), limit: limit) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false

                switch result {
                case .success(let artworks):
                    guard let self = self else { return }
                    let uniqueArtworks = self.removeDuplicates(from: artworks)
                    self.artworks.append(contentsOf: uniqueArtworks)
                    self.view?.updateArtworks()
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
    }

    private func getNextPage() -> Int {
        return (artworks.count + limit - 1) / limit + 1
    }

    private func removeDuplicates(from newArtworks: [ArtworkModel]) -> [ArtworkModel] {
        var uniqueArtworks: [ArtworkModel] = []
        for artwork in newArtworks {
            if !artworks.contains(where: { $0.id == artwork.id }) {
                uniqueArtworks.append(artwork)
            }
        }
        print(uniqueArtworks.count)
        return uniqueArtworks
    }
}

extension ArtworksPresenter: ArtworksPresenterProtocol {
    func didScroll(to item: Int) {
        if item == artworks.count - limit / 2 {
                loadArtworks()
        }
    }

    func didSelect(item: Int) {
        router.didSelectArtwork(artworks[item])
    }
}
