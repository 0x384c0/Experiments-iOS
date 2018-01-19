//
//  ParallaxBlurViewController.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 1/8/16.
//  Copyright © 2016 0x384c0. All rights reserved.
//

import UIKit
import ParallaxBlur

import RxSwift
import RxBlocking
import RxCocoa


class ParallaxBlurViewController: JPBFloatingTextViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: "https://material-design.storage.googleapis.com/publish/material_v_4/social.png") {
            if let data = try? Data(contentsOf: url) {
                let uiImage = UIImage(data: data)
                
                setTitleText("Title")
                setSubtitleText("sub")
                setHeaderImage(uiImage)
//                let imageView:UIImageView = UIImageView(frame: CGRectMake(15, self.headerHeight() - 100, 90, 90))
//                imageView.image = uiImage
//                addHeaderOverlayView(imageView)
            }
        }
    }

    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
}
