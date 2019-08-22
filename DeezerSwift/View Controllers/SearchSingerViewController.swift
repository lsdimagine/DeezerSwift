//
//  SearchSingerViewController.swift
//  DeezerSwift
//
//  Created by Shidong Lin on 8/19/19.
//  Copyright © 2019 Shidong Lin. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SearchSingerViewController: UIViewController, UISearchResultsUpdating, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private let layout = UICollectionViewFlowLayout()
    let searchController = UISearchController(searchResultsController: nil)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let reuseIdentifier = "AlbumCell"
    private var deezerItems: BehaviorRelay<[DeezerDataItem]> = BehaviorRelay(value: [])
    private let disposeBag = DisposeBag()

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        searchController.searchBar.placeholder = "Type singer name"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.register(DeezerItemResultCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.frame = view.bounds
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        layout.scrollDirection = .vertical

        deezerItems.asObservable()
        .subscribe({[weak self] _ in
            self?.collectionView.reloadData()
        })
        .disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.searchController = searchController
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.searchController = nil
    }

    // MARK: UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        _ = NetworkingManager.sharedManager.fetchAlbums(searchController.searchBar.text ?? "")
            .subscribe({ event in
                switch event {
                case .next(let items):
                    var uniqRes = [Int: DeezerDataItem]()
                    for item in items {
                        uniqRes[item.album.id] = item
                    }
                    var resArray = Array(uniqRes.values)
                    resArray.sort(by: {
                        $0.album.id < $1.album.id
                    })
                    self.deezerItems.accept(resArray)
                case .completed:
                    break
                case .error(_):
                    self.deezerItems.accept([])
                    break
                }
        })
    }

    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deezerItems.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = deezerItems.value[indexPath.row]
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

    // MARK: UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = deezerItems.value[indexPath.row]
        if searchController.isActive {
            searchController.dismiss(animated: true) { [weak self] in
                self?.navigationController?.pushViewController(AlbumDetailsViewController(item: item), animated: true)
            }
        } else {
            navigationController?.pushViewController(AlbumDetailsViewController(item: item), animated: true)
        }
    }
}

class CustomLayout: UICollectionViewLayout {
    var contentSize = CGSize(width: 0.0, height: 0.0)
}
