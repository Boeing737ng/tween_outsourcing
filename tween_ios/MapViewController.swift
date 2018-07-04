//
//  MapViewController.swift
//  tween_ios
//
//  Created by Kihyun Choi on 2018. 7. 5..
//  Copyright © 2018년 sfo. All rights reserved.
//

import UIKit

class MapViewController: UIViewController,MTMapViewDelegate {
    
    lazy var mapView: MTMapView = MTMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))

    override func viewDidLoad() {
        super.viewDidLoad()
        openDaumMap()
        // Do any additional setup after loading the view.
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        let current = MTMapPointGeo()
//        print(current.latitude)
//        print(current.longitude)
//    }
    
    // Called when the map loaded with current location
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        print("latitude:\(location.mapPointGeo().latitude)")
        print("latitude:\(location.mapPointGeo().longitude)")
    }
    func openDaumMap() {
        mapView.delegate = self
        mapView.baseMapType = .standard
        mapView.showCurrentLocationMarker = true
        mapView.currentLocationTrackingMode = .onWithoutHeading
        self.view.addSubview(mapView)
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
