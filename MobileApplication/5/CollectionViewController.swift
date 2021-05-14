//
//  CollectionViewController.swift
//  MobileApplication
//
//  Created by Сапбиєв Максим on 5/9/21.
//

import UIKit

class CollectionViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet private weak var collcetionView: UICollectionView!
    private let picker = UIImagePickerController()
    private var pictures: [UIImage] = [] {
        didSet {
            let previousCount = oldValue.count
            let currentCount = pictures.count
            let indexes = (previousCount...currentCount-1).map { IndexPath(row: $0, section: 0) }
            collcetionView.insertItems(at: indexes)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collcetionView.delegate = self
        collcetionView.dataSource = self
        picker.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                                 style: .done,
                                                                 target: self, action: #selector(showUpImagePicker))
    }

    @objc
    private func showUpImagePicker() {
        self.present(picker, animated: true, completion: nil)
    }

}
extension CollectionViewController: UICollectionViewDelegate {
    
}

extension CollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        cell.imageView.image = pictures[indexPath.row]
        return cell
    }

}

extension CollectionViewController: UIImagePickerControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let picture = info[.originalImage] as? UIImage else {
            dismiss(animated: true)
            return
        }

        dismiss(animated: true) {
            self.pictures.append(picture)
        }
    }

}
