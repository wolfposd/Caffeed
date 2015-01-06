//
//  SliderModule.swift
//  DynamicFeedbackSheets
//
//  Created by Jan Hennings on 08/06/14.
//  Copyright (c) 2014 Jan Hennings. All rights reserved.
//

import UIKit

class SliderModule: DescriptionModule {
    // MARK: Properties
    
    let minValue = 0.0
    let maxValue = 1.0
    let stepValue = 0.2
    
    // MARK: Init
    
    init(moduleType: FeedbackSheetModuleType, ID: String, text: String?, minValue: Double?, maxValue: Double?, stepValue: Double?) {
        if minValue != nil {
            self.minValue = minValue!
        }
        if maxValue != nil {
            self.maxValue = maxValue!
        }
        if stepValue != nil {
            self.stepValue = stepValue!
        }
        super.init(moduleType: moduleType, ID: ID, text: text)
    }
}
