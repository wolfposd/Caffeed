//
//  LongListModuleCell.swift
//  DynamicFeedbackSheets
//
//  Created by Jan Hennings on 09/06/14.
//  Copyright (c) 2014 Jan Hennings. All rights reserved.
//

import UIKit

class LongListCell: ModuleCell, UIPickerViewDataSource, UIPickerViewDelegate {
    // MARK: Properties
    
    @IBOutlet var textField: UITextField!
    let listPicker = UIPickerView()

    override var module: FeedbackSheetModule? {
    willSet {
        if let list = newValue as? ListModule {
            textField.placeholder = list.text
            listPicker.reloadAllComponents()
        }
    }
    }
    
    // FIXME: Testing, current Bug in Xcode (Ambiguous use of module)
    
   override func setModule(module: FeedbackSheetModule) {
        self.module = module
    }
    
    // MARK: View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.layer.borderColor = UIColor.grayColor().CGColor
        textField.layer.borderWidth = 1.5
        textField.layer.cornerRadius = 5
        
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "selectListElement")
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: 44.0))
        toolbar.setItems([flexibleSpace, doneButtonItem], animated: false)
        
        listPicker.delegate = self
        textField.inputAccessoryView = toolbar
        textField.inputView = listPicker
    }
    
    // MARK: Actions
    
    func selectListElement() {
        textField.resignFirstResponder()
    }
    
    override func reloadWithResponseData(responseData: AnyObject) {
       
    }
    
    // MARK: UIPickerViewDataSource
    
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let longList = module as? ListModule {
            return longList.elements.count
        } else {
            return 0
        }
    }
    
    // MARK: UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return (module as? ListModule)?.elements[row];
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int) {
        if let longList = module as? ListModule {
            textField.text = longList.elements[row]
            longList.responseData = longList.elements[row]
            delegate?.moduleCell(self, didGetResponse: longList.responseData, forID: longList.ID)
        }
    }
}
