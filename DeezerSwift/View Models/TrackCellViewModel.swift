//
//  TrackCellViewModel.swift
//  DeezerSwift
//
//  Created by Shidong Lin on 8/21/19.
//  Copyright © 2019 Shidong Lin. All rights reserved.
//

import Foundation
import UIKit

struct TrackCellViewModel {
    let model: DeezerTrack

    var title: String {
        return model.title
    }

    var previewURLString: String {
        return model.preview
    }

    func tapPreview() {
        guard let url = URL(string: model.preview) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
