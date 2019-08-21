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

    func fetchAlbums(_ singerName: String) -> Observable<[DeezerDataItem]> {
        let headers: HTTPHeaders = [
            "x-rapidapi-host": "deezerdevs-deezer.p.rapidapi.com",
            "x-rapidapi-key": "7adb122ed0mshf544829633f866fp1c34d1jsneb26207d800c"
        ]
        return Observable.create({ observer -> Disposable in
            AF.request("https://deezerdevs-deezer.p.rapidapi.com/search", parameters: ["q": singerName], headers: headers).responseJSON { response in
                guard let data = response.data else {
                    return
                }
                switch response.result {
                case .success(_):
                    do {
                        let response = try JSONDecoder().decode(DeezerResponse.self, from: data)
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
