//
//  YandexMapViewDelegate.swift
//
//
//  Created by 0x384c0 on 05.12.16.
//  Copyright © 2016 . All rights reserved.
//
import MapKit
import SMCalloutView

class YandexMapViewDelegate : NSObject, YMKMapViewDelegate {
    
    
    var
    calloutOnClickHandler:((Department) -> Void)?,
    showCallout = true,
    mapView: YMKMapView,
    calloutView = SMCalloutView()
    
    init(mapView: YMKMapView){
        self.mapView = mapView
        let
        ALPHA:CGFloat = 0.96
        if let backgroundView = calloutView.backgroundView.subviews[safe:0],
            let pinView = calloutView.backgroundView.subviews[safe:1],
            let backColor = backgroundView.backgroundColor?.withAlphaComponent(ALPHA){
            backgroundView.backgroundColor = backColor
            pinView.alpha = ALPHA
            
            backgroundView.layer.shadowRadius = 5
            backgroundView.layer.shadowColor = UIColor.black.cgColor
            backgroundView.layer.shadowOffset = CGSize(width: 0, height: 5);
            backgroundView.layer.shadowOpacity = 0.2
        }
    }
    
    func mapView(_ mapView: YMKMapView, viewFor annotation: YMKAnnotation) -> YMKAnnotationView? {
        if (annotation is YMKUserLocation) {
            return nil
        }
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: YMKDepartmentAnnotationView.reuseId) as? YMKDepartmentAnnotationView
        let eventAnnotation = annotation as? YMKDepartmentAnnotation
        
        if anView == nil {
            anView = YMKDepartmentAnnotationView(eventAnnotation: annotation as! YMKDepartmentAnnotation, reuseId: YMKDepartmentAnnotationView.reuseId)
        }
        anView?.annotation = annotation
        anView?.event = eventAnnotation?.event
        anView?.eventAnnotation = eventAnnotation
        
        
        let annotationTap = UITapGestureRecognizer(target: self, action: #selector(YandexMapViewDelegate.handleTap(_:)))
        if anView?.gestureRecognizers?.count ?? 0 <= 10{
            anView?.addGestureRecognizer(annotationTap)
        }
        
        anView?.centerOffset = CGPoint(x:0, y:((anView?.image?.size.height ?? 46)/2))
        return anView
    }
    
    func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if showCallout {
            let annotationView = sender?.view as! YMKDepartmentAnnotationView
            let eventAnnotation = annotationView.eventAnnotation
            
            let infoWindow = Bundle
                .main
                .loadNibNamed(CustomInfoWindow.customReuseIdentifier, owner: self, options: nil)!
                .first as! CustomInfoWindow
            infoWindow.setup(data: eventAnnotation?.event)
            var tempFrame = CGRect(
                x: 0,
                y: 0,
                w: mapView.w - 30,
                h: mapView.h
            )
            tempFrame.size.height = infoWindow.subviews.first!.systemLayoutSizeFitting(
                tempFrame.size,
                withHorizontalFittingPriority: UILayoutPriorityRequired,
                verticalFittingPriority: UILayoutPriorityDefaultLow
                ).height
            infoWindow.frame = tempFrame
            infoWindow.urlTap = {[weak self] data in self?.didClickOnCalloutView(data)}
            
            calloutView.dismissCallout(animated: true)
            
            calloutView.contentMode = .scaleAspectFit
            calloutView.contentViewInset = UIEdgeInsets(top: 0,left: 0,bottom: -1,right: 0)
            calloutView.contentView = infoWindow
            annotationView.calloutView = calloutView
            calloutView.presentCallout(from: annotationView.bounds, in: annotationView, constrainedTo: mapView, animated: true)
        }
    }
    
    
    func didClickOnCalloutView(_ data: Department?){
        if let event = data {
            calloutOnClickHandler?(event)
        }
    }
    func mapView(_ mapView: YMKMapView!, gotSingleTapAt coordinate: YMKMapCoordinate) {
        calloutView.dismissCallout(animated: true)
    }
}


class YMKDepartmentAnnotationView: YMKAnnotationView {
    static let reuseId = "YMKDepartmentAnnotationView"
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var
    event:Department?,
    eventAnnotation:YMKDepartmentAnnotation?,
    calloutView:SMCalloutView?
    
    init(eventAnnotation: YMKDepartmentAnnotation, reuseId: String?) {
        super.init(annotation: eventAnnotation, reuseIdentifier: reuseId)
        event = eventAnnotation.event
        
        switch eventAnnotation.event.getType() {
        case .department:
            image = UIImage(named:"branch")
        case .atm:
            image = UIImage(named: "atm")
        }
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let calloutMaybe = self.calloutView?.hitTest(self.calloutView?.convert(point, from: self) ?? CGPoint(), with: event)
        if calloutMaybe != nil {
            return calloutMaybe
        } else {
            return super.hitTest(point, with: event)
        }
    }
}

class YMKDepartmentAnnotation: NSObject, YMKAnnotation {
    var
    coordinateAnnot: CLLocationCoordinate2D,
    event:Department
    
    init(coordinate: CLLocationCoordinate2D,event:Department) {
        self.coordinateAnnot = coordinate
        self.event = event
    }
    
    func coordinate() -> YMKMapCoordinate {
        return coordinateAnnot
    }
}

