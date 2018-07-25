//
//  SelectPictureViewController.swift
//  Snapchat
//
//  Created by Carlos Abreu on 6/30/18.
//  Copyright © 2018 Carlos Abreu. All rights reserved.
//

import UIKit
import FirebaseStorage

class SelectPictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var imagePicker : UIImagePickerController?
    var imageAdded = false
    var imageName = "\(NSUUID().uuidString).jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
    }
    
    @IBAction func selectPhotoTapped(_ sender: Any) {
        if imagePicker != nil {
            imagePicker!.sourceType = .photoLibrary
            present(imagePicker!, animated: true, completion: nil)
        }
    }
    @IBAction func cameraTapped(_ sender: Any) {
        if imagePicker != nil {
            imagePicker!.sourceType = .camera
            present(imagePicker!, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            imageAdded = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        
        // DELETE THIS FOR PRODUCTION
        //messageTextField.text = "test"
        //imageAdded = true
        
        if let message = messageTextField.text {
            if imageAdded && message != "" {
                // Upload the image
                
                let imagesFolder = FIRStorage.storage().reference().child("images")
                
                if let image = imageView.image {
                    if let imageData = UIImageJPEGRepresentation(image, 0.1) {
                        imagesFolder.child(imageName).put(imageData, metadata: nil, completion: { (metadata, error) in
                            if let error = error {
                                self.presentAlert(alert: error.localizedDescription)
                            } else {
                                // Segue to next view Controller
                                
                                if let downloadURL = metadata?.downloadURL()?.absoluteString {
                                    
                                    self.performSegue(withIdentifier: "selectReciverSegue", sender: downloadURL)
                                }
                            }
                        })
                    }
                    
                }
            } else {
                // We are missing something
                presentAlert(alert: "You must provide an image and a message for your snap.")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let downloadURL = sender as? String {
            if let selectVC = segue.destination as? SelectRecipientTableViewController {
                selectVC.downloadURL = downloadURL
                selectVC.snapDescription = messageTextField.text!
                selectVC.imageName = imageName
            }
        }
    }
    
    func presentAlert(alert:String) {
        let alertVC = UIAlertController(title: "Error", message: alert, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
}
