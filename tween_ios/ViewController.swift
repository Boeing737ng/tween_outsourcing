//
//  ViewController.swift
//  tween_ios
//
//  Created by Kihyun Choi on 2018. 7. 3..
//  Copyright © 2018년 sfo. All rights reserved.
//

import UIKit
import MobileCoreServices
import Firebase

class ViewController: UIViewController, UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    
    var capturedImage: UIImage!
    var isTakenFromCamera = false
    var timestamp: Int = 0
    var downloadURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mapView = segue.destination as! MapViewController
        mapView.timestamp = timestamp
        mapView.downloadURL = downloadURL
    }

    @IBAction func openCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            isTakenFromCamera = true
            let pickerController = UIImagePickerController()
            pickerController.delegate = self;
            pickerController.sourceType = .camera
            present(pickerController, animated: true, completion: nil)
        }
    }
    
    @IBAction func chooseFromGallery(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            isTakenFromCamera = false
            let pickerController = UIImagePickerController()
            pickerController.delegate = self;
            pickerController.sourceType = .photoLibrary
            present(pickerController, animated: true, completion: nil)
        }
    }
    // Called when image is taken by camera or is selected from device's gallery
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Image Selected")
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        if mediaType.isEqual(to: kUTTypeImage as NSString as String) {
            if let capturedImage = info[UIImagePickerControllerOriginalImage] as? UIImage,
                let imageData = UIImageJPEGRepresentation(capturedImage, 0.8) {
                uploadToFirebaseStorage(data: imageData)
            }
//            // Saves the taken picture to photo album
//            if isTakenFromCamera {
//                UIImageWriteToSavedPhotosAlbum(capturedImage, self, nil, nil)
//            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func uploadToFirebaseStorage(data: Data) {
        timestamp = Int((Date().timeIntervalSince1970 * 1000).rounded())
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let mountainRef = storageRef.child("\(timestamp).jpg")
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        mountainRef.putData(data, metadata: uploadMetadata) { (metadata, error) in
            mountainRef.downloadURL(completion: { (url, urlError) in
                self.downloadURL = "\(url!)"
                // Open Daum map view storyboard
                self.performSegue(withIdentifier: "daumMapView", sender: self)
            })
            if error != nil {
                print("error")
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
