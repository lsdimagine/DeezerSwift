//
//  AlbumDetailsViewController.swift
//  DeezerSwift
//
//  Created by Shidong Lin on 8/21/19.
//  Copyright © 2019 Shidong Lin. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class AlbumDetailsViewController: UIViewController {
    private let item: DeezerDataItem
    private var tracks: BehaviorRelay<[DeezerTrack]> = BehaviorRelay(value: [])
    private let coverImage = UIImageView()
    private let artistImage = UIImageView()
    private let headerView = UIView()
    private let disposeBag = DisposeBag()
    private let reuseIdentifier = "TracksCell"

    private let tableView = UITableView()

    init(item: DeezerDataItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable, message: "Not implemented")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = item.album.title

        coverImage.contentMode = .scaleAspectFit
        artistImage.contentMode = .scaleAspectFit
        headerView.addSubview(artistImage)
        headerView.addSubview(coverImage)
        view.addSubview(headerView)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TrackCellView.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.separatorStyle = .none
        view.addSubview(tableView)

        headerView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        coverImage.translatesAutoresizingMaskIntoConstraints = false
        artistImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 150.0),
            coverImage.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -10.0),
            coverImage.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10.0),
            coverImage.widthAnchor.constraint(equalToConstant: 100.0),
            coverImage.heightAnchor.constraint(equalToConstant: 100.0),
            artistImage.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10.0),
            artistImage.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10.0),
            artistImage.widthAnchor.constraint(equalToConstant: 100.0),
            artistImage.heightAnchor.constraint(equalToConstant: 100.0),
            tableView.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: 20.0),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        ImageLoadingManager.sharedManager.loadImage(item.album.cover) { image in
            DispatchQueue.main.async {
                self.coverImage.image = image
            }
        }

        ImageLoadingManager.sharedManager.loadImage(item.artist.picture) { image in
            DispatchQueue.main.async {
                self.artistImage.image = image
            }
        }

        NetworkingManager.sharedManager.fetchTracks(item.album.id)
        .subscribe(onNext: {
            self.tracks.accept($0)
        })
        .disposed(by: disposeBag)

        tracks.asObservable()
        .subscribe(onNext: { [weak self] _ in
            self?.tableView.reloadData()
        })
        .disposed(by: disposeBag)
    }
}

extension AlbumDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? TrackCellView {
            let viewModel = TrackCellViewModel(model: tracks.value[indexPath.row])
            cell.bind(viewModel)
            return cell
        }
        return TrackCellView()
    }
}

extension AlbumDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
