//
//  MKPointAnnotation.swift
//  IOSExperiments
//
//  Created by Andrew Ashurov on 9/18/18.
//  Copyright © 2018 0x384c0. All rights reserved.
//

import MapKit

extension MKPointAnnotation {
    
    static func region(annotations: [MKPointAnnotation]) -> MKCoordinateRegion {
        let MIN_DELTA = 0.001
        
        var minLatitude: CLLocationDegrees = 90.0//TODO: validate coords
        var maxLatitude: CLLocationDegrees = -90.0
        var minLongitude: CLLocationDegrees = 180.0
        var maxLongitude: CLLocationDegrees = -180.0
        
        let coordinates = annotations.map{$0.coordinate}
        
        for coordinate in coordinates {
            let lat = Double(coordinate.latitude)
            let long = Double(coordinate.longitude)
            
            if lat == 0 || long == 0 {
                continue
            }
            
            if lat < minLatitude {
                minLatitude = lat
            }
            if long < minLongitude {
                minLongitude = long
            }
            if lat > maxLatitude {
                maxLatitude = lat
            }
            if long > maxLongitude {
                maxLongitude = long
            }
        }
        
        var span = MKCoordinateSpan(latitudeDelta: maxLatitude - minLatitude, longitudeDelta: maxLongitude - minLongitude)
        let center = CLLocationCoordinate2DMake((maxLatitude - span.latitudeDelta / 2), (maxLongitude - span.longitudeDelta / 2))
        
        if span.latitudeDelta < MIN_DELTA{
            span.latitudeDelta = MIN_DELTA
        }
        if span.longitudeDelta < MIN_DELTA{
            span.longitudeDelta = MIN_DELTA
        }
        
        return MKCoordinateRegion(center: center, span: span)
    }
}
