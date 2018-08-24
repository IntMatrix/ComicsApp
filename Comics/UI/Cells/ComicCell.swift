//
//  ComicCell.swift
//  Comics
//
//  Created by Maria on 8/23/18.
//  Copyright © 2018 Maria Deygin. All rights reserved.
//

import UIKit
import RxSwift

class ComicCell: UITableViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!
    
    private (set) open var disposeBag = CompositeDisposable()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag.dispose()
        disposeBag = CompositeDisposable()
    }
    
    deinit {
        disposeBag.dispose()
    }
}
