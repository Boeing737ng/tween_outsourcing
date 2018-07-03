//
//  RoundedBorder.swift
//  tween_ios
//
//  Created by Kihyun Choi on 2018. 7. 3..
//  Copyright © 2018년 sfo. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    // function is called when the connected object is created
    override func awakeFromNib() {
        super.awakeFromNib()
        let customColor = UIColor(red: 69.0/255.0, green: 117.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        // layer.borderWidth = 1 // border size will increase upon the devices
        layer.borderWidth = 2 / UIScreen.main.nativeScale // always keep the border 1px
        layer.borderColor = customColor.cgColor
    }
    
    // Whenever the button's height changes, this function is called
    override func layoutSubviews() {
        super.layoutSubviews()
        contentEdgeInsets = UIEdgeInsets(top:18, left:70, bottom:18, right:70)
        layer.cornerRadius = frame.height / 2
    }
}
