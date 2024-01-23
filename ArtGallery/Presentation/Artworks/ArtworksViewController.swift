//
//  ArtworksViewController.swift
//  ArtGallery
//
//  Created by Artem Orlov on 19.01.24.
//

import UIKit
import Domain

protocol ArtworksViewProtocol: AnyObject {
    func updateArtworks()
}

final class ArtworksViewController: UIViewController {
    private let presenter: ArtworksPresenter
    private var collectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()

    init(presenter: ArtworksPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Artworks"

        self.view.backgroundColor = .white
        createCollectionView()
        presenter.didLoadView()
    }

    private func createCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: self.view.frame.width / 2 - 20, height: (self.view.frame.width / 2 - 30))

        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)

        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.refreshControl = refreshControl

        collectionView.register(UINib(nibName: ArtworkCell.cellID, bundle: nil), forCellWithReuseIdentifier: ArtworkCell.cellID)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate(
            [
                collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ]
        )

        refreshControl.addTarget(self, action: #selector(refreshArtworks), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Loading new artworks...")

        display(presenter.artworks)
    }

    private lazy var dataSource: UICollectionViewDiffableDataSource<Int, ArtworkModel> = {
        UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtworkCell.cellID, for: indexPath) as? ArtworkCell
            cell?.update(with: itemIdentifier)
            return cell
        }
    }()

    private func display(_ items: [ArtworkModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ArtworkModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)

        dataSource.apply(snapshot)
    }

    @objc
    private func refreshArtworks() {
        presenter.refreshArtworks()
    }
}

extension ArtworksViewController: ArtworksViewProtocol {
    func updateArtworks() {
        display(presenter.artworks)
        refreshControl.endRefreshing()
    }
}

extension ArtworksViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter.didScroll(to: indexPath.item)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelect(item: indexPath.item)
    }
}
