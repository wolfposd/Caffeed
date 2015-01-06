//
//  FeedbackSheetModule.swift
//  DynamicFeedbackSheets
//
//  Created by Jan Hennings on 08/06/14.
//  Copyright (c) 2014 Jan Hennings. All rights reserved.
//

import Foundation

enum FeedbackSheetModuleType: String {
    // Visible Modules
    case List = "list"
    case LongList = "longlist"
    case TextField = "textfield"
    case TextArea = "textarea"
    case Checkbox = "checkbox"
    case Slider = "slider"
    case StarRating = "star"
    case Date = "date"
    case Photo = "photo"
    case ToS = "tos"
    
    // Invisible Modules
    case GPS = "gps"
    case Accelerometer = "accelerometer"
    case TimeStamp = "auto-date"
}

public class FeedbackSheetModule : NSObject
{
    // MARK: Properties

    let type: FeedbackSheetModuleType
    let ID: String
    
    var isInvisible: Bool {
    get {
        switch type {
        case .GPS, .Accelerometer, .TimeStamp:
            return true
        default:
            return false
        }
    }
    }
    
    // Response Data
    var responseData: NSObject?
    
    // MARK: Init
    
    init(moduleType: FeedbackSheetModuleType, ID: String) {
        type = moduleType
        self.ID = ID
    }
}