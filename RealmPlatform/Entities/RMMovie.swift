//
//  RMMovie.swift
//  RealmPlatform
//
//  Created by alouane on 10/27/18.
//  Copyright © 2018 alouanemed. All rights reserved.
//
import QueryKit
import Domain
import RealmSwift
import Realm

final class RMMovie: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var voteCount: Int = 0 
    @objc dynamic var voteAverage: Double = 0.0
    @objc dynamic var title: String = ""
    @objc dynamic var posterPath: String = ""
    @objc dynamic var overview: String = ""
    @objc dynamic var releaseDate: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension RMMovie {
    static var id: Attribute<Int> { return Attribute("id")}
    static var voteCount: Attribute<Int> { return Attribute("voteCount")}
    static var voteAverage: Attribute<Double> { return Attribute("voteAverage")}
    static var title: Attribute<String> { return Attribute("title")}
    static var posterPath: Attribute<String> { return Attribute("posterPath")}
    static var overview: Attribute<String> { return Attribute("overview")}
    static var releaseDate: Attribute<String> { return Attribute("releaseDate")}
}

extension RMMovie: DomainConvertibleType {
    func asDomain() -> Movie {
        return Movie(id: id, title: title, voteCount: voteCount, voteAverage: voteAverage, posterPath: posterPath, overview: overView, overview: releaseDate)
    }
}

extension Movie: RealmRepresentable {
    func asRealm() -> RMMovie {
        return RMMovie.build { object in
            object.id = id
            object.title = title
            object.voteCount = voteCount
            object.voteAverage = voteAverage
            object.posterPath = posterPath
            object.overview = overview
            object.releaseDate = releaseDate
        }
    }
}
