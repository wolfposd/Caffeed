//
//  ListModuleCell.swift
//  DynamicFeedbackSheets
//
//  Created by Jan Hennings on 09/06/14.
//  Copyright (c) 2014 Jan Hennings. All rights reserved.
//

import UIKit

class ListCell: ModuleCell {
    // MARK: Properties
    
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var listControl: UISegmentedControl!
    
    override var module: FeedbackSheetModule? {
    willSet {
        listControl.removeAllSegments()
        descriptionLabel.text = nil
        
        if let list = newValue as? ListModule {
            descriptionLabel.text = list.text
            
            for (index, segmentTitle) in enumerate(list.elements) {
                listControl.insertSegmentWithTitle(segmentTitle, atIndex: index, animated: true)
            }
        }
    }
    }
    
    // FIXME: Testing, current Bug in Xcode (Ambiguous use of module)
    
    override func setModule(module: FeedbackSheetModule) {
        self.module = module
    }
    
    // MARK: IBActions
    
    @IBAction func selectSegment(sender: UISegmentedControl) {
        if let list = module as? ListModule {
            list.responseData = list.elements[sender.selectedSegmentIndex]
            delegate?.moduleCell(self, didGetResponse: list.responseData, forID: list.ID)
        }
    }
    
    // MARK: Actions
    
    override func reloadWithResponseData(responseData: AnyObject) {
        for index in 0..<listControl.numberOfSegments {
            if responseData as? String == listControl.titleForSegmentAtIndex(index) {
                listControl.selectedSegmentIndex = index
            }
        }
    }
}
