import Foundation
import Domain
import RxSwift
import Realm
import RealmSwift

final class MoviesUseCase<Repository>: Domain.MoviesUseCase where Repository: AbstractRepository, Repository.T == Movie {

    private let repository: Repository

    init(repository: Repository) {
        self.repository = repository
    }

    func movies() -> Observable<[Movie]> {
        return repository.queryAll()
    }
    
    func save(movie: Movie) -> Observable<Void> {
        return repository.save(entity: movie)
    }

    func delete(movie: Movie) -> Observable<Void> {
        return repository.delete(entity: movie)
    }
}
