//
//  DetailViewController.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 12/14/15.
//  Copyright © 2015 0x384c0. All rights reserved.
//

import UIKit


import RxSwift
import RxBlocking
import RxCocoa

class DetailViewController: UIViewController {
    // MARK: UI
    @IBOutlet weak var SaveButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var ratingControl: RatingControl!

    // MARK: RX
    let disposeBag = DisposeBag()

    // MARK: Life Cycle
    override func viewDidLoad() {
        label.text = item?.title
        imageView.af_loadImage(from: item?.image?.thumbnailLink)
        ratingControl.setDelegate(delegateTracker())
    }
    
    // MARK: UI Actions
    @IBAction func saveTap(_ sender: UIBarButtonItem) {
        dismissVC()
    }
    
    // MARK: Others
    private var item: Item?
    func setup(_ item:Item?){
        self.item = item
    }
}

class delegateTracker: CustomDelegate {
    func onAct(_ rating: Int) {
        print("---- \(rating) ----")
    }
}

