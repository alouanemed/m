//
//  MoviesViewController.swift
//  RxPopMovies
//
//  Created by alouane on 10/23/18.
//  Copyright © 2018 alouanemed. All rights reserved.
//


import UIKit
import Domain
import RxSwift
import RxCocoa

class MoviesViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    var viewModel: MoviesViewModel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createMovieButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        bindViewModel()
    }
    
    private func configureTableView() {
        tableView.refreshControl = UIRefreshControl()
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func bindViewModel() {
        assert(viewModel != nil)
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()
        
        let input = MoviesViewModel.Input(trigger: Driver.merge(viewWillAppear, pull),
                                         createMovieTrigger: createMovieButton.rx.tap.asDriver(),
                                         selection: tableView.rx.itemSelected.asDriver())
        let output = viewModel.transform(input: input)
        //Bind Movies to UITableView
        output.Movies.drive(tableView.rx.items(cellIdentifier: MovieTableViewCell.reuseID, cellType: MovieTableViewCell.self)) { tv, viewModel, cell in
            cell.bind(viewModel)
            }.disposed(by: disposeBag)
        //Connect Create Movie to UI
        
        output.fetching
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
        output.createMovie
            .drive()
            .disposed(by: disposeBag)
        output.selectedMovie
            .drive()
            .disposed(by: disposeBag)
    }
}



