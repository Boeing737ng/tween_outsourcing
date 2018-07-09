//
//  User.swift
//  tween_ios
//
//  Created by Kihyun Choi on 2018. 7. 9..
//  Copyright © 2018년 sfo. All rights reserved.
//

class User {
    var date: String = ""
    var phone: String = ""
    var lat: Double = 0.0
    var lng: Double = 0.0
    var location: String = ""
    var photo: String = ""
    var daumURL: String = ""
    var googleURL: String = ""
    
    init(date:String, phone:String, lat:Double, lng:Double, location:String, photo:String) {
        self.date = date
        self.phone = phone
        self.lat = lat
        self.lng = lng
        self.location = location
        self.photo = photo
        self.daumURL = "http://m.map.daum.net/look?p=\(self.lat), \(self.lng)"
        self.googleURL = "https://www.google.co.kr/maps/place/\(self.lat), \(self.lng)"
    }
}
