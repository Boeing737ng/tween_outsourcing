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
    
    
    @IBOutlet var contactModalImageView: UIImageView!
    @IBOutlet var galleryButton: UIStackView!
    @IBOutlet var cameraButton: UIStackView!
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let container: UIView = UIView()
    let loadingView: UIView = UIView()
    
    var capturedImage: UIImage!
    var isTakenFromCamera = false
    var timestamp: Int = 0
    var downloadURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
//            self.openContactModal()
//        })
        // Do any additional setup after loading the view, typically from a nib.
        self.enableTabAction()
        setLoadingStyle()
    }
    
    func enableTabAction() {
        let isOpenContactModal = UITapGestureRecognizer(target: self, action: #selector(ViewController.openContactModal))
        contactModalImageView.addGestureRecognizer(isOpenContactModal)
        contactModalImageView.isUserInteractionEnabled = true
        
        let isChooseFromGallery = UITapGestureRecognizer(target: self, action: #selector(ViewController.chooseFromGallery))
        galleryButton.addGestureRecognizer(isChooseFromGallery)
        galleryButton.isUserInteractionEnabled = true
        
        let isOpenCamera = UITapGestureRecognizer(target: self, action: #selector(ViewController.openCamera))
        cameraButton.addGestureRecognizer(isOpenCamera)
        cameraButton.isUserInteractionEnabled = true
    }

    @objc func openContactModal() {
        self.performSegue(withIdentifier: "contactModal", sender: self)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
//            self.dismiss(animated: true, completion: nil)
//        })
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        print("Image Selected")
        startLoading()
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        if mediaType.isEqual(to: kUTTypeImage as NSString as String) {
            if let capturedImage = info[.originalImage] as? UIImage,
                let imageData = capturedImage.jpegData(compressionQuality: 0.8) {
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
                print("Storage Error!!: \(error!)")
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
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
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
