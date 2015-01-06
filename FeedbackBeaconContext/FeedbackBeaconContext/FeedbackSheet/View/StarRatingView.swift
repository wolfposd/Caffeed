//
//  StarRatingView.swift
//  DynamicFeedbackSheets
//
//  Created by Jan Hennings on 20/08/14.
//  Copyright (c) 2014 Jan Hennings. All rights reserved.
//

import UIKit

enum StarRatingViewAlignment {
    case Left
    case Center
    case Right
}

// MARK: Protocol - StarRatingViewDelegate

protocol StarRatingViewDelegate {
    func starRatingView(view: StarRatingView, didChangeRating newRating: Int)
}

class StarRatingView: UIView {
    // MARK: Properties
    
    private var origin = CGPointZero
    private var padding = 4.0
    var numberOfStars = 5
    var delegate: StarRatingViewDelegate?

    var alignment: StarRatingViewAlignment = .Left {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var starImage: UIImage {
        didSet  {
            setNeedsDisplay()
        }
    }
    
    var starHiglightedImage: UIImage {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var rating: Int = 1 {
        didSet {
            if oldValue != rating {
                setNeedsDisplay()
                notifyDelegate()
            }
        }
    }
    
    var editable: Bool = true {
        didSet {
            userInteractionEnabled = editable
        }
    }
    
    // MARK: Init
    
    init(frame: CGRect, starImage: UIImage, starHiglightedImage: UIImage) {
        self.starImage = starImage
        self.starHiglightedImage = starHiglightedImage
        
        super.init(frame: frame)
        
        opaque = false
        backgroundColor = UIColor.clearColor()
    }
    
    override convenience init(frame: CGRect) {
        let starImage = UIImage(named: "star")
        let starHiglightedImage = UIImage(named: "starHiglighted")
        
        self.init(frame: frame, starImage: starImage!, starHiglightedImage: starHiglightedImage!)
    }
    
    required init(coder aDecoder: NSCoder) {
        starImage = UIImage(named: "star")!
        starHiglightedImage = UIImage(named: "starHiglighted")!
        
        super.init(coder: aDecoder)
        
        opaque = false
        backgroundColor = UIColor.clearColor()
    }
    
    // MARK: Drawing Code
    
    override func drawRect(rect: CGRect) {
        let xOrigin = (bounds.size.width - CGFloat(numberOfStars) * starImage.size.width - CGFloat(numberOfStars - 1) * CGFloat(padding))
        
        switch alignment {
        case .Left:
            origin = CGPointZero
        case .Center:
            origin = CGPoint(x: xOrigin / 2, y: 0)
        case .Right:
            origin = CGPoint(x: xOrigin, y: 0)
        }
        
        // Draw stars
        var x = origin.x
        
        for index in 0 ..< numberOfStars {
            starImage.drawAtPoint(CGPoint(x: x, y: origin.y))
            x += starImage.size.width + CGFloat(padding)
        }
        
        // Draw higlighted stars
        x = origin.x
        
        for index in 0 ..< rating {
            starHiglightedImage.drawAtPoint(CGPoint(x: x, y: origin.y))
            x += starHiglightedImage.size.width + CGFloat(padding)
        }
    }
    
    // MARK: Touch Handlers
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        if let touch = touches.anyObject() as? UITouch {
            let touchLocation = touch.locationInView(self)
            handleTouchAtLocation(touchLocation)
        }
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        if let touch = touches.anyObject() as? UITouch {
            let touchLocation = touch.locationInView(self)
            handleTouchAtLocation(touchLocation)
        }
    }
    
    func handleTouchAtLocation(location: CGPoint) {
        for var i = numberOfStars - 1; i > -1; i-- {
            if location.x > origin.x + CGFloat(i) * (starImage.size.width + CGFloat(padding)) - (CGFloat(padding) / 2) {
                rating = i + 1
                return
            }
        }
        
        rating = 1;
    }
    
    // MARK: Delegate
    
    func notifyDelegate() {
        delegate?.starRatingView(self, didChangeRating: rating)
    }
}
