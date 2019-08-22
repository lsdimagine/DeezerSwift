//
//  TrackCellView.swift
//  DeezerSwift
//
//  Created by Shidong Lin on 8/21/19.
//  Copyright © 2019 Shidong Lin. All rights reserved.
//

import Foundation
import UIKit

class TrackCellView: UITableViewCell {
    private var viewModel: TrackCellViewModel?
    private let button = UIButton(type: .custom)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        button.setTitle("Preview", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(didTapPreview), for: .touchUpInside)
        addSubview(button)

        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.0),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    @available(*, unavailable, message: "Not implemented")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(_ viewModel: TrackCellViewModel?) {
        self.viewModel = viewModel
        textLabel?.text = viewModel?.title
    }

    @objc func didTapPreview(_ sender: UIButton) {
        viewModel?.tapPreview()
    }
}
