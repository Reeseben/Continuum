//
//  PhotoSelectorViewController.swift
//  Continuum
//
//  Created by Ben Erekson on 8/11/21.
//

import UIKit

protocol PhotoSelectorviewControllerDelegate: AnyObject {
    func photoSelectorViewControllerSelected(image: UIImage)
}

class PhotoSelectorViewController: UIViewController {
    @IBOutlet var postImage: UIImageView!
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        postImage.image = nil
    }
    
    //MARK: - Properties
    weak var delegate: PhotoSelectorviewControllerDelegate?
    
    //MARK: - Actions
    @IBAction func pickPhotoButtonTapped(_ sender: Any) {
        presentImagePickerActionSheet()
    }
    
    //MARK: - Helper Extensions
    func presentImagePickerActionSheet() {
        //Initialize Image Picker.
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        //Create an alert controler to check where the image is coming from.
        let alertController = UIAlertController(title: "Import image", message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Take a Photo", style: .default) { _ in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true)
        }
        let photoLibrary = UIAlertAction(title: "From Library", style: .default) { _ in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //Check if device has the options available and add them to the Alert Controller
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(camera)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alertController.addAction(photoLibrary)
        }
        //Add the cancle action no matter what.
        alertController.addAction(cancel)
        
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        //Present the alert Controller to the User
        self.present(alertController, animated: true)
        
    }

}

extension PhotoSelectorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            guard let delegate = delegate else { return }
            delegate.photoSelectorViewControllerSelected(image: image)
            postImage.image = image
        } else {
            print("Error getting selected image.")
        }
        self.dismiss(animated: true, completion: nil)
    }
}
