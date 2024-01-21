//
//  ArtistsService.swift
//  ArtGallery
//
//  Created by Artem Orlov on 21.01.24.
//

import Foundation

final class ArtistsService: ArtistsServiceProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func loadArtist(id: Int, completion: @escaping (Result<ArtistModel, NetworkError>) -> Void) {
        networkService.request("https://api.artic.edu/api/v1/artists/\(id)",
                               method: .get,
                               parameters: nil) { result in
            switch result {
            case .success(let data):
                guard let jsonData = data.data else {
                    completion(.failure(.dataIsEmpty))
                    return
                }
                do {
                    let rootModel = try JSONDecoder().decode(RootModel<ArtistModel>.self, from: jsonData)
                    completion(.success(rootModel.data))
                } catch {
                    completion(.failure(.dataIsEmpty))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
