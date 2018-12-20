//
//  CustomAlertController.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 08.12.16.
//  Copyright © 2016 0x384c0. All rights reserved.
//


class CustomAlertController : UIViewController {
    
    
    
    private let
    BUTTON_HEIGH:CGFloat = 52,
    LEFT_INSET:CGFloat = 22,
    TITLE_INSET:CGFloat = 14,
    BUTTON_BACKGROUND = UIColor.white,
    TITLE_COLOR = UIColor(red:0.32, green:0.32, blue:0.31, alpha:1.0)
    //MARK: UI
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: UI Actions
    @objc func buttonTap(_ sender: UIButton?) {
        for action in actions{
            if action.title == sender?.titleLabel?.text{
                dismiss(animated: false, completion: {action.handler?(action) })
                return
            }
        }
    }
    @IBAction func cancelTap(_ sender: Any?) {
        dismiss(animated: false, completion: {[weak self] in self?.cancelHandler?()})
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        stackView.spacing = 1 / UIScreen.main.scale
        for action in actions{
            addButtonFor(action: action)
        }
        titleLabel.text = title
    }
    
    //MARK: UIAlertController
    var
    actions = [CustomAlertAction](),
    cancelHandler:(()->())?
    
    func addAction(_ action: CustomAlertAction){
        actions.append(action)
    }
    private func addButtonFor(action:CustomAlertAction){
        let button = UIButton()
        button.setTitle(action.title, for: .normal)
        button.setTitleColor(TITLE_COLOR, for: .normal)
        button.setBackgroundColor(BUTTON_BACKGROUND, forState: .normal)
        button.addConstraint(NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: BUTTON_HEIGH))
        button.contentHorizontalAlignment = .left
        if let image = action.image{
            button.setImage(image, for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: LEFT_INSET, bottom: 0, right: 0)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: LEFT_INSET + TITLE_INSET, bottom: 0, right: 0)
        } else {
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: LEFT_INSET, bottom: 0, right: 0)
        }
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.addTarget(self, action: #selector(buttonTap(_:)), for: .touchUpInside)
        stackView.addArrangedSubview(button)
    }
    
    //MARK: init
    init(title: String?,cancelHandler:(()->())? = nil){
        super.init(nibName: CustomAlertController.className, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        self.cancelHandler = cancelHandler
        self.title = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    deinit {
        Logger.logDeinit(self)
    }
}

class CustomAlertAction{
    init(title: String, image:UIImage? = nil, handler: ((CustomAlertAction) -> Swift.Void)? = nil){
        self.title = title
        self.image = image
        self.handler = handler
    }
    let
    title:String,
    image:UIImage?,
    handler: ((CustomAlertAction) -> Swift.Void)?
}
