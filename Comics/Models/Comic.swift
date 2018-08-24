//
//  Comic.swift
//  Comics
//
//  Created by Maria on 8/23/18.
//  Copyright © 2018 Maria Deygin. All rights reserved.
//

import Foundation
import RealmSwift

class Comic: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String?
    @objc dynamic var descript: String?
    @objc dynamic var price: Double = 0
    @objc dynamic var thumbnail: String?
    @objc dynamic var wishlist: Bool = false
    
    convenience init(from comic: ComicModel) {
        self.init()
        
        id = comic.id
        title = comic.title
        descript = comic.description
        
        if let path = comic.thumbnail?.path,
            let type = comic.thumbnail?.type {
            thumbnail = path + "." + type
        }
        
        if let price = comic.prices?.first?.price {
            self.price = price
        }
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}
