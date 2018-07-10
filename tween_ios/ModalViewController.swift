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
    
    var stringAddress: String = ""
    var tempDownloadURL: String = ""
    let mapView = MapViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressText.text = stringAddress
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeModal(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func sendKakao(_ sender: Any) {
        mapView.sendKakaoLink()
    }
    @IBAction func sendTween(_ sender: Any) {
        mapView.sendTweenCall()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
