//
//  YMKMapView.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 05.12.16.
//  Copyright © 2016 0x384c0. All rights reserved.
//

extension YMKMapView{
    @discardableResult
    func goToUserLocation(animated:Bool = true) -> Bool{
        let MAP_DELTA_FOR_USER_LOCATION = 0.005
        var mapRegion = YMKMapRegion()
        if userLocation.coordinate().latitude != 0 &&
            userLocation.coordinate().longitude != 0 {
            mapRegion.center = userLocation.coordinate()
            mapRegion.span.latitudeDelta = MAP_DELTA_FOR_USER_LOCATION
            mapRegion.span.longitudeDelta = MAP_DELTA_FOR_USER_LOCATION
            setRegion(safe:mapRegion,animated: animated)
            return true
        }
        return false
    }
    public func setRegion(safe region: YMKMapRegion, animated: Bool){
        
        let
        LAT_MAX:Double = 85,
        LAT_MIN:Double = -85,
        LNG_MAX:Double = 180,
        LNG_MIN:Double = -180
        
        if region.center.latitude   > LAT_MIN &&
            region.center.latitude  < LAT_MAX &&
            region.center.longitude > LNG_MIN &&
            region.center.longitude < LNG_MAX {
            setRegion(region, animated: animated)
        }
    }
}
