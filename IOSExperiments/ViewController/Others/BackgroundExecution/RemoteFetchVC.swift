//
//  RemoteFetchVC.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 20.06.17.
//  Copyright © 2017 0x384c0. All rights reserved.
//


class RemoteFetchVC: UIViewController {
    // MARK: UI
    @IBOutlet weak var fetchSwitch: UISwitch!
    @IBOutlet weak var fetchResultLabel: UILabel!
    @IBOutlet weak var fetchStatus: UILabel!
    
    // MARK: UI Actions
    @IBAction func fetchSwitched(_ sender: UISwitch) {
        RemoteFetchWrapper.isEnabled = sender.isOn
    }
    @IBAction func refreshTap(_ sender: UIBarButtonItem) {
        viewDidLoad()
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        fetchSwitch.isOn = RemoteFetchWrapper.isEnabled
        fetchResultLabel.text = AppUserDefaults.remoteFetchLog ?? "nil"
        
        switch UIApplication.shared.backgroundRefreshStatus{
        case .available:
            fetchStatus.text = "\nbackgroundRefreshStatus: available"
        case .denied:
            fetchStatus.text = "\nbackgroundRefreshStatus: denied"
        case .restricted:
            fetchStatus.text = "\nbackgroundRefreshStatus: restricted"
        }
    }
}
