//
//  notification.swift
//  tween_ios
//
//  Created by Kihyun Choi on 21/11/2018.
//  Copyright © 2018 sfo. All rights reserved.
//

import Foundation

class Notification: UIViewController {
    func sendNotification() {
        let url = NSURL(string: "https://fcm.googleapis.com/fcm/send")
        let postParams = ["to": "/topics/tween", "notification": ["body": "호출 내역을 확인하세요.", "title": "새로운 호출이 왔습니다."]] as [String : Any]
        var request = URLRequest(url: url! as URL)
        //let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        //        request.setValue("AAAAiO-yPhw:APA91bG5paCa4GXC9r7XJTpTisOyXxRmqzT0Ts_EH-E-CYTxKy7FutS8H6tdnUXFS8DOsquxm3bce9okcHSe3nqX9VwEXEMQospRnQXH3uxZa1IHNiYZqVrJ69dLNWhYifN_3JmbHNYu", forHTTPHeaderField: "Authorization")
        let strKey:String = "AIzaSyDK0p-hXOZTHi3oPXzVRNzprOsxNRvHWmU"
        request.setValue("key=\(strKey)", forHTTPHeaderField: "Authorization")
        do
        {
            request.httpBody = try JSONSerialization.data(withJSONObject: postParams, options: JSONSerialization.WritingOptions())
            print("My paramaters: \(postParams)")
        }
        catch
        {
            print("Caught an error: \(error)")
        }
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            if let realResponse = response as? HTTPURLResponse
            {
                if realResponse.statusCode != 200
                {
                    print("Not a 200 response")
                }
            }
            if let postString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as String?
            {
                print("POST: \(postString)")
            }
        }
        
        task.resume()
    }

}
