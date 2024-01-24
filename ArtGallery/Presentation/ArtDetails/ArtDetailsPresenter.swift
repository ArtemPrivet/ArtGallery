//
//  ArtDetailsPresenter.swift
//  ArtGallery
//
//  Created by Artem Orlov on 21.01.24.
//

import Domain

protocol ArtDetailsPresenterProtocol: AnyObject {
    func viewDidLoad()
}

final class ArtDetailsPresenter {

    private let artwork: ArtworkModel
    private let network: ArtistsServiceProtocol

    weak var view: ArtDetailsViewProtocol?

    init(artwork: ArtworkModel, network: ArtistsServiceProtocol) {
        self.artwork = artwork
        self.network = network
    }
}

extension ArtDetailsPresenter: ArtDetailsPresenterProtocol {
    func viewDidLoad() {
        view?.update(artwork: artwork)

        if let artistId = artwork.artistID {
            network.loadArtist(id: artistId) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let artist):
                        self?.view?.update(artist: artist)
                    case .failure(let failure):
                        print(failure)
                    }
                }
            }

        }
    }
}
