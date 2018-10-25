//
//  MoviesViewModel.swift
//  RxPopMovies
//
//  Created by alouane on 10/23/18.
//  Copyright © 2018 alouanemed. All rights reserved.
//

import Foundation
import Domain
import RxSwift
import RxCocoa

final class MoviesViewModel: ViewModelType {
    
    struct Input {
        let trigger: Driver<Void>
        let createMovieTrigger: Driver<Void>
        let selection: Driver<IndexPath>
    }
    struct Output {
        let fetching: Driver<Bool>
        let movies: Driver<[MovieItemViewModel]>
        let createMovie: Driver<Void>
        let selectedMovie: Driver<Movie>
        let error: Driver<Error>
    }
    
    private let useCase: MoviesUseCase
    private let navigator: MoviesNavigator
    
    init(useCase: MoviesUseCase, navigator: MoviesNavigator) {
        self.useCase = useCase
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        let movies = input.trigger.flatMapLatest {
            return self.useCase.movies()
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map { $0.map { MovieItemViewModel(with: $0) } }
        }
        
        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()
        let selectedMovie = input.selection
            .withLatestFrom(movies) { (indexPath, movies) -> Movie in
                return movies[indexPath.row].movie
            }
            .do(onNext: navigator.toMovie)
        let createMovie = input.createMovieTrigger
            .do(onNext: navigator.toCreateMovie)
        
        return Output(fetching: fetching,
                      movies: movies,
                      createMovie: createMovie,
                      selectedMovie: selectedMovie,
                      error: errors)
    }
}
