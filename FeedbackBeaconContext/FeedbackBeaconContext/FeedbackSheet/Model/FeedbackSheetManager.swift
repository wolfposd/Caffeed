//
//  FeedbackSheetManager.swift
//  DynamicFeedbackSheets
//
//  Created by Jan Hennings on 08/06/14.
//  Copyright (c) 2014 Jan Hennings. All rights reserved.
//

import Foundation


public class FeedbackSheetManager : NSObject {
    // MARK: Properties
    
    var baseURL: String
    var delegate: FeedbackSheetManagerDelegate?
    
    // MARK: Init
    
    /**
        Initializes a new FeedbackSheetManager with the provided base URL.
    
        :param: baseURL The base URL of the REST-API.
    
        :returns: An initialized FeedbackSheetManager object.
    */
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    // MARK: Public API
    
    /** 
        Starts fetching the sheet for the given ID.
        
        :param: sheetID The ID of the sheet you want to fetch.
    */
    func startFetchingSheetWithID(sheetID: String) {
        let fetchURL = NSURL(string: "\(baseURL)sheet/id/\(sheetID)")
        var request = NSMutableURLRequest(URL: fetchURL!)
        request.HTTPMethod = "GET"
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) {
            response, data, error in
            if error != nil {
                self.delegate?.feedbackSheetManager(self, didFailWithError: error)
            } else {
                if let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary {
                    if let sheet = FeedbackSheetManager.feedbackSheetFromDictionary(jsonData) {
                        self.delegate?.feedbackSheetManager(self, didFinishFetchingSheet: sheet)
                    } else {
                        let sheetCreationError = NSError(domain: "FeedbackSheetManager Error", code: -1, userInfo: [NSLocalizedDescriptionKey : "Couldn't create Feedback Sheet", NSLocalizedFailureReasonErrorKey : "No title or no ID or no modules"])
                        self.delegate?.feedbackSheetManager(self, didFailWithError: sheetCreationError)
                    }
                } else {
                    let jsonDataError = NSError(domain: "FeedbackSheetManager Error", code: -1, userInfo: [NSLocalizedDescriptionKey : "Couldn't create JSONDictionary", NSLocalizedFailureReasonErrorKey : "No server response data"])
                    self.delegate?.feedbackSheetManager(self, didFailWithError: jsonDataError)
                }
            }
            
        }
    }
    
    /**
        Starts posting the responses dictionary for the given ID.
    
        :param: sheetID The ID of the sheet you want to post the responses to.
        :param: responses Dictionary with the responses of each sheet module.
    */
    func postResponseWithSheetID(sheetID: String, response: NSDictionary) {
        
        let fetchURL = NSURL(string: "\(baseURL)sheet/id/\(sheetID)")
        let request = NSMutableURLRequest(URL: fetchURL!)
        request.HTTPMethod = "PUT"
        
        var error: NSError?
        let jsonData = NSJSONSerialization.dataWithJSONObject(response, options: nil, error: &error)
        
        request.HTTPBody = jsonData
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) {
            response, data, error in
            if error != nil {
                self.delegate?.feedbackSheetManager(self, didFailWithError: error)
                self.delegate?.feedbackSheetManager(self, didPostSheetWithSuccess: false)
            } else {
                // success
                println(response)
                self.delegate?.feedbackSheetManager(self, didPostSheetWithSuccess: true)
            }
        }
    }
    
    // MARK: FeedbackSheet Construction Methods
    
    public class func feedbackSheetFromDictionary(dict: NSDictionary) -> FeedbackSheet? {
        let title = dict["title"] as? String
        var ID = dict["id"] as? Int
        
        if(ID == nil ){
            ID = -1;
        }
                
        if !(title != nil && ID != nil) {
            return nil
        }
        
        var pages = [FeedbackSheetPage]()
        
        if let pagesArray = dict["pages"] as? Array<NSDictionary> {
            for pageDict in pagesArray {
                if let page = feedbackSheetPageFromDictionary(pageDict) {
                    pages.append(page)
                }
            }
        }
        
        if pages.count > 0 {
            return FeedbackSheet(title: title!, ID: ID!, pages: pages)
        } else {
            return nil
        }
    }
    
    public class func feedbackSheetPageFromDictionary(dict: NSDictionary) -> FeedbackSheetPage? {
        let title = dict["title"] as? String
        var modulesVisible = [FeedbackSheetModule]()
        var modulesInvisible = [FeedbackSheetModule]()
        
        
        if let modulesArray = dict["elements"] as? Array<NSDictionary> {
            for moduleDict in modulesArray {
                if let module = feedbackSheetModuleFromDictionary(moduleDict) {
                    if module.isInvisible {
                        modulesInvisible.append(module)
                    } else {
                        modulesVisible.append(module)
                    }
                }
            }
        }
        
        if modulesVisible.count > 0 {
            return FeedbackSheetPage(title: title, modulesVisible: modulesVisible, modulesInvisible: modulesInvisible)
        } else {
            return nil
        }
    }
    
    public class func feedbackSheetModuleFromDictionary(dict: NSDictionary) -> FeedbackSheetModule? {
        var type:FeedbackSheetModuleType?
        
        if let typeString = dict["type"] as? String {
            
            var tString = dict["type"] as? String;
            tString = tString?.stringByReplacingOccurrencesOfString("module", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            
            
            type = FeedbackSheetModuleType.init(rawValue: tString!);
//            type = FeedbackSheetModuleType.fromRaw(dict["type"] as String)
        } else {
            return nil
        }
        
        let ID = dict["id"] as? String
        if ID == nil {
            return nil
        }
        
        let text = dict["text"] as? String
        let elements = dict["elements"] as? Array<String>
        let length = dict["length"] as? Int
        let min = dict["min"] as? Double
        let max = dict["max"] as? Double
        let step = dict["step"] as? Double
        let title = dict["title"] as? String
        
        var module: FeedbackSheetModule?
        
        switch type! {
        case .List, .LongList:
            module = ListModule(moduleType: type!, ID: ID!, text: text, elements: elements)
        case .TextField, .TextArea:
            module = TextModule(moduleType: type!, ID: ID!, text: text, characterLimit: length)
        case .Checkbox, .StarRating, .Date, .Photo:
            module = DescriptionModule(moduleType: type!, ID: ID!, text: text)
        case .Slider:
            module = SliderModule(moduleType: type!, ID: ID!, text: text, minValue: min, maxValue: max, stepValue: step)
        case .ToS:
            module = ToSModule(moduleType: type!, ID: ID!, text: text, title: title)
        case .GPS, .Accelerometer, .TimeStamp:
            module = FeedbackSheetModule(moduleType: type!, ID: ID!)
        default:
            module = nil
        }
        
        return module
    }
}






