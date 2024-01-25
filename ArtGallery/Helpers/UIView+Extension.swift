//
//  UIView+Extension.swift
//  ArtGallery
//
//  Created by Artem Orlov on 25.01.24.
//

import UIKit

extension UIView {
    func wrap(horizontal: CGFloat) -> UIView {
        let wrap = UIView()
        wrap.addSubview(self)
        wrap.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: wrap.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: wrap.bottomAnchor).isActive = true
        self.leadingAnchor.constraint(equalTo: wrap.leadingAnchor, constant: horizontal).isActive = true
        self.trailingAnchor.constraint(equalTo: wrap.trailingAnchor, constant: -horizontal).isActive = true
        return wrap
    }
}
