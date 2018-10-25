import Foundation
import RxSwift

public protocol MoviesUseCase {
    func movies() -> Observable<[Movie]>
    func save(movie: Movie) -> Observable<Void>
    func delete(movie: Movie) -> Observable<Void>
}
