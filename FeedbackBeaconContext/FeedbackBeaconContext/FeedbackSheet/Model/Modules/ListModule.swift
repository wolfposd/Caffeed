//
//  ListModule.swift
//  DynamicFeedbackSheets
//
//  Created by Jan Hennings on 08/06/14.
//  Copyright (c) 2014 Jan Hennings. All rights reserved.
//

import UIKit

class ListModule: DescriptionModule {
    // MARK: Properties

    let elements = [String]()
    
    // MARK: Init

    init(moduleType: FeedbackSheetModuleType, ID: String, text: String?, elements: [String]?) {
        if elements != nil {
            self.elements = elements!
        }
        super.init(moduleType: moduleType, ID: ID, text: text)
    }
}
