//
//  EditMovieViewModel.swift
//  RxPopMovies
//
//  Created by alouane on 10/23/18.
//  Copyright © 2018 alouanemed. All rights reserved.
//
import Domain
import RxSwift
import RxCocoa

class EditMovieViewModel: ViewModelType {
    private let movie: Movie
    private let useCase: MoviesUseCase
    private let navigator: EditMovieNavigator
    
    init(movie: Movie, useCase: MoviesUseCase, navigator: EditMovieNavigator) {
        self.movie = movie
        self.useCase = useCase
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()
        let editing = input.editTrigger.scan(false) { editing, _ in
            return !editing
            }.startWith(false)
        
        let saveTrigger = editing.skip(1) //we dont need initial state
            .filter { $0 == false }
            .mapToVoid()
        let titleAndDetails = Driver.combineLatest(input.title, input.details)
        let movie = Driver.combineLatest(Driver.just(self.movie), titleAndDetails) { (movie, titleAndDetails) -> Movie in
            return Movie(body: titleAndDetails.1, title: titleAndDetails.0, uid: movie.uid, userId: movie.userId, createdAt: movie.createdAt)
            }.startWith(self.movie)
        let editButtonTitle = editing.map { editing -> String in
            return editing == true ? "Save" : "Edit"
        }
        let saveMovie = saveTrigger.withLatestFrom(movie)
            .flatMapLatest { movie in
                return self.useCase.save(movie: movie)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
        }
        
        let deleteMovie = input.deleteTrigger.withLatestFrom(movie)
            .flatMapLatest { movie in
                return self.useCase.delete(movie: movie)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }.do(onNext: {
                self.navigator.toMovies()
            })
        
        return Output(editButtonTitle: editButtonTitle,
                      save: saveMovie,
                      delete: deleteMovie,
                      editing: editing,
                      movie: movie,
                      error: errorTracker.asDriver())
    }
}

extension EditMovieViewModel {
    struct Input {
        let editTrigger: Driver<Void>
        let deleteTrigger: Driver<Void>
        let title: Driver<String>
        let details: Driver<String>
    }
    
    struct Output {
        let editButtonTitle: Driver<String>
        let save: Driver<Void>
        let delete: Driver<Void>
        let editing: Driver<Bool>
        let movie: Driver<Movie>
        let error: Driver<Error>
    }
}
