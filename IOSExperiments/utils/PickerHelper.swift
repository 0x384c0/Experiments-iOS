//
//  PickerHelper.swift
//  Movers
//
//  Created by Oleg Ten on 11/12/18.
//  Copyright © 2018 0x384c0. All rights reserved.
//

import Foundation

class PickerHelper:NSObject{
    public func setup(items:[String],textField:UITextField, changeHandler:((String?) -> ())? = nil){
        self.changeHandler = changeHandler
        self.items = items
        self.textField = textField
        self.textField?.inputView = picker
        picker.delegate = self
        picker.dataSource = self
        self.textField?.delegate = self
    }
    
    private var changeHandler:((String?) -> ())?
    let picker = UIPickerView()
    weak var textField:UITextField?
    private var items = [String]()
    
}
extension PickerHelper: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField?.text = items[row]
        changeHandler?(textField?.text)
    }
}
extension PickerHelper:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let selectedID = items.firstIndex(of: textField.text ?? ""){
            picker.selectRow(selectedID, inComponent: 0, animated: false)
        }
        textField.text = items[picker.selectedRow(inComponent: 0)]
        changeHandler?(textField.text)
    }
}

class DatePickerHelper:NSObject,UITextFieldDelegate{
    private let datePicker = UIDatePicker()
    private weak var textField:UITextField?
    public func setup(textField:UITextField, changeHandler:((String?) -> ())? = nil){
        self.textField = textField
        self.changeHandler = changeHandler
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        datePicker.datePickerMode = .date
        var components = DateComponents()
        components.year = +1
        components.year = 0
        let minDate = Calendar.current.date(byAdding: components , to: Date())
        datePicker.minimumDate = minDate
        textField.inputView = datePicker
        
        textField.delegate = self
    }
    
    private var changeHandler:((String?) -> ())?
    @objc func dateChanged(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: sender.date)
        let dateFormatter = DateFormatter()
        if
            let day = components.day,
            let month = components.month,
            let year = components.year {
            
            let months = dateFormatter.shortMonthSymbols
            let monthSymbol = months?[month-1] as! String
            textField?.text = "\(monthSymbol) \(day), \(year)"
            changeHandler?(textField?.text)
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        dateChanged(datePicker)
    }
}
