//
//  NetworkResponseData.swift
//  ArtGallery
//
//  Created by Artem Orlov on 18.01.24.
//

import Foundation

struct NetworkResponseData {
    let body: [AnyHashable: Any]?
    let data: Data?

    init(body: [AnyHashable : Any]? = nil, data: Data? = nil) {
        self.body = body
        self.data = data
    }
}
