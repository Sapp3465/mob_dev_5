//
//  ViewController.swift
//  MobileApplication
//
//  Created by Сапбиєв Максим on 5/9/21.
//

import UIKit

extension UIViewController {
    
    func present(_ error: Error) {
        let alertController = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Okay", style: .destructive, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }

}
