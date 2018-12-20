//
//  GMapsViewController.swift
//  IOSExperiments
//
//  Created by Andrew Ashurow on 03.08.16.
//  Copyright © 2016 0x384c0. All rights reserved.
//

import Foundation
import GoogleMaps
import SMCalloutView


class GMapsViewController: UIViewController {
    let CalloutYOffset:CGFloat = 50.0
    
    var mapView = GMSMapView.map(
        withFrame: CGRect.zero,
        camera: GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6)
    ),
    calloutView = SMCalloutView(),
    infoWindowWidth:CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoWindowWidth = UIApplication.shared.keyWindow?.frame.size.width ?? 60 - 30
        //maps
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        self.view = mapView
        //markers
        let marker1 = GMSMarker(position: CLLocationCoordinate2DMake(-33.86, 151.20))
        marker1.title = "Sydney"
        marker1.snippet = "Custom"
        marker1.map = mapView
        
        let marker2 = GMSMarker(position: CLLocationCoordinate2DMake(-33.86, 151.90))
        marker2.title = "Sydney"
        marker2.snippet = "Native"
        marker2.tracksInfoWindowChanges = true
        marker2.map = mapView
        
        setupSMCalloutView()
        updateInfoWIndowText()
    }
    
    func setupSMCalloutView(){
        calloutView.title = "title"
        calloutView.subtitle = "subtitle"
        let infoWindow = Bundle.main
            .loadNibNamed(CustomInfoWindow.customReuseIdentifier, owner: self, options: nil)!
            .first as! CustomInfoWindow
        var tempFrame = infoWindow.frame
        tempFrame.size.width = infoWindowWidth
        infoWindow.frame = tempFrame
        calloutView.contentMode = .scaleAspectFit
        calloutView.contentViewInset = UIEdgeInsets(top: 0,left: 0,bottom: -1,right: 0)
        calloutView.contentView = infoWindow
    }
    
    
    var infoWindowText = "tqweqweqweqweqwe"
    func updateInfoWIndowText(){
        
        DispatchQueue.mainAfterMilisec(5000, execute: {
            print("UPDATE INFO WINDOW TEXT")
            self.infoWindowText = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
            
            weak var mapView = self.mapView
            let m = mapView?.selectedMarker
            mapView?.selectedMarker = nil
            mapView?.selectedMarker = m
        })
    }
    
}

extension GMapsViewController:GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        if marker.snippet == "Custom" {
            let point = mapView.projection.point(for: marker.position)
            (calloutView.contentView as? CustomInfoWindow)?.setup(title: marker.title ?? "", phone: "123445")
            calloutView.calloutOffset = CGPoint(x: 0, y: -CalloutYOffset)
            calloutView.isHidden = false
            var calloutRect = CGRect.zero
            calloutRect.origin = point
            calloutRect.size = CGSize.zero
            calloutView.presentCallout(from: calloutRect, in: mapView, constrainedTo: mapView, animated: true)
            
            return UIView()
        } else {
            
            
            let stackView = UIStackView(frame: CGRect(x: 0, y: 0, w: infoWindowWidth, h: 0))
            stackView.axis = .vertical
            for _ in 0...3 {
                let lab = UILabel()
                lab.numberOfLines = 0
                lab.text = infoWindowText
                lab.backgroundColor = UIColor.red
                stackView.addArrangedSubview(lab)
            }
            stackView.addConstraint(NSLayoutConstraint(
                item: stackView,
                attribute: .width,
                relatedBy: .equal,
                toItem: nil,
                attribute: .notAnAttribute,
                multiplier: 1.0,
                constant: infoWindowWidth))
            stackView.h = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            return stackView
        }
    }
    
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        /* move callout with map drag */
        if let
            anchor = mapView.selectedMarker?.position,
            mapView.selectedMarker != nil && !self.calloutView.isHidden {
            
            let arrowPt = calloutView.backgroundView.arrowPoint
            var pt = mapView.projection.point(for: anchor)
            pt.x -= arrowPt.x
            pt.y -= arrowPt.y + CalloutYOffset
            calloutView.frame = CGRect(origin: pt, size: calloutView.frame.size)
        } else {
            calloutView.isHidden = true
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.selectedMarker = marker
        return true
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        calloutView.dismissCallout(animated: true)
    }
}
