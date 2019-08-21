//
//  SearchSingerViewController.swift
//  DeezerSwift
//
//  Created by Shidong Lin on 8/19/19.
//  Copyright © 2019 Shidong Lin. All rights reserved.
//

import Foundation
import UIKit

class SearchSingerViewController: UIViewController, UISearchResultsUpdating, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let layout = UICollectionViewFlowLayout()
    let searchController = UISearchController(searchResultsController: nil)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let reuseIdentifier = "AlbumCell"
    private var deezerItems = [DeezerDataItem]()

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        searchController.searchBar.placeholder = "Type singer name"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.register(DeezerItemResultCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.frame = view.bounds
        collectionView.backgroundColor = .white
//        collectionView.contentInsetAdjustmentBehavior = .always
//        layout.contentSize = view.frame.size
        view.addSubview(collectionView)
        layout.scrollDirection = .vertical
    }

    // MARK: UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        _ = NetworkingManager.sharedManager.fetchAlbums(searchController.searchBar.text ?? "")
            .subscribe({ event in
                switch event {
                case .next(let items):
                    self.deezerItems = items
                    self.collectionView.reloadData()
                case .completed:
                    break
                case .error(_):
                    self.deezerItems = []
                    self.collectionView.reloadData()
                    break
                }
        })
    }

    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deezerItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = deezerItems[indexPath.row]
        let viewModel = DeezerItemResultCellModel(model: item)

        if let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? DeezerItemResultCell {
            collectionViewCell.bind(viewModel)
            return collectionViewCell
        } else {
            let collectionViewCell = DeezerItemResultCell(frame: .zero)
            collectionViewCell.bind(viewModel)
            return collectionViewCell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150.0, height: 150.0)
    }
}

class CustomLayout: UICollectionViewLayout {
    var contentSize = CGSize(width: 0.0, height: 0.0)
}
