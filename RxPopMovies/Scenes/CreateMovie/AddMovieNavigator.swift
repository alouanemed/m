//
//  AddMovieNavigator.swift
//  RxPopMovies
//
//  Created by alouane on 10/23/18.
//  Copyright © 2018 alouanemed. All rights reserved.
//

import Foundation
import UIKit
import Domain

class AddMovieNavigator {
    func toMovies()
}

final class DefaultAddMovieNavigator: AddMovieNavigator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toMovies() {
        navigationController.dismiss(animated: true)
    }
}
