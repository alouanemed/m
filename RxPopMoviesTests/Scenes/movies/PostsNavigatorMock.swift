@testable import RxPopMovies
import Domain
import RxSwift

class MovieNavigatorMock: MoviesNavigator {

  var toMovies_Called = false

  func toMovies() {
    toMovies_Called = true
  }

  var toCreateMovie_Called = false

  func toCreateMovie() {
    toCreateMovie_Called = true
  }

  var toMovie_movie_Called = false
  var toMovie_movie_ReceivedArguments: Movie?

  func toMovie(_ movie: Movie) {
    toMovie_movie_Called = true
    toMovie_movie_ReceivedArguments = movie
  }
  
}
