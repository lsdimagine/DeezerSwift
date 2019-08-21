//
//  AlbumDetailsViewController.swift
//  DeezerSwift
//
//  Created by Shidong Lin on 8/21/19.
//  Copyright © 2019 Shidong Lin. All rights reserved.
//

import Foundation
import UIKit

class AlbumDetailsViewController: UIViewController {
    private let item: DeezerDataItem

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
    }
}
