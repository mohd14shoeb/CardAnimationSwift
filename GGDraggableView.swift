//
//  GGDraggableView.swift
//  GGCardAnimation
//
//  Created by Le Thi An on 8/1/16.
//  Copyright © 2016 Le Thi An. All rights reserved.
//

import UIKit

protocol GGDraggableViewDelegate: NSObjectProtocol {
  func cardSwipeLeft(card: UIView)
  func cardSwipeRight(card: UIView)
  
}

@objc protocol GGDraggableViewPushViewDelegate: NSObjectProtocol {
  optional func pushViewController()
}

class GGDraggableView: UIView {
  
  weak var delegate: GGDraggableViewDelegate?
  weak var pushViewDelegate: GGDraggableViewPushViewDelegate?
  
  private var panGestureRecognizer: UIPanGestureRecognizer!
  private var tapGestureRecognizer: UITapGestureRecognizer!
  private var originalPoint: CGPoint!
  private var xFromCenter: CGFloat!
  private var yFromCenter: CGFloat!
  private var shadowLayer: CAShapeLayer!
  lazy var view: UIView! = {
    return self
  }()
  var overlayView: GGOverlayView!
  
  private struct GGDraggableViewConstants {
    static let actionMarginDefine: CGFloat =  120
    static let scaleStrengthDefine: Float = 4
    static let scaleMaxDefine : Float = 0.93
    static let rotationMaxDefine: CGFloat = 1
    static let rotationStrengthDefine: CGFloat = 320
    static let rotationAngleDefine = M_PI/8
    
    struct CardDefaultSize {
      static let width : CGFloat = 290
      static let height : CGFloat = 386
    }
    
  }
  
  override init(frame: CGRect) {
    super.init(frame: CGRect(x: (UIScreen.mainScreen().bounds.size.width - GGDraggableViewConstants.CardDefaultSize.width)/2, y: (UIScreen.mainScreen().bounds.size.height - GGDraggableViewConstants.CardDefaultSize.height)/2, width: GGDraggableViewConstants.CardDefaultSize.width, height: GGDraggableViewConstants.CardDefaultSize.height))
    setupView()
    createView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
    createView()
  }
  
  func setupView() {
    layer.masksToBounds = true
    layer.borderWidth = 1
    layer.borderColor = UIColor.blackColor().CGColor
    layer.cornerRadius = 10
    layer.shadowRadius = 3
    layer.shadowOpacity = 0.2
    layer.shadowOffset = CGSizeMake(1, 1)
  }

  func createView() {

    backgroundColor = UIColor.blackColor()
//    panGestureRecognizer =  UIPanGestureRecognizer(target: self, action:
//        @selector(GGDraggableView.beingDragged(_:)))
//    tapGestureRecognizer = UITapGestureRecognizer(target: self, action:@selector(GGDraggableView.tapToPushViewController(_:)) )
//    addGestureRecognizer(panGestureRecognizer)
//    addGestureRecognizer(tapGestureRecognizer)
    
    overlayView = GGOverlayView(frame: CGRect(x: (frame.size.width-100)/2, y: (frame.size.height-100)/2, width: 100, height: 100))
    overlayView.alpha = 0
    addSubview(overlayView)

  }
  
  func tapToPushViewController(tapGestureRecognizer: UITapGestureRecognizer) {
    if let _ = pushViewDelegate?.pushViewController!(){
    }
  }

  func beingDragged(gestureRecognizer: UIPanGestureRecognizer!) {
    
    xFromCenter = gestureRecognizer.translationInView(self).x
    yFromCenter = gestureRecognizer.translationInView(self).y
    
    
    switch gestureRecognizer.state {
    case .Began:
      originalPoint = center
    case .Changed:
      let rotationStrength = min(xFromCenter/GGDraggableViewConstants.rotationStrengthDefine, GGDraggableViewConstants.rotationMaxDefine)
      let rotationAngel = CGFloat (GGDraggableViewConstants.rotationAngleDefine) * rotationStrength
      let scale = max(1 - fabsf(Float(rotationStrength)) / GGDraggableViewConstants.scaleStrengthDefine, GGDraggableViewConstants.scaleMaxDefine)
      center = CGPoint(x: originalPoint.x + xFromCenter, y: originalPoint.y + yFromCenter)
      var transform: CGAffineTransform = CGAffineTransformMakeRotation(rotationAngel)
      let scaleTransform: CGAffineTransform = CGAffineTransformScale(transform, CGFloat(scale), CGFloat(scale))
      transform = scaleTransform
      updateOverlay(xFromCenter)
    case .Ended:
      afterSwipeAction()
    default:
      break
    }
  }
  
  func updateOverlay (distance: CGFloat) {
    if distance > 0 {
      overlayView.mode = .Right
    } else {
      overlayView.mode = .Left
    }
    
    overlayView.alpha = min(CGFloat(fabsf(Float(distance))/100), 0.4)
  }
  
  func afterSwipeAction() {
    if xFromCenter > GGDraggableViewConstants.actionMarginDefine {
      rightAction()
    } else if xFromCenter < -GGDraggableViewConstants.actionMarginDefine {
      leftAction()
    } else {
      UIView.animateWithDuration(animationDuration, animations: {
        self.center = self.originalPoint
        self.transform = CGAffineTransformMakeRotation(0)
        self.overlayView.alpha = 0
      })
    }
  }
  
  func rightAction() {
    let finishPoint = CGPoint(x: 500, y: 2*yFromCenter + originalPoint.y)
    UIView.animateWithDuration(animationDuration, animations: {
      self.center = finishPoint
      }) { (complete) in
        self.removeFromSuperview()
    }
    if let _ = delegate?.cardSwipeRight(self) {}
    print("YES")
  }
  
  func leftAction() {
    let finishPoint = CGPoint(x: -500, y: 2*yFromCenter + originalPoint.y)
    UIView.animateWithDuration(animationDuration, animations: {
      self.center = finishPoint
      }) { (complete) in
        self.removeFromSuperview()
    }
    if let _ = delegate?.cardSwipeLeft(self) {
    }
    print("NO")
  }
  
  func rightClickAction() {
    let finishPoint: CGPoint = CGPoint(x: 600, y: center.y)
    UIView.animateWithDuration(animationDuration, animations: {
      self.center = finishPoint
      self.transform = CGAffineTransformMakeRotation(1)
      }) { (complete) in
        self.removeFromSuperview()
    }
    if let _ = delegate?.cardSwipeLeft(self) {}
    print("YES")
  }
  
  func leftClickAction() {
    let finishPoint: CGPoint = CGPoint(x: -600, y: center.y)
    UIView.animateWithDuration(animationDuration, animations: {
      self.center = finishPoint
      self.transform = CGAffineTransformMakeRotation(-1)
    }) { (complete) in
      self.removeFromSuperview()
    }
    if let _ = delegate?.cardSwipeRight(self) {}
    print("NO")
  }
  
}
