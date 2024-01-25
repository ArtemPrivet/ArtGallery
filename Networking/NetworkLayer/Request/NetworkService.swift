//
//  NetworkService.swift
//  ArtGallery
//
//  Created by Artem Orlov on 19.01.24.
//

import Domain

public final class NetworkService: NetworkServiceProtocol {

    private let session = URLSession.shared

    public static let shared: NetworkServiceProtocol = NetworkService()

    private init() {}

    public func request(_ url: String,
                 method: NetworkHTTPMethod,
                 parameters: [String : String],
                 completion: @escaping ((NetworkResult) -> Void)) {
        guard let url = URL(string: url) else {
            completion(.failure(.incorrectURL))
            return
        }

        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = parameters.map({ parameter in
            URLQueryItem(name: parameter.key, value: parameter.value)
        })
        guard let url = components?.url else {
            completion(.failure(.incorrectURL))
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue

        session.dataTask(with: urlRequest) { data, _, _ in
            guard let data = data else {
                completion(.failure(.incorrectURL))
                return
            }

            let jsonData = try? JSONSerialization.jsonObject(with: data) as? [String: Any]

            completion(.success(NetworkResponseData(jsonData: jsonData, data: data)))
        }.resume()
    }
}
