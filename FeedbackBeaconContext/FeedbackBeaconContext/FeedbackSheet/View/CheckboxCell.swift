//
//  CheckboxCell.swift
//  DynamicFeedbackSheets
//
//  Created by Jan Hennings on 09/06/14.
//  Copyright (c) 2014 Jan Hennings. All rights reserved.
//

import UIKit

class CheckboxCell: ModuleCell {
    // MARK: Properties
    
    @IBOutlet var descriptionLabel: UILabel!
    
    override var module: FeedbackSheetModule? {
    willSet {
        if let checkbox = newValue as? DescriptionModule {
            descriptionLabel.text = checkbox.text
        }
    }
    }
    
    // FIXME: Testing, current Bug in Xcode (Ambiguous use of module)
    
    override func setModule(module: FeedbackSheetModule) {
        self.module = module
    }
    
    // MARK: IBActions
    
    @IBAction func toggleCheckbox(sender: UISwitch) {
        if let checkbox = module as? DescriptionModule {
            checkbox.responseData = sender.on
            delegate?.moduleCell(self, didGetResponse: checkbox.responseData, forID: checkbox.ID)
        }
    }
}
