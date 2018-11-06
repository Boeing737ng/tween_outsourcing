//
//  ModalViewController.swift
//  tween_ios
//
//  Created by Kihyun Choi on 2018. 7. 10..
//  Copyright © 2018년 sfo. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {

    @IBOutlet var addressText: UILabel!
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let container: UIView = UIView()
    let loadingView: UIView = UIView()
    
    var stringAddress: String = ""
    var tempDownloadURL: String = ""
    let mapView = MapViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressText.text = stringAddress
        setLoadingStyle()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeModal(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func sendKakao(_ sender: Any) {
        startLoading()
        mapView.sendKakaoLink()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.stopLoading()
        }
    }
    @IBAction func sendTween(_ sender: Any) {
        mapView.sendTweenCall()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
