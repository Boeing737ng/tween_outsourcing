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
//    var centerLatitude = 0.0
//    var centerLongitude = 0.0
//    let apiKey = "abba0540e14612ad261541cfcca3f121"
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
    
    func openDaumMap() {
        mapView.delegate = self
        mapView.baseMapType = .standard
        mapView.showCurrentLocationMarker = true
        mapView.currentLocationTrackingMode = .onWithoutHeading
        //self.view.addSubview(mapView)
        self.view.insertSubview(mapView, at: 0)
    }
    
    func addButtonContainerStyle() {
        mapButtonView.layer.cornerRadius = 7
        mapButtonView.layer.shadowColor = UIColor.gray.cgColor
        mapButtonView.layer.shadowOpacity = 1
        mapButtonView.layer.shadowOffset = CGSize.zero
        mapButtonView.layer.shadowRadius = 7
    }
    
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
            //self.fullStringAddress = city! + " " + borough! + " " + dong! + " " + areaNumber!
            print(self.fullStringAddress)
            self.locationText.text = self.fullStringAddress
            self.fullStringAddress = ""
        })
    }
    
    // Called when the map loaded with current location
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        print("latitude:\(location.mapPointGeo().latitude)")
        print("latitude:\(location.mapPointGeo().longitude)")
    }
    
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
