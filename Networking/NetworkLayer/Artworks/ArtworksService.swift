//
//  ArtworksService.swift
//  ArtGallery
//
//  Created by Artem Orlov on 19.01.24.
//

import Domain

public final class ArtworksService: ArtworksServiceProtocol {
    private let networkService: NetworkServiceProtocol

    public init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }

    public func loadArtworks(page: Int, limit: Int, completion: @escaping (Result<[ArtworkModel], NetworkError>) -> Void) {
        networkService.request("https://api.artic.edu/api/v1/artworks?page=\(page)&limit=\(limit)",
                               method: .get,
                               parameters: nil) { result in
            DispatchQueue.main.async {
            
                switch result {
                case .success(let data):
                    guard let jsonData = data.data else {
                        completion(.failure(.dataIsEmpty))
                        return
                    }
                    do {
                        let artworks = try JSONDecoder().decode(RootModel<[ArtworkModel]>.self, from: jsonData)
                        completion(.success(artworks.data))
                    } catch {
                        completion(.failure(.dataIsEmpty))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
