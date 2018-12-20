//
//  UIComponentsViewController.swift
//  IOSExperiments
//
//  Created by Andrew Ashurov on 12/20/18.
//  Copyright © 2018 0x384c0. All rights reserved.
//

import UIKit

class UIComponentsViewController: BaseViewController {
    //MARK: UI
    @IBOutlet weak var stringPickerTextView: TextFieldView!
    @IBOutlet weak var colorPickerTextView: TextFieldView!
    
    //MARK: UI Actions
    @IBAction func customAlertTap(_ sender: Any) {
        let vc = CustomAlertController(title: "TITLE ALERT")
        vc.addAction(CustomAlertAction(title: "action 1", image: UIImage(named: "ic_eye"), handler: nil))
        vc.addAction(CustomAlertAction(title: "action 2"))
        present(vc, animated: true, completion: nil)
    }
    @IBAction func customTextFieldAlertTap(_ sender: Any) {
        let vc = UIAlertControllerWithTextField(title: "TITLE ALERT", message: "MESSAGE_ALERT", preferredStyle: .alert)
        let a = UIAlertAction(title: "ACTION", style: .default, handler: nil)
        vc.addAction(a)
        vc.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: nil))
        vc.addTextField(
            text: nil,
            placeholder: "PHONE_NUMBER",
            keyboardType: .phonePad,
            textContentType:.telephoneNumber,
            spellChecker: { text in a.isEnabled = !(text?.isEmpty ?? true) }
        )
        present(vc, animated: true, completion: nil)
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickers()
    }
    
    //MARK: Others
    private let
    pickerHelper = PickerHelper(),
    colorPicker = ColorPickerView()
    private func setupPickers(){
        pickerHelper.setup(items: ["ITEM 1","ITEM 2","ITEM 3","ITEM 4"], textField: stringPickerTextView.textField)
        colorPicker.setup(colors: [UIColor.red,UIColor.gray,UIColor.green,UIColor.blue,],handler: {[unowned self] color in
            self.colorPickerTextView.text = "\(color)"
        })
        colorPickerTextView.textField.inputView = colorPicker
    }
}
