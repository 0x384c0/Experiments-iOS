//
//  ImageTableCell.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 11/26/15.
//  Copyright © 2015 0x384c0. All rights reserved.
//

class ImageTableCell: UITableViewCell,ExplandableCell {
    
    // MARK: UI
    @IBOutlet weak var CellLabel: UILabel!
    @IBOutlet weak var CallImage: UIImageView!
    @IBOutlet weak var explandableView: UIView!
    static let estimatedHeigh:CGFloat = 100
    
    //MARK: UI Actions
    @IBAction func expandTap(_ sender: UIButton) {
        explandTap()
    }
    
    // MARK: Others
    private var _item: Item?
    var item:Item?{return _item}
    func setup(_ item: Item?){
        _item = item
        CellLabel.text = item?.title
        CallImage.af_loadImage(from: item?.image?.thumbnailLink)
    }
    
    //MARK: ExplandableCell
    weak var delegate:ExplabdableTableDelegate?
    var indexPath: IndexPath?
    func expland(){
        explandableView.alpha = 0
        explandableView.isHidden = false
        explandableView.animate(duration: 0.3, animations: {[weak self] in
            self?.explandableView.alpha = 1
        })
//        arrowImageView.setAngle(179.99)
    }
    func collapse(){
        explandableView.isHidden = true
//        arrowImageView.setAngle(0)
    }
}
