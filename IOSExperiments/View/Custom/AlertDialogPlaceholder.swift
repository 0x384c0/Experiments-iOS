//
//  AlertDialogPlaceholder.swift
//  iosExperiments
//
//  Created by 0x384c0 on 2/17/16.
//  Copyright © 2016 0x384c0. All rights reserved.
//

import UIKit

class AlertDialogPlaceholder: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var view: UIView!
    
    var
    handler:((_ isCancel: Bool) -> Void)?
    
    
    
    convenience init (title:String?, message:String?, buttonText:String?, handler:((_ isCancel: Bool) -> Void)?, cancelButtonText:String? = nil){
        self.init()
        titleLabel.text = title
        subTitleLabel.text = message
        button.setTitle(buttonText, for: .normal)
        if let cancelButtonText = cancelButtonText{
            cancelButton.isHidden = false
            cancelButton.setTitle(cancelButtonText, for: .normal)
        }
        self.handler = handler
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    func setupView() {
        Bundle.main.loadNibNamed("AlertDialogPlaceholder", owner: self, options: nil)
        view.frame = frame
        self.addSubview(view)
        
        
    }
    @IBAction func onCancelClick(_ sender: Any) {
        handler?(true)
    }
    
    @IBAction func onClick(_ sender: UIButton) {
        handler?(false)
    }
    
    
    
    func show(for view:UIView?){
        if let view = view{
            frame.size = view.frame.size
            view.addSubview(self)
        }
    }
    func hide(){
        removeFromSuperview()
    }
    
    
    var style:UIScrollViewIndicatorStyle{
        set{
            switch newValue {
            case .default, .black:
                break
            case .white:
                backgroundColor = UIColor.white
                subviews.first?.backgroundColor = UIColor.white
                titleLabel.textColor = UIColor.black
                subTitleLabel.textColor = UIColor.darkGray
            }
        }
        get { return backgroundColor == UIColor.white ? .white : .default }
    }
}

