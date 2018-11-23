//
//  ConfirmModalViewController.swift
//  tween_ios
//
//  Created by Kihyun Choi on 23/11/2018.
//  Copyright © 2018 sfo. All rights reserved.
//

import UIKit

class ConfirmModalViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()        // Do any additional setup after loading the view.
    }
    @IBAction func moveToMainPage(_ sender: Any) {
        self.performSegue(withIdentifier: "segueToMain", sender: self)
    }
}
