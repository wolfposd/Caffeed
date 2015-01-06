//
//  FeedbackSheet.swift
//  DynamicFeedbackSheets
//
//  Created by Jan Hennings on 08/06/14.
//  Copyright (c) 2014 Jan Hennings. All rights reserved.
//

import Foundation

public class FeedbackSheet : NSObject
{
    // MARK: Properties

    let title = "No Title"
    let ID: Int
    let pages: [FeedbackSheetPage]
    let fetchDate = NSDate()
    
    // MARK: Init

    init(title: String, ID: Int, pages: [FeedbackSheetPage]) {
        self.title = title
        self.ID = ID
        self.pages = pages
    }
   
    
    public func toString() -> String
    {
        return "Title: \(title) id:\(ID) pagescount:\(pages.count) date:\(fetchDate)";
    }
    
}