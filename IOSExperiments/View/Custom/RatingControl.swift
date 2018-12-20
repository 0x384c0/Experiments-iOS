//
//  RatingControl.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 12/8/15.
//  Copyright © 2015 0x384c0. All rights reserved.
//

import UIKit

class RatingControl: UIView {

    // MARK: Properties

    var rating = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    var ratingButtons = [UIButton]()
    var spacing = 5
    var stars = 5
    var delegate: CustomDelegate?

    // MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        let emptyStarImage = UIImage(named: "emptyStar")
        let filledStarImage = UIImage(named: "filledStar")

        for _ in 0 ..< stars {
            let button = UIButton()

            button.setImage(emptyStarImage, for: UIControl.State())
            button.setImage(filledStarImage, for: .selected)
            button.setImage(filledStarImage, for: [.highlighted, .selected])

            button.adjustsImageWhenHighlighted = false

            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(_:)), for: .touchDown)
            ratingButtons += [button]
            addSubview(button)
        }
    }

    override var intrinsicContentSize : CGSize {
        let buttonSize = Int(frame.size.height)
        let width = (buttonSize + spacing) * stars

        return CGSize(width: width, height: buttonSize)
    }

    override func layoutSubviews() {
        // Set the button's width and height to a square the size of the frame's height.
        let buttonSize = Int(frame.size.height)
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)

        // Offset each button's origin by the length of the button plus some spacing.
        for (index, button) in ratingButtons.enumerated() {
            buttonFrame.origin.x = CGFloat(index * (buttonSize + 5))
            button.frame = buttonFrame
        }
        updateButtonSelectionStates()
    }

    func setDelegate(_ del: CustomDelegate) {
        delegate = del
    }

    // MARK: Button Action
    @objc func ratingButtonTapped(_ button: UIButton) {
        rating = ratingButtons.index(of: button)! + 1
        updateButtonSelectionStates()
        print("👍 \(rating)")
        delegate?.onAct(rating)
    }

    func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            // If the index of a button is less than the rating, that button shouldn't be selected.
            button.isSelected = index < rating
        }
    }

}
