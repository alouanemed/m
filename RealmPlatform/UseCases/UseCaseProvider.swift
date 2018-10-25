import Foundation
import Domain
import Realm
import RealmSwift

public final class UseCaseProvider: Domain.UseCaseProvider {
    private let configuration: Realm.Configuration

    public init(configuration: Realm.Configuration = Realm.Configuration()) {
        self.configuration = configuration
    }

    public func makeMoviesUseCase() -> Domain.MoviesUseCase {
        let repository = Repository<Movie>(configuration: configuration)
        return MoviesUseCase(repository: repository)
    }
}
