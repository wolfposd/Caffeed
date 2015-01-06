//
//  FeedbackSheetPage.swift
//  DynamicFeedbackSheets
//
//  Created by Jan Hennings on 08/06/14.
//  Copyright (c) 2014 Jan Hennings. All rights reserved.
//

import Foundation

public class FeedbackSheetPage : NSObject {
    // MARK: Properties
    
    let title = "No Title"
    let modulesVisible: [FeedbackSheetModule]
    let modulesInvisible: [FeedbackSheetModule]
    
    // MARK: Init
    
    init(title: String?, modulesVisible: [FeedbackSheetModule], modulesInvisible: [FeedbackSheetModule]) {
        if title != nil {
            self.title = title!
        }
        self.modulesVisible = modulesVisible
        self.modulesInvisible = modulesInvisible
    }
}