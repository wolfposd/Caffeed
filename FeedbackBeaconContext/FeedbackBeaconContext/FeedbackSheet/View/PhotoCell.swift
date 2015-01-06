//
//  PhotoCell.swift
//  DynamicFeedbackSheets
//
//  Created by Jan Hennings on 09/06/14.
//  Copyright (c) 2014 Jan Hennings. All rights reserved.
//

import UIKit

class PhotoCell: ModuleCell, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: Properties
    
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var photoView: UIImageView!
    var presentingController: UIViewController?
    
    override var module: FeedbackSheetModule? {
    willSet {
        if let photo = newValue as? DescriptionModule {
            descriptionLabel.text = photo.text
            descriptionLabel.sizeToFit()
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
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoView.image = UIImage(named: "camera")
    }
    
    // MARK: IBActions
    
    @IBAction func pickPhoto(sender: UIButton) {
        if presentingController != nil {
            let actionSheet = UIActionSheet(title: "Choose:", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Camera", "Library")
            actionSheet.showInView(self.superview)
        } else {
            println("Error: No presenting controller")
        }
    }
    
    // MARK: UIActionSheetDelegate
    
    func actionSheet(actionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == actionSheet.cancelButtonIndex { return }
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        if buttonIndex == 0 {
            if !(UIImagePickerController.isSourceTypeAvailable(.Camera)) { return }
            pickerController.sourceType = .Camera
        }
        
        
        // FIXME: Present Controller
//        self.presentingController?.presentModalViewController(pickerController, animated: true)
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: NSDictionary!) {
        if let photo = module as? DescriptionModule {
            let pickedPhoto = info[UIImagePickerControllerOriginalImage] as UIImage
            photoView.image = pickedPhoto
            //photo.responseData = pickedPhoto
            //delegate?.moduleCell(self, didGetResponse: photo.responseData, forID: photo.ID)
        }
        
        presentingController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
