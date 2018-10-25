import Foundation
import Domain
import RxSwift

final class MoviesUseCase<Cache>: Domain.MoviesUseCase where Cache: AbstractCache, Cache.T == Movie {
    private let network: MoviesNetwork
    private let cache: Cache

    init(network: MoviesNetwork, cache: Cache) {
        self.network = network
        self.cache = cache
    }

    func movies() -> Observable<[Movie]> {
        let fetchMovies = cache.fetchObjects().asObservable()
        let stored = network.fetchMovies()
            .flatMap {
                return self.cache.save(objects: $0)
                    .asObservable()
                    .map(to: [Movie].self)
                    .concat(Observable.just($0))
            }
        
        return fetchMovies.concat(stored)
    }
    
    func save(movie: Movie) -> Observable<Void> {
        return Observable.just(Void())
    }

    func delete(movie: Movie) -> Observable<Void> {
        return Observable.just(Void())
    }
}

struct MapFromNever: Error {}
extension ObservableType where E == Never {
    func map<T>(to: T.Type) -> Observable<T> {
        return self.flatMap { _ in
            return Observable<T>.error(MapFromNever())
        }
    }
}
