//
//  ArtworksRouter.swift
//  ArtGallery
//
//  Created by Artem Orlov on 21.01.24.
//

import Foundation

protocol ArtworksRouterProtocol: AnyObject {
    func didSelectArtwork(_ model: ArtworkModel)
}

final class ArtworksRouter: ArtworksRouterProtocol {

    weak var view: ArtworksViewController?

    func didSelectArtwork(_ model: ArtworkModel) {

        let artDetailsPresenter = ArtDetailsPresenter(artwork: model, network: ArtistsService(networkService: NetworkService.shared))
        let artDetailsView = ArtDetailsViewController(presenter: artDetailsPresenter)
        artDetailsPresenter.view = artDetailsView

        view?.navigationController?.pushViewController(artDetailsView, animated: true)
    }
}
