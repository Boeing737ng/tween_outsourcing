//
//  MapViewController.swift
//  tween_ios
//
//  Created by Kihyun Choi on 2018. 7. 5..
//  Copyright © 2018년 sfo. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class MapViewController: UIViewController,MTMapViewDelegate,MTMapReverseGeoCoderDelegate {
    
    lazy var mapView: MTMapView = MTMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
    
    var tempFullStringAddress: String = ""
    static var fullStringAddress: String = ""
    static var latitude = 0.0
    static var longitude = 0.0
    static var downloadURL: String = ""
    static var daumWebURL = "http://map.daum.net/look?p=\(latitude),\(longitude)"
    static var daumMobileURL = "http://m.map.daum.net/look?p=\(latitude),\(longitude)"
    static var googleMapURL = "https://www.google.co.kr/maps/place/\(latitude), \(longitude)"

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let modalView = segue.destination as! ModalViewController
        modalView.stringAddress = locationText.text!
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
            MapViewController.latitude = centerLatitude
            MapViewController.longitude = centerLongitude
            self.locationText.text = MapViewController.fullStringAddress
            MapViewController.fullStringAddress = self.tempFullStringAddress
            self.tempFullStringAddress = ""
        })
    }
    
    func sendKakaoLink() {
        // Location 타입 템플릿 오브젝트 생성
        let template = KMTFeedTemplate { (feedTemplateBuilder) in
            
            // 컨텐츠
            feedTemplateBuilder.content = KMTContentObject(builderBlock: { (contentBuilder) in
                contentBuilder.title = MapViewController.fullStringAddress
                //contentBuilder.desc = fullStringAddress
                contentBuilder.imageURL = URL(string: MapViewController.downloadURL)!
                contentBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.mobileWebURL = URL(string: MapViewController.downloadURL)
                })
            })
            // 버튼
            feedTemplateBuilder.addButton(KMTButtonObject(builderBlock: { (buttonBuilder) in
                buttonBuilder.title = "웹지도 보기"
                buttonBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.webURL = URL(string: MapViewController.daumWebURL)
                    linkBuilder.mobileWebURL = URL(string: MapViewController.daumWebURL)
                })
            }))
            feedTemplateBuilder.addButton(KMTButtonObject(builderBlock: { (buttonBuilder) in
                buttonBuilder.title = "앱지도 보기"
                buttonBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
//                    linkBuilder.iosExecutionParams = "param1=value1&param2=value2"
//                    linkBuilder.androidExecutionParams = "param1=value1&param2=value2"
                    linkBuilder.webURL = URL(string: MapViewController.daumMobileURL)
                    linkBuilder.mobileWebURL = URL(string: MapViewController.daumMobileURL)
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
    
    func getCurrentDate() -> String {
        let date = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy/MM/dd"
        let dateString = dateFormat.string(from: date)
        return dateString
    }
    
    func sendTweenCall() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.childByAutoId().setValue([
            "Date": getCurrentDate(),
            "DaumUrl": MapViewController.daumWebURL,
            "GoogleUrl": MapViewController.googleMapURL,
            "Lat": MapViewController.latitude,
            "Lng": MapViewController.longitude,
            "Location": MapViewController.fullStringAddress,
            "Phone": "",
            "Photo": MapViewController.downloadURL
            ])
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
