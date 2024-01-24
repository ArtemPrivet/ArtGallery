//
//  ArtDetailsViewController.swift
//  ArtGallery
//
//  Created by Artem Orlov on 22.01.24.
//

import UIKit
import Domain

protocol ArtDetailsViewProtocol: AnyObject {
    func update(artwork: ArtworkModel)
    func update(artist: ArtistModel)
}

final class ArtDetailsViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    private var imageViewHeightConstraint: NSLayoutConstraint?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    private let artistLifeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    private let artistDescriptionLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        return view
    }()

    private func setupScrollView(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }

    func setupViews(){
        contentView.addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageViewHeightConstraint = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 183.0 / 275.0)
        imageViewHeightConstraint?.isActive = true

        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true

        contentView.addSubview(artistNameLabel)
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false

        artistNameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        artistNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true

        contentView.addSubview(artistLifeLabel)
        artistLifeLabel.translatesAutoresizingMaskIntoConstraints = false

        artistLifeLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 12).isActive = true
        artistLifeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        artistLifeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true

        contentView.addSubview(artistDescriptionLabel)
        artistDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        artistDescriptionLabel.topAnchor.constraint(equalTo: artistLifeLabel.bottomAnchor, constant: 12).isActive = true
        artistDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        artistDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        artistDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor).isActive = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupViews()
        presenter.viewDidLoad()
        self.view.backgroundColor = .white
        scrollView.alwaysBounceVertical = true
    }

    private let presenter: ArtDetailsPresenterProtocol

    init(presenter: ArtDetailsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ArtDetailsViewController: ArtDetailsViewProtocol {
    func update(artwork: ArtworkModel) {
        imageView.backgroundColor = .cyan
        titleLabel.text = artwork.title

        if let imageID = artwork.imageID {
            let url = URL(string: "https://www.artic.edu/iiif/2/\(imageID)/full/800,/0/default.jpg")
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "image_placeholder")) { [weak self] result in
                switch result {
                case .success:
                    if let thumbnail = artwork.thumbnail {
                        guard let imageView = self?.imageView else { return }
                        self?.imageViewHeightConstraint?.isActive = false
                        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: CGFloat(thumbnail.height) / CGFloat(thumbnail.width)).isActive = true
                        self?.view.layoutIfNeeded()
                    }
                case .failure: break
                }
            }
        }
    }

    func update(artist: ArtistModel) {
        artistNameLabel.text = artist.title
        artistNameLabel.isHidden = false

        if let birthDate = artist.birthDate {
            artistLifeLabel.text = "\(birthDate) - \(artist.deathDate == nil ? "Nowadays" : "\(artist.deathDate!)")"
            artistLifeLabel.isHidden = false
        }

        if let description = artist.description {
            if let artistDescription = description.htmlToAttributedString {
                let attributedText = NSMutableAttributedString(attributedString: artistDescription)
                attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 14), range: NSRange(location: 0, length: attributedText.length))
                artistDescriptionLabel.attributedText = attributedText

                artistDescriptionLabel.isHidden = false
            }
        }
    }
}
