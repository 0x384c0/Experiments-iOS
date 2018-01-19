//
//  MainTableController.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 12/28/15.
//  Copyright © 2015 0x384c0. All rights reserved.
//

import UIKit

class MainTableController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Properties
    var screens = [Screen]()

    func setItems(_ screens: [Screen]) -> MainTableController {
        self.screens = screens
        return self
    }




    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return screens.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MainTableCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MainTableCell


        let screen = screens[(indexPath as NSIndexPath).row]

        cell.title.text = screen.title
        cell.subTitle.text = screen.subTitle

        return cell
    }


}
