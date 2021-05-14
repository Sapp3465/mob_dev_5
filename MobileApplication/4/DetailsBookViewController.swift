//
//  DetailsBookViewController.swift
//  MobileApplication
//
//  Created by Сапбиєв Максим on 5/9/21.
//

import UIKit

class DetailsBookViewController: UIViewController {

    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookSubtitle: UILabel!
    @IBOutlet weak var bookDescription: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var bookPublisher: UILabel!
    @IBOutlet weak var bookPages: UILabel!
    @IBOutlet weak var bookYear: UILabel!
    @IBOutlet weak var bookRating: UILabel!

    var book: BookDetail?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let book = book {
            installViews(with: book)
        }
    }
    
    private func installViews(with book: BookDetail) {
        if !book.image.isEmpty {
        bookImage.image = UIImage(named: book.image)
        }
        bookTitle.attributedText = label(with: "Title: ", content: book.title)
        bookSubtitle.attributedText = label(with: "Subtitle: ", content: book.subtitle)
        bookDescription.attributedText = label(with: "Description: ", content: book.desc)
        bookAuthor.attributedText = label(with: "Author: ", content: book.authors)
        bookPublisher.attributedText = label(with: "Publisher: ", content: book.publisher)
        bookPages.attributedText = label(with: "Pages: ", content: book.pages)
        bookYear.attributedText = label(with: "Year: ", content: book.year)
        bookRating.attributedText = label(with: "Rating: ", content: book.rating)
    }

    private func label(with title: String, content: String) -> NSMutableAttributedString {
        
        let firstString = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        let secondString = NSAttributedString(string: content, attributes: [:])

        firstString.append(secondString)

        return firstString
    }

}
