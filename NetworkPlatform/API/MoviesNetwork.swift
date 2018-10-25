//
//  MoviesNetwork.swift
//  NetworkPlatform
//
//  Created by alouane on 10/24/18.
//  Copyright © 2018 alouanemed. All rights reserved.
//

import Domain
import RxSwift

class MoviesNetwork {
    private let network: Network<Movie>
    
    init(network: Network<Movie>) {
        self.network = network
    }
    
    public func fetchMovies() -> Observable<[Movie]> {
        return network.getItems("discover/movie")
    }
    
    public func fetchMovie(movieId: String) -> Observable<Movie> {
        return network.getItem("movie", itemId: movieId)
    }
    
    
    public func createMovie(post: Movie)   {
        
    }
    
    public func deleteMovie(postId: String)  {
         
    }
}
