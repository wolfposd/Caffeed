//
//  DescriptionModule.swift
//  DynamicFeedbackSheets
//
//  Created by Jan Hennings on 08/06/14.
//  Copyright (c) 2014 Jan Hennings. All rights reserved.
//

import UIKit

class DescriptionModule: FeedbackSheetModule {
    // MARK: Properties

    let text = "No text"
    
    // MARK: Init

    init(moduleType: FeedbackSheetModuleType, ID: String, text: String?) {
        if text != nil {
            self.text = text!
        }
        super.init(moduleType: moduleType, ID: ID)
    }
}
