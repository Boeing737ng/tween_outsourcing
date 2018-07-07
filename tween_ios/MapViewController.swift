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

    @IBOutlet var mapButtonView: UIView!
    @IBOutlet var locationText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openDaumMap()
        addButtonContainerStyle()
    }
    
    @IBAction func onSelectLocation(_ sender: Any) {
        
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
                print(city)
                self.fullStringAddress.append(city + " ")
            } else {
                print("Could not find city")
            }
            if let borough = placemarks?[0].locality {
                if borough != "세종특별자치시" {
                    print(borough)
                    self.fullStringAddress.append(borough + " ")
                }
            } else {
                print("Could not find borough")
            }
            if let dong = placemarks?[0].thoroughfare {
                print(dong)
                self.fullStringAddress.append(dong + " ")
            } else {
                print("Could not find dong")
            }
            if let areaNumber = placemarks?[0].subThoroughfare {
                print(areaNumber)
                self.fullStringAddress.append(areaNumber + " ")
            } else {
                print("Could not find areaNumber")
            }
            print(self.fullStringAddress)
            self.locationText.text = self.fullStringAddress
            self.fullStringAddress = ""
        })
    }
    
    func sendKakaoLink() {
        // Location 타입 템플릿 오브젝트 생성
        let template = KMTFeedTemplate { (feedTemplateBuilder) in
            
            // 컨텐츠
            feedTemplateBuilder.content = KMTContentObject(builderBlock: { (contentBuilder) in
                contentBuilder.title = "좀 되라"
                contentBuilder.desc = "#케익"
                contentBuilder.imageURL = URL(string: "http://mud-kage.kakao.co.kr/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png")!
                contentBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.mobileWebURL = URL(string: "https://developers.kakao.com")
                })
            })
            // 버튼
            feedTemplateBuilder.addButton(KMTButtonObject(builderBlock: { (buttonBuilder) in
                buttonBuilder.title = "웹으로"
                buttonBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.mobileWebURL = URL(string: "https://developers.kakao.com")
                })
            }))
            feedTemplateBuilder.addButton(KMTButtonObject(builderBlock: { (buttonBuilder) in
                buttonBuilder.title = "앱으로"
                buttonBuilder.link = KMTLinkObject(builderBlock: { (linkBuilder) in
                    linkBuilder.iosExecutionParams = "param1=value1&param2=value2"
                    linkBuilder.androidExecutionParams = "param1=value1&param2=value2"
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
    
    // Called when the map loaded with current location
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        print("latitude:\(location.mapPointGeo().latitude)")
        print("latitude:\(location.mapPointGeo().longitude)")
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
