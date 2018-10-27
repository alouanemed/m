//
//  MovieEntity.swift
//  Domain
//
//  Created by alouane on 10/27/18.
//  Copyright © 2018 alouanemed. All rights reserved.
//
import Foundation

public struct MovieEntity: Codable {
    let page, totalResults, totalPages: Int
    let results: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}
