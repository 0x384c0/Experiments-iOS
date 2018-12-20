//
//  LocationUpdatesVC.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 21.06.17.
//  Copyright © 2017 0x384c0. All rights reserved.
//
import MapKit
import RxSwift

class LocationUpdatesVC: UIViewController {
    // MARK: UI
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationUpdatesSwitch: UISwitch!
    // MARK: UI Actions
    @IBAction func locationUpdatesSwitched(_ sender: UISwitch) {
        if sender.isOn {
            locationManager.startUpdatingLocation()
            AppUserDefaults.locationUpdatesLog = ""
            AppUserDefaults.locationUpdatesNetworkLog = ""
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
    @IBAction func accuracyChanged(_ sender: UISegmentedControl) {
        let accuracyValues = [
            kCLLocationAccuracyBestForNavigation,
            kCLLocationAccuracyBest,
            kCLLocationAccuracyNearestTenMeters,
            kCLLocationAccuracyHundredMeters,
            kCLLocationAccuracyKilometer,
            kCLLocationAccuracyThreeKilometers]
        
        locationManager.desiredAccuracy = accuracyValues[sender.selectedSegmentIndex];
    }
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LocationUpdatesLogsVCNetwork",
            let vc = segue.destination as? LocationUpdatesLogsVC{
            vc.setup(showNetwLogs: true)
        }
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    //MARK: others
    fileprivate var locations = [MKPointAnnotation]()
    private var locationManager: CLLocationManager!
    
    
    
    private var
    disposable:Disposable?,
    lastUpdateDate = Date()
    func testNetwork(){
        let currDate = Date()
        
        if currDate.timeIntervalSince(lastUpdateDate) > 5{
            lastUpdateDate = currDate
            
            var text = AppUserDefaults.locationUpdatesNetworkLog ?? ""
            text += "Testing network\n"
            AppUserDefaults.locationUpdatesNetworkLog = text
            
            disposable = GoogleService()
                .loadApiList()
                .subscribe(
                    onNext: { data in
                        var text = AppUserDefaults.locationUpdatesNetworkLog ?? ""
                        text += "\(Date())\nSUCCESS\n------------\n"
                        AppUserDefaults.locationUpdatesNetworkLog = text
                        print(text)
                },
                    onError:{ _ in
                        var text = AppUserDefaults.locationUpdatesNetworkLog ?? ""
                        text += "\(Date())\nFAIL\n------------\n"
                        AppUserDefaults.locationUpdatesNetworkLog = text
                        print(text)
                })
        }
    }
    
    
    deinit {
        locationManager.stopUpdatingLocation()
        AppUserDefaults.locationUpdatesLog = ""
        AppUserDefaults.locationUpdatesNetworkLog = ""
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationUpdatesVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else {
            return
        }
        
        // Add another annotation to the map.
        let annotation = MKPointAnnotation()
        annotation.coordinate = mostRecentLocation.coordinate
        
        // Also add to our map so we can remove old values later
        self.locations.append(annotation)
        
        // Remove values if the array is too big
        while locations.count > 100 {
            let annotationToRemove = self.locations.first!
            self.locations.remove(at: 0)
            
            // Also remove from the map
            mapView.removeAnnotation(annotationToRemove)
        }
        
        if UIApplication.shared.applicationState == .active {
            mapView.showAnnotations(self.locations, animated: true)
        }
        
        var
        appState = (UIApplication.shared.applicationState == .active) ? "active" :" in background",
        log = "!: \(Date().toString(format: "HH:mm:ss")) \(appState)\n",//"\(Date())\nLocation: \(mostRecentLocation)\nApp state: \(appState)\n-------------",
        text = AppUserDefaults.locationUpdatesLog ?? ""
        text += log
        print(log)
        AppUserDefaults.locationUpdatesLog = text
//        testNetwork()
    }
}
