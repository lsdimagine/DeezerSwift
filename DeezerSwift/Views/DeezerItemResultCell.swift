//
//  SearchSingerCell.swift
//  DeezerSwift
//
//  Created by Shidong Lin on 8/20/19.
//  Copyright © 2019 Shidong Lin. All rights reserved.
//

import Foundation
import UIKit

class DeezerItemResultCell: UICollectionViewCell {
    private let artistLabel = UILabel()
    private let albumLabel = UILabel()
    private let albumImage = UIImageView()
    private var viewModel: DeezerItemResultCellModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray
        addSubview(artistLabel)
        addSubview(albumLabel)
        addSubview(albumImage)
        artistLabel.translatesAutoresizingMaskIntoConstraints = false
        albumLabel.translatesAutoresizingMaskIntoConstraints = false
        albumImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            artistLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            albumLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            artistLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
            albumLabel.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 10.0),
            albumImage.topAnchor.constraint(equalTo: albumLabel.bottomAnchor, constant: 10.0),
            artistLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),
            albumLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),
            albumImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            albumImage.widthAnchor.constraint(equalToConstant: 50.0),
            albumImage.heightAnchor.constraint(equalToConstant: 50.0),
            albumImage.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
        ])
    }

    func bind(_ viewModel: DeezerItemResultCellModel) {
        self.viewModel = viewModel
        artistLabel.text = viewModel.artistName
        artistLabel.sizeToFit()
        albumLabel.text = viewModel.albumTitle
        albumLabel.sizeToFit()
        if let albumCoverURL = URL(string: viewModel.albumCoverURL) {
            DispatchQueue.global(qos: .default).async {
                if let data = try? Data(contentsOf: albumCoverURL) {
                    DispatchQueue.main.async {
                        if albumCoverURL.absoluteString == self.viewModel?.albumCoverURL {
                            self.albumImage.image = UIImage(data: data)
                        }
                    }
                }
            }
        }
    }

    @available(*, unavailable, message: "Not implemented")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
