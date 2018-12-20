//
//  ViewController.swift
//  CalendarPickerExperiments
//
//  Created by Andrew Ashurow on 15.11.16.
//  Copyright © 2016 Andrew Ashurow. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func showCalendar(_ sender: Any) {
        print("showCalendar")
        let vc = CalendarPickerCVC()
        vc.periodMode = true
        vc.calendarDelegate = self
        vc.collectionView?.backgroundColor = UIColor.white
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController : CalendarPickerVCDelegate{
    func didSelectDates(_ dates: [Any]!) {
    }
}
