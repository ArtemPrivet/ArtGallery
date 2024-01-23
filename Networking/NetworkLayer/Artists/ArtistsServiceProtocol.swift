//
//  ArtistsServiceProtocol.swift
//  ArtGallery
//
//  Created by Artem Orlov on 21.01.24.
//

import Domain

public protocol ArtistsServiceProtocol: AnyObject {
    func loadArtist(id: Int, completion: @escaping (Result<ArtistModel, NetworkError>) -> Void)
}
