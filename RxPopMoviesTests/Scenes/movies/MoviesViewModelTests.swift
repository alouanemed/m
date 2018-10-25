@testable import RxPopMovies
import Domain
import XCTest
import RxSwift
import RxCocoa
import RxBlocking

enum TestError: Error {
  case test
}

class MoviesViewModelTests: XCTestCase {

  var allMovieUseCase: AllMoviesUseCaseMock!
  var moviesNavigator: MovieNavigatorMock!
  var viewModel: MoviesViewModel!

  let disposeBag = DisposeBag()

  override func setUp() {
    super.setUp()

    allMovieUseCase = AllMoviesUseCaseMock()
    moviesNavigator = MovieNavigatorMock()

    viewModel = MoviesViewModel(useCase: allMovieUseCase,
                               navigator: moviesNavigator)
  }

  func test_transform_triggerInvoked_movieEmited() {
    // arrange
    let trigger = PublishSubject<Void>()
    let input = createInput(trigger: trigger)
    let output = viewModel.transform(input: input)

    // act
    output.movies.drive().disposed(by: disposeBag)
    trigger.onNext()

    // assert
    XCTAssert(allMovieUseCase.movies_Called)
  }


  func test_transform_sendMovie_trackFetching() {
    // arrange
    let trigger = PublishSubject<Void>()
    let output = viewModel.transform(input: createInput(trigger: trigger))
    let expectedFetching = [true, false]
    var actualFetching: [Bool] = []

    // act
    output.fetching
      .do(onNext: { actualFetching.append($0) },
          onSubscribe: { actualFetching.append(true) })
      .drive()
      .disposed(by: disposeBag)
    trigger.onNext()

    // assert
    XCTAssertEqual(actualFetching, expectedFetching)
  }

  func test_transform_movieEmitError_trackError() {
    // arrange
    let trigger = PublishSubject<Void>()
    let output = viewModel.transform(input: createInput(trigger: trigger))
    allMovieUseCase.movies_ReturnValue = Observable.error(TestError.test)

    // act
    output.movies.drive().disposed(by: disposeBag)
    output.error.drive().disposed(by: disposeBag)
    trigger.onNext()
    let error = try! output.error.toBlocking().first()

    // assert
    XCTAssertNotNil(error)
  }

  func test_transform_triggerInvoked_mapMoviesToViewModels() {
    // arrange
    let trigger = PublishSubject<Void>()
    let output = viewModel.transform(input: createInput(trigger: trigger))
    allMovieUseCase.movies_ReturnValue = Observable.just(createMovies())

    // act
    output.movies.drive().disposed(by: disposeBag)
    trigger.onNext()
    let movies = try! output.movies.toBlocking().first()!

    // assert
    XCTAssertEqual(movies.count, 2)
  }

  func test_transform_selectedMovieInvoked_navigateToMovie() {
    // arrange
    let select = PublishSubject<IndexPath>()
    let output = viewModel.transform(input: createInput(selection: select))
    let movies = createMovies()
    allMovieUseCase.movies_ReturnValue = Observable.just(movies)

    // act
    output.movies.drive().disposed(by: disposeBag)
    output.selectedMovie.drive().disposed(by: disposeBag)
    select.onNext(IndexPath(row: 1, section: 0))

    // assert
    XCTAssertTrue(moviesNavigator.toMovie_movie_Called)
    XCTAssertEqual(moviesNavigator.toMovie_movie_ReceivedArguments, movies[1])
  }

  func test_transform_createMovieInvoked_navigateToCreateMovie() {
    // arrange
    let create = PublishSubject<Void>()
    let output = viewModel.transform(input: createInput(createMovieTrigger: create))
    let movies = createMovies()
    allMovieUseCase.movies_ReturnValue = Observable.just(movies)

    // act
    output.movies.drive().disposed(by: disposeBag)
    output.createMovie.drive().disposed(by: disposeBag)
    create.onNext()

    // assert
    XCTAssertTrue(moviesNavigator.toCreateMovie_Called)
  }

  private func createInput(trigger: Observable<Void> = Observable.just(),
                           createMovieTrigger: Observable<Void> = Observable.never(),
                           selection: Observable<IndexPath> = Observable.never())
    -> MoviesViewModel.Input {
      return MoviesViewModel.Input(
        trigger: trigger.asDriverOnErrorJustComplete(),
        createMovieTrigger: createMovieTrigger.asDriverOnErrorJustComplete(),
        selection: selection.asDriverOnErrorJustComplete())
  }

  private func createMovies() -> [Movie] {
    return [
      Movie(body: "body 1", title: "title 1", uid: "uid 1", userId: "userId 1"),
      Movie(body: "body 2", title: "title 2", uid: "uid 2", userId: "userId 2")
    ]
  }
}
