//
//  NetworkService.swift
//  Comics
//
//  Created by Maria on 8/23/18.
//  Copyright © 2018 Maria Deygin. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import RxRealm
import RealmSwift

class NetworkService {
    let provider = MoyaProvider<ComicsAPI>()
    let jsonDecoder = JSONDecoder()
    let disposeBag = DisposeBag()
    
    static let shared = NetworkService()
    
    private init() {
        let realm = try! Realm()
        let comics = realm.objects(Comic.self)
        if comics.count < 1 {
            loadComics()
        }
    }
    
    private func loadComics() {
        getComics().asObservable().take(1).map({ (comics) -> [Comic] in
            return comics.map{ Comic(from: $0) }
        }).subscribe(onNext: { (comics) in
            let realm = try! Realm()
            try! realm.write {
                realm.add(comics, update: true)
            }
        }).disposed(by: disposeBag)
    }
    
    private func getComics() -> Single<[ComicModel]> {
        return provider.rx.request(.getComics)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .filterSuccessfulStatusAndRedirectCodes()
            .map(ComicModel.Batch.self, using: jsonDecoder)
            .map{ $0.comics ?? [] }
    }

}
