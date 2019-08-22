//
//  Response.swift
//  DeezerSwift
//
//  Created by Shidong Lin on 8/20/19.
//  Copyright © 2019 Shidong Lin. All rights reserved.
//

import Foundation

struct DeezerAlbumsResponse: Codable {
    var total: Int
    var next: String
    var data: [DeezerDataItem]

    enum CodingKeys: String, CodingKey {
        case total
        case next
        case data
    }
}

struct DeezerDataItem: Codable {
    var album: DeezerAlbum
    var artist: DeezerArtist
}

struct DeezerAlbum: Codable {
    var id: Int
    var title: String
    var cover: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case cover
    }
}

struct DeezerArtist: Codable {
    var id: Int
    var name: String
    var picture: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case picture
    }
}

struct DeezerTracksResponse: Codable {
    var data: [DeezerTrack]

    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct DeezerTrack: Codable {
    var id: Int
    var title: String
    var preview: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case preview
    }
}
