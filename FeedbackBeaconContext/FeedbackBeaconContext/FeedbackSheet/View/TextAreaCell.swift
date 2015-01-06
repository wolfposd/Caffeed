//
//  TextAreaCell.swift
//  DynamicFeedbackSheets
//
//  Created by Jan Hennings on 09/06/14.
//  Copyright (c) 2014 Jan Hennings. All rights reserved.
//

import UIKit

class TextAreaCell: ModuleCell, UITextViewDelegate {
    // MARK: Properties
    
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var charactersLabel: UILabel!
    
    override var module: FeedbackSheetModule? {
    willSet {
        if let textModule = newValue as? TextModule {
            descriptionLabel.text = textModule.text
            textView.text = nil
            charactersLabel.text = "Remaining characters: \(textModule.characterLimit)"
        }
    }
    }
    
    // FIXME: Testing, current Bug in Xcode (Ambiguous use of module)
    
    override func setModule(module: FeedbackSheetModule) {
        self.module = module
    }
    
    // MARK: View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()

        textView.layer.borderColor = UIColor.grayColor().CGColor
        textView.layer.borderWidth = 1.5
        textView.layer.cornerRadius = 5
        textView.delegate = self
        
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "finishTextViewEditing")
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: 44.0))
        toolbar.setItems([flexibleSpace, doneButtonItem], animated: false)
        
        textView.inputAccessoryView = toolbar
    }
    
    // MARK: Actions
    
    override func reloadWithResponseData(responseData: AnyObject) {
        let text = responseData as String
        let textLength = countElements(text)
        var shouldChange = true
        textView.text = text
        
        if let textModule = module as? TextModule {
            shouldChange = (textLength <= textModule.characterLimit) ? true : false
            if shouldChange {
                charactersLabel.text = "Remaining characters: \(textModule.characterLimit - textLength)"
            }
        }
    }
    
    func finishTextViewEditing() {
        textView.resignFirstResponder()
    }
    
    // MARK: UITextViewDelegate
    
    func textView(textView: UITextView!, shouldChangeTextInRange range: NSRange, replacementText text: String!) -> Bool {
        let newLength = countElements(textView.text!) + countElements(text!) - range.length
        var shouldChange = true
        
        if let textModule = module as? TextModule {
            shouldChange = (newLength <= textModule.characterLimit) ? true : false
            if shouldChange {
                charactersLabel.text = "Remaining characters: \(textModule.characterLimit - newLength)"
            }
        }
        
        return shouldChange
    }
    
    
    func textViewDidEndEditing(textView: UITextView!) {
        if let textModule = module as? TextModule {
            textModule.responseData = textView.text
            delegate?.moduleCell(self, didGetResponse: textModule.responseData, forID: textModule.ID)
        }
    }
    
}
