//
//  CreateBookViewController.swift
//  MobileApplication
//
//  Created by Сапбиєв Максим on 5/9/21.
//

import UIKit

class CreateBookViewController: UIViewController {
    
    @IBOutlet weak var bookTitleTextField: UITextField!
    @IBOutlet weak var bookSubtitleTextField: UITextField!
    @IBOutlet weak var bookPriceTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var onComplete: ((Book)->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0,
                                                   bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    @IBAction func saveBook(_ sender: Any) {
        do {
            let book = try composeBook()
            onComplete?(book)
            navigationController?.popViewController(animated: true)
        } catch {
            present(error)
        }
    }

    func composeBook() throws -> Book {
        guard let bookTitle = bookTitleTextField.text, !bookTitle.isEmpty else {
            throw BookValidationError.emptyFields(name: bookTitleTextField.placeholder ?? "")
        }
        guard let bookSubtitle = bookSubtitleTextField.text, !bookSubtitle.isEmpty else {
            throw BookValidationError.emptyFields(name: bookSubtitleTextField.placeholder ?? "")
        }
        guard let bookPrice = bookPriceTextField.text, !bookPrice.isEmpty else {
            throw BookValidationError.emptyFields(name: bookPriceTextField.placeholder ?? "")
        }

        guard let price = Double(bookPrice) else {
            throw BookValidationError.invalidYearFormat
        }
        guard 0.0...1000.0 ~= price else {
            throw BookValidationError.invalidYearFormat
        }
        
        return Book(title: bookTitle,
                    subtitle: bookSubtitle,
                    isbn13: "",
                    price: String(format: "%0.2f", price),
                    image: "")
    }

    enum BookValidationError: LocalizedError {
        case emptyFields(name: String)
        case invalidYearFormat
        case invalidYear
        
        var errorDescription: String? {
            switch self {
            case .emptyFields(let name):
                return "\(name.capitalized) is required input field."
            case .invalidYearFormat:
                return "Price input field must containt only decimal numbers."
            case .invalidYear:
                return "Price must be in 0.0 to 1000.0."
            }
        }
    }
}
