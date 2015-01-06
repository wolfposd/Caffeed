//
//  ToSModule.swift
//  DynamicFeedbackSheets
//
//  Created by Jan Hennings on 08/06/14.
//  Copyright (c) 2014 Jan Hennings. All rights reserved.
//

import UIKit

class ToSModule: DescriptionModule {
    // MARK: Properties
    
    let title = "No Title"
    
    // MARK: Init
    
    init(moduleType: FeedbackSheetModuleType, ID: String, text: String?, title: String?) {
        if title != nil {
            self.title = title!
        }
        super.init(moduleType: moduleType, ID: ID, text: text)
    }
}
