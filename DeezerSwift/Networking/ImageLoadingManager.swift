//
//  ImageLoadingManager.swift
//  DeezerSwift
//
//  Created by Shidong Lin on 8/21/19.
//  Copyright © 2019 Shidong Lin. All rights reserved.
//

import Foundation
import UIKit

class ImageLoadingManager {
    static let sharedManager = ImageLoadingManager()
    private let cache = NSCache<NSString, UIImage>()

    func loadImage(_ urlString: String, completion: ((UIImage) -> Void)? = nil) {
        if let image = cache.object(forKey: urlString as NSString) {
            completion?(image)
        } else if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                cache.setObject(image, forKey: urlString as NSString)
                completion?(image)
            }
        }
    }
}
