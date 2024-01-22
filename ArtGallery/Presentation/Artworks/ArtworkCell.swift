//
//  ArtworkCell.swift
//  ArtGallery
//
//  Created by Artem Orlov on 19.01.24.
//

import UIKit
import Kingfisher

final class ArtworkCell: UICollectionViewCell {

    static let cellID = "ArtworkCell"

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var artNameLabel: UILabel!

    func update(with artwork: ArtworkModel) {
        artNameLabel.text = artwork.title

        // TODO: Load image
        imageView.image = UIImage(named: "image_placeholder")
        if let imageID = artwork.imageID {
            let url = URL(string: "https://www.artic.edu/iiif/2/\(imageID)/full/200,/0/default.jpg")
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "image_placeholder"))
        }
    }
}
