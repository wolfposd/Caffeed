//
//  FSViewControllerHelper.swift
//  FeedbackBeaconContext
//
//  Created by Wolf Posdorfer on 03.11.14.
//  Copyright (c) 2014 Wolf Posdorfer. All rights reserved.
//

import Foundation
import UIKit



public class FSViewControllerHelper : NSObject
{
    
    public class func registerModuleCells(tableView: UITableView)
    {
        let nibNames = ["ListCell", "LongListCell", "TextFieldCell", "TextAreaCell", "CheckboxCell", "SliderCell", "StarRatingCell", "DateCell", "PhotoCell", "ToSCell"]
        let identifier = [FeedbackSheetModuleType.List.rawValue, FeedbackSheetModuleType.LongList.rawValue, FeedbackSheetModuleType.TextField.rawValue, FeedbackSheetModuleType.TextArea.rawValue, FeedbackSheetModuleType.Checkbox.rawValue, FeedbackSheetModuleType.Slider.rawValue, FeedbackSheetModuleType.StarRating.rawValue, FeedbackSheetModuleType.Date.rawValue, FeedbackSheetModuleType.Photo.rawValue, FeedbackSheetModuleType.ToS.rawValue]
        
        for (index, name) in enumerate(nibNames) {
            tableView.registerNib(UINib(nibName: name, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: identifier[index])
        }
    }
    
    
    
    public class func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, dictionary: Dictionary<String, NSObject>, page: FeedbackSheetPage, delegate: ModuleCellDelegate) -> UITableViewCell  {
        let module = page.modulesVisible[indexPath.section]
        let type = module.type
        
        let moduleCell = tableView.dequeueReusableCellWithIdentifier(type.rawValue) as ModuleCell
        moduleCell.delegate = delegate;
        
        moduleCell.setModule(module);
        
        // Reload persisted state
        if let data = dictionary[module.ID] {
            moduleCell.reloadWithResponseData(data)
        }
        
        return moduleCell
    }
}