//
//  AbstractComicsViewController.swift
//  Comics
//
//  Created by Maria on 8/24/18.
//  Copyright © 2018 Maria Deygin. All rights reserved.
//

import UIKit
import RxSwift

class AbstractComicsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var viewModel: ComicsViewModel!
    
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.tintColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        searchController.hidesNavigationBarDuringPresentation = false
        
        //this line is important to avoid uisearchviewcontroller incorrect behaviour that can cause a black screen
        self.definesPresentationContext = true
        
        let searchBar = searchController.searchBar
        
        searchBar.rx.cancelButtonClicked
            .map{""}
            .bind(to: viewModel.inputText)
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .map{ searchBar.text }
            .bind(to: viewModel.inputText)
            .disposed(by: disposeBag)
        
        searchBar.rx.value
            .filter{ _ in searchController.isActive }
            .distinctUntilChanged()
            .bind(to: viewModel.inputText).disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        
        viewModel.comics()
            .bind(to: tableView.rx.items(cellIdentifier: String(describing: ComicCell.self), cellType: ComicCell.self)) {
                [unowned self] (row, comic, cell) in
                
                cell.titleLabel.text = comic.title
                cell.descriptionLabel.text = comic.descript ?? "No description available"
                cell.starButton.tintColor = comic.wishlist ? #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1) : #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                cell.priceLabel.text = "$\(comic.price)"
                
                cell.starButton.rx.bind(to: self.viewModel.selectComicAction, input: comic)
                
                _ = cell.disposeBag.insert(
                    self.viewModel.image(for: comic).startWith(#imageLiteral(resourceName: "no_cover"))
                        .bind(to: cell.coverImageView.rx.image)
                )
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.asObservable()
            .bind { [unowned self] (indexPath) in
                self.tableView.deselectRow(at: indexPath, animated: true)
            }.disposed(by: disposeBag)
        
        tableView.tableFooterView = UIView()
        
        let identifier = String(describing: ComicCell.self)
        let nib = UINib(nibName: identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: identifier)
    }
}
