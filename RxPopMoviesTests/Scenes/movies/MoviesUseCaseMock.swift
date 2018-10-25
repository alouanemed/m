@testable import RxPopMovies
import RxSwift
import Domain

class AllMoviesUseCaseMock: Domain.AllMoviesUseCase {

  var movies_ReturnValue: Observable<[Movie]> = Observable.just([])
  var movies_Called = false

  func movies() -> Observable<[Movie]> {
    movies_Called = true
    return movies_ReturnValue
  }
}
