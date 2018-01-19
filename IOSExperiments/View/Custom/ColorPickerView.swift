//
//  ColorPickerView.swift
//  IOSExperiments
//
//  Created by Andrew Ashurow on 20.12.16.
//  Copyright © 2016 0x384c0. All rights reserved.
//

class ColorPickerView: UIPickerView{//TODO:remove
    @IBInspectable
    var colorViewHeigh:CGFloat = 10
    fileprivate var rowHeigh:CGFloat = 40
    
    
    init() {
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    private func setupView(){
        dataSource = self
        delegate = self
        rowHeigh = h
        isUserInteractionEnabled = false
    }
    
    var selectedColor:UIColor?{
        get {
            return _selectedColor
        }
        set {
            var selectedRow = 0
            for (index,color) in colors.enumerated(){
                if newValue == color{
                   selectedRow = index
                }
            }
            selectRow(selectedRow, inComponent: 0, animated: false)
            _selectedColor = newValue
        }
    }
    private var _selectedColor:UIColor?
    fileprivate var colors = [UIColor]()
    func setup(colors:[UIColor],handler: ((UIColor)->())? = nil){
        self.colors = colors
        colorPickHandler = handler
        reloadAllComponents()
    }
    
    var colorPickHandler:((UIColor)->())?
    
    func toggleHeigh(){
        if expanded {
            collapse()
        } else {
            expand()
        }
    }
    
    private var expanded = false
    private func expand(){
        expanded = true
        isUserInteractionEnabled = true
        animate(duration: 0.3, animations: { [unowned self] in
            self.bounds.h = self.rowHeigh * 3
            self.layoutIfNeeded()
        })
    }
    func collapse(){
        expanded = false
        isUserInteractionEnabled = false
        animate(duration: 0.3, animations: { [unowned self] in
            self.bounds.h = self.rowHeigh
            self.layoutIfNeeded()
        })
    }
}

extension ColorPickerView:UIPickerViewDelegate, UIPickerViewDataSource{
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return rowHeigh
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView(x: 0, y: 0, w: pickerView.w - 20, h: colorViewHeigh)
        view.backgroundColor = colors[row]
        return view
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colors.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedColor = pickerView.view(forRow: row, forComponent: component)?.backgroundColor
        if let selectedColor = selectedColor {
            colorPickHandler?(selectedColor)
        }
        collapse()
    }
}

