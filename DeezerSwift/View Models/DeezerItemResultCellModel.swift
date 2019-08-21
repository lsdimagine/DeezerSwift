//
//  DeezerItemResultCellModel.swift
//  DeezerSwift
//
//  Created by Shidong Lin on 8/20/19.
//  Copyright © 2019 Shidong Lin. All rights reserved.
//

import Foundation

struct DeezerItemResultCellModel {
    let model: DeezerDataItem

    var artistName: String {
        return model.artist.name
    }

    var albumTitle: String {
        return model.album.title
    }

    var albumCoverURL: String {
        return model.album.cover
    }
}
