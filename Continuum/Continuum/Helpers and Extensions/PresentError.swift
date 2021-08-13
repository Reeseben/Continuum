//
//  PresentError.swift
//  Continuum
//
//  Created by Ben Erekson on 8/12/21.
//

import UIKit

extension UIViewController {
    func presentSimpleAlertWith(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        alert.addAction(doneAction)
        present(alert, animated: true, completion: nil)
    }
}
