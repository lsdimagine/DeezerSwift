//
//  NetworkingManager.swift
//  DeezerSwift
//
//  Created by Shidong Lin on 8/20/19.
//  Copyright © 2019 Shidong Lin. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class NetworkingManager {
    static let sharedManager = NetworkingManager()
    private let disposeBag = DisposeBag()
    private let headers: HTTPHeaders = [
        "x-rapidapi-host": "deezerdevs-deezer.p.rapidapi.com",
        "x-rapidapi-key": "7adb122ed0mshf544829633f866fp1c34d1jsneb26207d800c"
    ]

    func fetchAlbums(_ singerName: String) -> Observable<[DeezerDataItem]> {
        return Observable.create({ observer in
            AF.request("https://deezerdevs-deezer.p.rapidapi.com/search", parameters: ["q": singerName], headers: self.headers).responseJSON { response in
                guard let data = response.data else {
                    return
                }
                switch response.result {
                case .success(_):
                    do {
                        let response = try JSONDecoder().decode(DeezerAlbumsResponse.self, from: data)
                        observer.onNext(response.data)
                    } catch(let error) {
                        observer.on(.error(error))
                    }
                    observer.on(.completed)
                    break
                case.failure(let error):
                    observer.on(.error(error))
                    break
                }
            }
            return Disposables.create()
        })
    }

    func fetchTracks(_ albumId: Int) -> Observable<[DeezerTrack]> {
        return Observable.create({ observer in
            AF.request("https://api.deezer.com/album/\(albumId)/tracks", headers: self.headers).responseJSON { response in
                guard let data = response.data else {
                    return
                }
                switch response.result {
                case .success(_):
                    do {
                        let response = try JSONDecoder().decode(DeezerTracksResponse.self, from: data)
                        observer.onNext(response.data)
                    } catch(let error) {
                        observer.on(.error(error))
                    }
                    observer.on(.completed)
                    break
                case.failure(let error):
                    observer.on(.error(error))
                    break
                }
            }
            return Disposables.create()
        })
    }
}
