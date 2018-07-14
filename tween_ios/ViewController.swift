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
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let container: UIView = UIView()
    let loadingView: UIView = UIView()
    
    var capturedImage: UIImage!
    var isTakenFromCamera = false
    var timestamp: Int = 0
    var downloadURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setLoadingStyle()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        MapViewController.downloadURL = downloadURL
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
        startLoading()
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
                self.stopLoading()
                self.performSegue(withIdentifier: "daumMapView", sender: self)
            })
            if error != nil {
                print("Storage Error!!: \(error)")
            }
        }
    }
    
    func setLoadingStyle() {
        // Apply loading screen style
        container.frame = self.view.frame
        container.center = self.view.center
        loadingView.frame = self.view.frame
        loadingView.center = self.view.center
        loadingView.backgroundColor = UIColor(white: 000, alpha: 0.4)
        loadingView.clipsToBounds = true
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
    }
    
    func startLoading() {
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        self.view.addSubview(container)
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        loadingView.removeFromSuperview()
        container.removeFromSuperview()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
