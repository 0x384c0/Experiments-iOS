//
//  LocationUpdatesLogsVC.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 21.06.17.
//  Copyright © 2017 0x384c0. All rights reserved.
//

class LocationUpdatesLogsVC: UIViewController {
    
    // MARK: UI
    @IBOutlet weak var logsTextView: UITextView!
    // MARK: UI Actions
    @IBAction func reloadTap(_ sender: Any) {
        viewDidLoad()
    }
    //MARK: LifeCycle
    override func viewDidLoad() {
        if showNetwLogs{
            logsTextView.text = AppUserDefaults.locationUpdatesNetworkLog
            return
        }
        
        logsTextView.text = AppUserDefaults.locationUpdatesLog
    }
    
    var showNetwLogs = false
    func setup(showNetwLogs:Bool){
        self.showNetwLogs = showNetwLogs
    }
}
