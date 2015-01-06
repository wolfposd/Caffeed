//
//  DateCell.swift
//  DynamicFeedbackSheets
//
//  Created by Jan Hennings on 09/06/14.
//  Copyright (c) 2014 Jan Hennings. All rights reserved.
//

import UIKit

class DateCell: ModuleCell {
    // MARK: Properties
    
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var textField: UITextField!
    let datePicker = UIDatePicker()
    let dateFormatter = NSDateFormatter()

    override var module: FeedbackSheetModule? {
    willSet {
        if let date = newValue as? DescriptionModule {
            descriptionLabel.text = date.text
            textField.text = nil
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
        // Initialization code
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        textField.text = dateFormatter.stringFromDate(NSDate())
        
        textField.layer.borderColor = UIColor.grayColor().CGColor
        textField.layer.borderWidth = 1.5
        textField.layer.cornerRadius = 5
        
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "pickDate")
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: 44.0))
        toolbar.setItems([flexibleSpace, doneButtonItem], animated: false)
        
        textField.inputAccessoryView = toolbar
        textField.inputView = datePicker
    }

    // MARK: Actions
    
    func pickDate() {
        textField.resignFirstResponder()
        if let date = module as? DescriptionModule {
            textField.text = dateFormatter.stringFromDate(datePicker.date)
            date.responseData = dateFormatter.stringFromDate(datePicker.date)
            delegate?.moduleCell(self, didGetResponse: date.responseData, forID: date.ID)
        }

    }
    
    override func reloadWithResponseData(responseData: AnyObject) {
        textField.text = responseData as String
    }
}
