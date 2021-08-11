//
//  AddPostTableViewController.swift
//  Continuum
//
//  Created by Ben Erekson on 8/10/21.
//

import UIKit

class AddPostTableViewController: UITableViewController {
    //MARK: - IBOutlets
    @IBOutlet var postImage: UIImageView!
    @IBOutlet var selectImagebutton: UIButton!
    @IBOutlet var captionTextField: UITextField!
    
    
    //MARK: - Lifecycles
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        postImage.image = #imageLiteral(resourceName: "spaceEmptyState")
        captionTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    @IBAction func selectPhotoButtonTapped(_ sender: Any) {
        
    }
    @IBAction func savePostButtonTapped(_ sender: Any) {
        guard let text = captionTextField.text, !text.isEmpty,
              let image = postImage.image else { return }
        PostController.shared.createPostWith(caption: text, image: image) { result in
            print("Hallo \(result)")
        }
        self.tabBarController?.selectedIndex = 0
    }
    @IBAction func cancleButtonTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
    

}
