//
//  EditMovieNavigator.swift
//  RxPopMovies
//
//  Created by alouane on 10/23/18.
//  Copyright © 2018 alouanemed. All rights reserved.
//

import Foundation
import UIKit
import Domain

protocol EditMovieNavigator {
    func toMovies()
}

final class DefaultEditMovieNavigator: EditMovieNavigator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toMovies() {
        navigationController.popViewController(animated: true)
    }
}
