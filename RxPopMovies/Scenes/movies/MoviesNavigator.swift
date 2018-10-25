//
//  MoviesNavigator.swift
//  RxPopMovies
//
//  Created by alouane on 10/23/18.
//  Copyright © 2018 alouanemed. All rights reserved.
//


import UIKit
import Domain

protocol MoviesNavigator {
    func toAddMovie()
    func toMovie(_ movie: Movie)
    func toMovies()
}

class DefaultMoviesNavigator: MoviesNavigator {
    private let storyBoard: UIStoryboard
    private let navigationController: UINavigationController
    private let services: UseCaseProvider
    
    init(services: UseCaseProvider,
         navigationController: UINavigationController,
         storyBoard: UIStoryboard) {
        self.services = services
        self.navigationController = navigationController
        self.storyBoard = storyBoard
    }
    
    func toMovies() {
        let vc = storyBoard.instantiateViewController(ofType: MoviesViewController.self)
        vc.viewModel = MoviesViewModel(useCase: services.makeMoviesUseCase(),
                                      navigator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toAddMovie() {
        let navigator = DefaultAddMovieNavigator(navigationController: navigationController)
        let viewModel = AddMovieViewModel(addMovieUseCase: services.makeMoviesUseCase(),
                                            navigator: navigator)
        let vc = storyBoard.instantiateViewController(ofType: AddMovieViewController.self)
        vc.viewModel = viewModel
        let nc = UINavigationController(rootViewController: vc)
        navigationController.present(nc, animated: true, completion: nil)
    }
    
    func toMovie(_ movie: Movie) {
        let navigator = DefaultEditMovieNavigator(navigationController: navigationController)
        let viewModel = EditMovieViewModel(movie: movie, useCase: services.makeMoviesUseCase(), navigator: navigator)
        let vc = storyBoard.instantiateViewController(ofType: EditMovieViewController.self)
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
}
