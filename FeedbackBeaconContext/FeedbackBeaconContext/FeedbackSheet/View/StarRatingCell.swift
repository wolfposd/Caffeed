//
//  StarRatingCell.swift
//  DynamicFeedbackSheets
//
//  Created by Jan Hennings on 09/06/14.
//  Copyright (c) 2014 Jan Hennings. All rights reserved.
//

import UIKit

class StarRatingCell: ModuleCell, StarRatingViewDelegate {
    // MARK: Properties
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var starRatingView: StarRatingView!

    override var module: FeedbackSheetModule? {
        willSet {
            if let starRatingModule = newValue as? DescriptionModule {
                descriptionLabel.text = starRatingModule.text
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
        starRatingView.alignment = .Center
        starRatingView.delegate = self
    }
    
    // MARK: StarRatingViewDelegate
    
    func starRatingView(view: StarRatingView, didChangeRating newRating: Int) {
        if let starRatingModule = module as? DescriptionModule {
            starRatingModule.responseData = newRating
            delegate?.moduleCell(self, didGetResponse: starRatingModule.responseData, forID: starRatingModule.ID)
        }
    }
}

