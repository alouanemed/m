//
//  AddMovieViewController.swift
//  RxPopMovies
//
//  Created by alouane on 10/23/18.
//  Copyright © 2018 alouanemed. All rights reserved.
//

import UIKit
import Domain
import RxSwift
import RxCocoa

final class AddMovieViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    var viewModel: AddMovieViewModel!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let input = AddMovieViewModel.Input(cancelTrigger: cancelButton.rx.tap.asDriver(),
                                              saveTrigger: saveButton.rx.tap.asDriver(),
                                              title: titleTextField.rx.text.orEmpty.asDriver(),
                                              details: detailsTextView.rx.text.orEmpty.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.dismiss.drive()
            .disposed(by: disposeBag)
        output.saveEnabled.drive(saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
