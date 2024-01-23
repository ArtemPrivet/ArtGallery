//
//  NetworkResponseData.swift
//  ArtGallery
//
//  Created by Artem Orlov on 18.01.24.
//

import Foundation

public struct NetworkResponseData {
    let jsonData: [String: Any]?
    let data: Data?

    init(jsonData: [String : Any]? = nil, data: Data? = nil) {
        self.jsonData = jsonData
        self.data = data
    }
}
