//
//  WishlistViewController.swift
//  Comics
//
//  Created by Maria on 8/24/18.
//  Copyright © 2018 Maria Deygin. All rights reserved.
//

class WishlistViewController: AbstractComicsViewController {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupBadge()
    }

    private func setupBadge() {
        if let wishListViewModel = viewModel as? WishlistViewModel {
            wishListViewModel.badge().subscribe(onNext: { (badge) in
                //setup badge for wishlist
                if let tabBarItem = self.tabBarController?.tabBar.items?[1] {
                    tabBarItem.badgeValue = badge > 0 ? "\(badge)" : nil
                }
            }).disposed(by: disposeBag)
        }
    }
}
