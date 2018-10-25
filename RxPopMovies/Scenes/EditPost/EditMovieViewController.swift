import UIKit
import RxSwift
import RxCocoa
import Domain

final class EditMovieViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    
    var viewModel: EditMovieViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let deleteTrigger = deleteButton.rx.tap.flatMap {
            return Observable<Void>.create { observer in

                let alert = UIAlertController(title: "Delete Movie",
                    message: "Are you sure you want to delete this movie?",
                    preferredStyle: .alert
                )
                let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: { _ -> () in observer.onNext(()) })
                let noAction = UIAlertAction(title: "No", style: .cancel, handler: { _ -> () in observer.onNext(()) })
                alert.addAction(yesAction)
                alert.addAction(noAction)

                self.present(alert, animated: true, completion: nil)

                return Disposables.create()
            }
        }

        let input = EditMovieViewModel.Input(
            editTrigger: editButton.rx.tap.asDriver(),
            deleteTrigger: deleteTrigger.asDriverOnErrorJustComplete(),
            title: titleTextField.rx.text.orEmpty.asDriver(),
            details: detailsTextView.rx.text.orEmpty.asDriver()
        )

        let output = viewModel.transform(input: input)

        [output.editButtonTitle.drive(editButton.rx.title),
        output.editing.drive(titleTextField.rx.isEnabled),
        output.editing.drive(detailsTextView.rx.isEditable),
        output.movie.drive(movieBinding),
        output.save.drive(),
        output.error.drive(errorBinding),
        output.delete.drive()]
            .forEach({$0.disposed(by: disposeBag)})
    }

    var movieBinding: UIBindingObserver<EditMovieViewController, Movie> {
        return UIBindingObserver(UIElement: self, binding: { (vc, movie) in
            vc.titleTextField.text = movie.title
            vc.detailsTextView.text = movie.body
            vc.title = movie.title
        })
    }
    
    var errorBinding: UIBindingObserver<EditMovieViewController, Error> {
        return UIBindingObserver(UIElement: self, binding: { (vc, _) in
            let alert = UIAlertController(title: "Save Error",
                                          message: "Something went wrong",
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss",
                                       style: UIAlertAction.Style.cancel,
                                       handler: nil)
            alert.addAction(action)
            vc.present(alert, animated: true, completion: nil)
        })
    }
}



extension Reactive where Base: UITextView {
    var isEditable: UIBindingObserver<UITextView, Bool> {
        return UIBindingObserver(UIElement: self.base, binding: { (textView, isEditable) in
            textView.isEditable = isEditable
        })
    }
}
