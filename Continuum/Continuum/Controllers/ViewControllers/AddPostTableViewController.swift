//
//  AddPostTableViewController.swift
//  Continuum
//
//  Created by Ben Erekson on 8/10/21.
//

import UIKit

class AddPostTableViewController: UITableViewController {
    //MARK: - IBOutlets
    @IBOutlet var captionTextField: UITextField!
    
    
    //MARK: - Lifecycles
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        captionTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Properties
    var selectedImage: UIImage?
    
    //MARK: - Actions
    @IBAction func savePostButtonTapped(_ sender: Any) {
        guard let text = captionTextField.text, !text.isEmpty,
              let image = selectedImage else { return }
        PostController.shared.createPostWith(caption: text, image: image) { result in
            print("Hallo \(result)")
        }
        self.tabBarController?.selectedIndex = 0
    }
    @IBAction func cancleButtonTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "imagePicker" {
            guard let destination = segue.destination as? PhotoSelectorViewController else { return }
            destination.delegate = self
        }
    }

}

extension AddPostTableViewController: PhotoSelectorviewControllerDelegate {
    func photoSelectorViewControllerSelected(image: UIImage) {
        selectedImage = image
    }
}
