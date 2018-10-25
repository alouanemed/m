//
//  MovieItemViewModel.swift
//  RxPopMovies
//
//  Created by alouane on 10/23/18.
//  Copyright © 2018 alouanemed. All rights reserved.
//


import Foundation
import Domain

class MovieItemViewModel  {
    let title:String
    let subtitle : String
    let post: Post
    init (with post:Post) {
        self.post = post
        self.title = post.title.uppercased()
        self.subtitle = post.body
    }
}

