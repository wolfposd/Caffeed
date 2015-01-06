//
//  ModuleCell.swift
//  DynamicFeedbackSheets
//
//  Created by Jan Hennings on 09/06/14.
//  Copyright (c) 2014 Jan Hennings. All rights reserved.
//

import UIKit

@objc public protocol ModuleCellDelegate {
    func moduleCell(cell: ModuleCell, didGetResponse response: NSObject!, forID ID: String)
}

public class ModuleCell: UITableViewCell {
    // MARK: Properties
    
    var module: FeedbackSheetModule?
    var delegate: ModuleCellDelegate?
    
    // MARK: View Life Cycleb
    
    override public func prepareForReuse() {
        module = nil
        delegate = nil
    }
    
    // MARK: Abstract API
    
    func reloadWithResponseData(responseData: AnyObject) { /*abstract method */ }
    
    func setModule(module: FeedbackSheetModule) {  /*  abstract method*/}
}
