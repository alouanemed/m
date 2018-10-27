import Foundation
import Domain

public final class UseCaseProvider: Domain.UseCaseProvider {
    private let networkProvider: NetworkProvider

    public init() {
        networkProvider = NetworkProvider()
     }

    public func makeMoviesUseCase() -> Domain.MoviesUseCase {
        return MoviesUseCase(network: networkProvider.makeMoviesNetwork(),
                               cache: Cache<Movie>(path: "allMovies"))
    }
}
