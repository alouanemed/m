//
//  MovieEntity.swift
//  Domain
//
//  Created by alouane on 10/24/18.
//  Copyright © 2018 alouanemed. All rights reserved.
//


import Foundation


public struct Movie: Codable {
    public let voteCount, id: Int
    public let voteAverage: Double
    public let title: String
    public let posterPath: String
    public let overview, releaseDate: String
    
    enum CodingKeys: String, CodingKey {
        case voteCount = "vote_count"
        case id = "id"
        case voteAverage = "vote_average"
        case title = "title"
        case posterPath = "poster_path"
        case overview = "overview"
        case releaseDate = "release_date"
    }
    
    public init(id: Int, title:String, voteCount: Int, voteAverage: Double, posterPath: String, overview: String, releaseDate: String ){
        self.id = id
        self.title = title
        self.voteCount = voteCount
        self.voteAverage = voteAverage
        self.posterPath = posterPath
        self.overview = overview
        self.releaseDate = releaseDate
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        voteCount = try container.decode(Int.self, forKey: .voteCount)
        posterPath = try container.decode(String.self, forKey: .posterPath)
        voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        overview = try container.decode(String.self, forKey: .overview)
        releaseDate = try container.decode(String.self, forKey: .releaseDate)
     }
}

extension Movie: Equatable {
    public static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.title == rhs.title
    }
}
