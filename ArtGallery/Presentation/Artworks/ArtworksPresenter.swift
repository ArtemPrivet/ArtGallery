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
                    self?.artworks.append(contentsOf: artworks)
                    self?.view?.updateArtworks()
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
    }

    private func getNextPage() -> Int {
        return artworks.count / limit + 1
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
