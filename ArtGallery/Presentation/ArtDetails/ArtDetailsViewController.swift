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
    private let presenter: ArtDetailsPresenterProtocol

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .equalSpacing

        return stack
    }()

    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        imageViewHeightConstraint = view.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 183.0 / 275.0)
        imageViewHeightConstraint?.isActive = true
        view.image = UIImage(named: "image_placeholder")
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

    init(presenter: ArtDetailsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        setupScrollView()
        setupStackView()
        presenter.viewDidLoad()
    }

    private func setupScrollView() {
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

        scrollView.alwaysBounceVertical = true
    }

    private func setupStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
}

extension ArtDetailsViewController: ArtDetailsViewProtocol {
    func update(artwork: ArtworkModel) {
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel.wrap(horizontal: 12))

        titleLabel.text = artwork.title

        if let imageID = artwork.imageID {
            let url = URL(string: "https://www.artic.edu/iiif/2/\(imageID)/full/843,/0/default.jpg")
            imageView.kf.setImage(with: url) { [weak self] result in
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
        stackView.addArrangedSubview(artistNameLabel.wrap(horizontal: 12))

        if let birthDate = artist.birthDate {
            artistLifeLabel.text = "\(birthDate) - \(artist.deathDate == nil ? "Nowadays" : "\(artist.deathDate!)")"
            stackView.addArrangedSubview(artistLifeLabel.wrap(horizontal: 12))
        }

        if let description = artist.description {
            if let artistDescription = description.htmlToAttributedString {
                let attributedText = NSMutableAttributedString(attributedString: artistDescription)
                attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 14), range: NSRange(location: 0, length: attributedText.length))
                artistDescriptionLabel.attributedText = attributedText

                stackView.addArrangedSubview(artistDescriptionLabel.wrap(horizontal: 12))
            }
        }
    }
}
