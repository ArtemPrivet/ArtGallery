//
//  ArtworkCell.swift
//  ArtGallery
//
//  Created by Artem Orlov on 19.01.24.
//

import UIKit

final class ArtworkCell: UICollectionViewCell {

    static let cellID = "ArtworkCell"

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var artNameLabel: UILabel!

    func update(with artwork: ArtworkModel) {
        artNameLabel.text = artwork.title

        // TODO: Load image
        imageView.backgroundColor = .blue
    }
}
