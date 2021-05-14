//
//  BookViewController.swift
//  MobileApplication
//
//  Created by Сапбиєв Максим on 5/9/21.
//

import UIKit

class BookViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    private var filteredBooks: [Book] = []
    private var allBooks: [Book] = []
    private var selectedIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
        decodeJSON()
    }

    private func decodeJSON() {
        do {
            allBooks = try Bundle.main.decode(Books.self, from: "BooksList.txt").list
            filteredBooks = allBooks
        } catch {
            navigationController?.present(error)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
        guard let searchText = searchBar.text,
              !searchText.isEmpty else {
            filteredBooks = allBooks.filter { _ in true }
            self.tableView.reloadData()
            return
        }
        
        let lSearchText = searchText.lowercased()
        
        filteredBooks = allBooks.filter({ (book) -> Bool in
            return book.title.lowercased().contains(lSearchText) || book.subtitle.lowercased().contains(lSearchText)
        })
        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
    }
    
    private func deleteBook(_ book: Book) {
        if let filteredIndex = filteredBooks.firstIndex(where: { $0.title == book.title }) {
            filteredBooks.remove(at: filteredIndex)
        }
        
        if let allIndex = allBooks.firstIndex(where: { $0.title == book.title }) {
            allBooks.remove(at: allIndex)
        }
    }
    
    private func addBook(_ book: Book) {
        allBooks.append(book)
    }

}

extension BookViewController {

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "DetailsBookViewControllerSegue" {

            guard let bookIndex = selectedIndexPath?.row,
                  let _ =  Bundle.main.url(forResource: "\(filteredBooks[bookIndex].isbn13).txt", withExtension: nil) else {
                return false
            }

        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let contoller = segue.destination as? DetailsBookViewController,
           let bookIndex = selectedIndexPath?.row,
           let bookDetail = try? Bundle.main.decode(BookDetail.self, from: "\(filteredBooks[bookIndex].isbn13).txt") {
            contoller.book = bookDetail
        } else if let contoller = segue.destination as? CreateBookViewController {
            contoller.onComplete = addBook
        } else {
            return
        }
    }

    
}

extension BookViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath) as! BookTableViewCell
        cell.set(filteredBooks[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let bookToDelete = filteredBooks[indexPath.row]
            deleteBook(bookToDelete)
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            return
        }
    }


}

extension BookViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedIndexPath = indexPath
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension BookViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            filteredBooks = allBooks.filter { _ in true }
            return
        }

        self.searchBar(searchBar, textDidChange: searchText)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        guard !searchText.isEmpty else {
            filteredBooks = allBooks.filter { _ in true }
            self.tableView.reloadData()
            return
        }
        let searchText = searchText.lowercased()
        filteredBooks = allBooks.filter({ (book) -> Bool in
            return book.title.lowercased().contains(searchText) || book.subtitle.lowercased().contains(searchText)
        })
        self.tableView.reloadData()
    }

}
