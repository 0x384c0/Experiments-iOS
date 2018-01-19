//
//  NavigationDrawerController.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 1/6/16.
//  Copyright © 2016 0x384c0. All rights reserved.
//

import UIKit
import MMDrawerController

class NavigationDrawerController: UIViewController {
    var sideDrawerController = MMDrawerController()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Click(_ sender: AnyObject) {
        sideDrawerController.open(.left, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
