//
//  MapViewController.swift
//  tween_ios
//
//  Created by Kihyun Choi on 2018. 7. 5..
//  Copyright © 2018년 sfo. All rights reserved.
//

import UIKit
import CoreLocation

class MapViewController: UIViewController,MTMapViewDelegate,MTMapReverseGeoCoderDelegate {
    
    lazy var mapView: MTMapView = MTMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
    var fullStringAddress: String = ""
    var tempFullStringAddress: String = ""
    var latitude = 0.0
    var longitude = 0.0
    var timestamp: Int = 0
    var downloadURL: String = ""

    @IBOutlet var mapButtonView: UIView!
    @IBOutlet var locationText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openDaumMap()
        addButtonContainerStyle()
    }
    // Create and display Daum map
    func openDaumMap() {
        mapView.delegate = self
        mapView.baseMapType = .standard
        mapView.showCurrentLocationMarker = true
        mapView.currentLocationTrackingMode = .onWithoutHeading
        self.view.insertSubview(mapView, at: 0)
    }
    // Apply the style of button container on the map
    func addButtonContainerStyle() {
        mapButtonView.layer.cornerRadius = 7
        mapButtonView.layer.shadowColor = UIColor.gray.cgColor
        mapButtonView.layer.shadowOpacity = 1
        mapButtonView.layer.shadowOffset = CGSize.zero
        mapButtonView.layer.shadowRadius = 7
    }
    // Gets the actual string address by coordinate of center point
    func getStringAddress(){
       
        let centerLatitude = mapView.mapCenterPoint.mapPointGeo().latitude
        let centerLongitude = mapView.mapCenterPoint.mapPointGeo().longitude
        let findLocation = CLLocation(latitude: centerLatitude, longitude: centerLongitude)
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        geocoder.reverseGeocodeLocation(findLocation, preferredLocale: locale, completionHandler: {(placemarks, error) in
            if let city = placemarks?[0].administrativeArea {
                self.tempFullStringAddress.append(city + " ")
            } else {
                print("Could not find city")
            }
            if let borough = placemarks?[0].locality {
                if borough != "세종특별자치시" {
                    self.tempFullStringAddress.append(borough + " ")
                }
            } else {
                print("Could not find borough")
            }
            if let dong = placemarks?[0].thoroughfare {
                self.tempFullStringAddress.append(dong + " ")
            } else {
                print("Could not find dong")
            }
            if let areaNumber = placemarks?[0].subThoroughfare {
                self.tempFullStringAddress.append(areaNumber + " ")
            } else {
                print("Could not find areaNumber")
            }
            self.latitude = centerLatitude
            self.longitude = centerLongitude
            self.locationText.text = self.fullStringAddress
            self.fullStringAddress = self.tempFullStringAddress
            print(self.fullStringAddress)
            self.tempFullStringAddress = ""
        })
    }
    
    func sendKakaoLink() {
        // Location 타입 템플릿 오브젝트 생성
        let template = KMTFeedTemplate { (feedTemplateBuilder) in
            
            // 컨텐츠
            feedTemplateBuilder.content = KMTContentObject(builderBlock: { (contentBuilder) in
                contentBuilder.title = self.fullStringAddress
                //contentBuilder.desc = fullStringAddress
                contentBuilder.imageURL = URL(string: self.downloadURL)!
                contentBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.mobileWebURL = URL(string: self.downloadURL)
                })
            })
            // 버튼
            feedTemplateBuilder.addButton(KMTButtonObject(builderBlock: { (buttonBuilder) in
                buttonBuilder.title = "웹지도 보기"
                buttonBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.webURL = URL(string: "http://map.daum.net/look?p=\(self.latitude),\(self.longitude)")
                    linkBuilder.mobileWebURL = URL(string: "http://map.daum.net/look?p=\(self.latitude),\(self.longitude)")
                })
            }))
            feedTemplateBuilder.addButton(KMTButtonObject(builderBlock: { (buttonBuilder) in
                buttonBuilder.title = "앱지도 보기"
                buttonBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
//                    linkBuilder.iosExecutionParams = "param1=value1&param2=value2"
//                    linkBuilder.androidExecutionParams = "param1=value1&param2=value2"
                    linkBuilder.webURL = URL(string: "http://m.map.daum.net/look?p=\(self.latitude),\(self.longitude)")
                    linkBuilder.mobileWebURL = URL(string: "http://m.map.daum.net/look?p=\(self.latitude),\(self.longitude)")
                })
            }))
        }
        // 카카오링크 실행
        KLKTalkLinkCenter.shared().sendDefault(with: template, success: { (warningMsg, argumentMsg) in
            // 성공
            print("warning message: \(String(describing: warningMsg))")
            print("argument message: \(String(describing: argumentMsg))")
            
        }, failure: { (error) in
            // 실패
            //UIAlertController.showMessage(error.localizedDescription)
            print("error \(error)")
            
        })
    }

    // Called when the movement of map is finished
    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
        getStringAddress()
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
