//
//  WishlistViewModel.swift
//  Comics
//
//  Created by Maria on 8/23/18.
//  Copyright © 2018 Maria Deygin. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import RxRealm

class WishlistViewModel:  ComicsViewModel {
    
    override func realmComics() -> Results<Comic> {
        let realm = try! Realm()
        return realm.objects(Comic.self).filter("wishlist == true")
    }
    
    func badge() -> Observable<Int> {
        return realmComicsObservable().map { $0.count }
    }
    
}
