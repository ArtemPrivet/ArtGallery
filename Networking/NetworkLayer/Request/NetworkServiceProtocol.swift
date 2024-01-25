//
//  NetworkServiceProtocol.swift
//  ArtGallery
//
//  Created by Artem Orlov on 18.01.24.
//

import Domain

public typealias NetworkResult = Result<NetworkResponseData, NetworkError>

public protocol NetworkServiceProtocol: AnyObject {
    func request(_ url: String,
                 method: NetworkHTTPMethod,
                 parameters: [String: String],
                 completion: @escaping ((NetworkResult) -> Void))

}
