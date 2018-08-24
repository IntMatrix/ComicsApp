//
//  ComicsViewModel.swift
//  Comics
//
//  Created by Maria on 8/23/18.
//  Copyright © 2018 Maria Deygin. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Action
import RealmSwift
import RxRealm
import RxKingfisher
import Kingfisher

class ComicsViewModel: NSObject {
    
    var networkService = NetworkService.shared
    var inputText = BehaviorRelay<String?>(value: nil)
    
    @IBOutlet weak var viewController: UIViewController!
    
    func realmComicsObservable() -> Observable<Results<Comic>> {
        return Observable.collection(from: realmComics())
    }
    
    func comics() -> Observable<[Comic]> {
        
        return Observable.combineLatest(inputText, realmComicsObservable())
            .flatMap { (text, comics) -> Observable<[Comic]>  in
                if let text = text, !text.isEmpty {
                    let predicate = "title CONTAINS[c] '\(text)' OR descript CONTAINS[c] '\(text)'"
                    return Observable.array(from: comics.filter(predicate))
                } else {
                    return Observable.array(from: comics)
                }
            }
    }
    
    func realmComics() -> Results<Comic> {
        let realm = try! Realm()
        return realm.objects(Comic.self)
    }

    lazy var selectComicAction = Action<Comic, Void> { comic in
        
        let realm = try! Realm()
        try! realm.write {
            comic.wishlist = !comic.wishlist
        }
        
        return .empty()
    }
  
    func image(for comic: Comic) -> Observable<UIImage> {
        guard let imagePath = comic.thumbnail else { return  Observable.just(#imageLiteral(resourceName: "no_cover"))  }
        return KingfisherManager.shared.rx.retrieveImage(with: URL(string: imagePath)!).asObservable()
    }

}
