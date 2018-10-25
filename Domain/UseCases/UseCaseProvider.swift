import Foundation

public protocol UseCaseProvider {
    func makeMoviesUseCase() -> MoviesUseCase
}
