//
//  ArtDetailsViewController.swift
//  ArtGallery
//
//  Created by Artem Orlov on 21.01.24.
//

import UIKit

protocol ArtDetailsViewProtocol: AnyObject {
    func update(artwork: ArtworkModel)
    func update(artist: ArtistModel)
}

final class ArtDetailsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artistLifeLabel: UILabel!
    @IBOutlet weak var artistDescriptionLabel: UILabel!
    
    private let presenter: ArtDetailsPresenterProtocol

    init(presenter: ArtDetailsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoad()
    }
}

extension ArtDetailsViewController: ArtDetailsViewProtocol {
    func update(artwork: ArtworkModel) {
        imageView.backgroundColor = .cyan
        titleLabel.text = artwork.title

        if let imageID = artwork.imageID {
            let url = URL(string: "https://www.artic.edu/iiif/2/\(imageID)/full/200,/0/default.jpg")
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "image_placeholder"))
        }

//        imageAspectRatioConstraint.constant = CGFloat(artwork.thumbnail.height) / CGFloat(artwork.thumbnail.width)
        if let thumbnail = artwork.thumbnail {
            imageViewHeightConstraint.isActive = false
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: CGFloat(thumbnail.height) / CGFloat(thumbnail.width)).isActive = true
            imageView.layoutIfNeeded()
        }

    }

    func update(artist: ArtistModel) {
        artistNameLabel.text = artist.title
        artistNameLabel.isHidden = false

        if let birthDate = artist.birthDate {
            artistLifeLabel.text = "\(birthDate) - \(artist.deathDate == nil ? "Nowadays" : "\(artist.birthDate!)")"
            artistLifeLabel.isHidden = false
        }

        if let description = artist.description {
            artistDescriptionLabel.attributedText = description.htmlToAttributedString
            artistDescriptionLabel.isHidden = false
        }
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
