//
//  NetworkServiceProtocol.swift
//  ArtGallery
//
//  Created by Artem Orlov on 18.01.24.
//

import Foundation

typealias NetworkResult = Result<NetworkResponseData, NetworkError>

protocol NetworkServiceProtocol: AnyObject {
    func request(_ url: String,
                 method: NetworkHTTPMethod,
                 parameters: [String: Any]?,
                 completion: @escaping ((NetworkResult) -> Void))

}
