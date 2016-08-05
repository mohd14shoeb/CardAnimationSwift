//
//  TestCustomDraggableView.swift
//  GGCardAnimation
//
//  Created by An Le on 8/2/16.
//  Copyright © 2016 Le Thi An. All rights reserved.
//

import Foundation
import UIKit

class TestCustomDraggableView: GGDraggableView {
  
  override init(frame: CGRect) {
    // 1. setup any properties here
    
    // 2. call super.init(frame:)
    super.init(frame: frame)
    
    // 3. Setup view from .xib file
    xibSetup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    // 1. setup any properties here
    
    // 2. call super.init(coder:)
    super.init(coder: aDecoder)
    
    // 3. Setup view from .xib file
    xibSetup()
  }
  
  convenience init() {
    self.init(frame: CGRect.zero)
    xibSetup()
  }
  
  func xibSetup() {
    createSubView()
  }
  
  func createSubView() {
    
    var allConstraints = [NSLayoutConstraint]()
    
    let imv = UIImageView()
    imv.contentMode = .ScaleToFill
    imv.image = UIImage(named: "32.jpg")
    view.addSubview(imv)
    
    let btnClickHere = UIButton()
    btnClickHere.setTitle("Click Here", forState: .Normal)
    view.addSubview(btnClickHere)
    
    imv.translatesAutoresizingMaskIntoConstraints = false
    btnClickHere.translatesAutoresizingMaskIntoConstraints = false
    
    let views = [
      "imv" : imv,
      "btnClickHere" : btnClickHere
    ]
    
    let consVerticalImv = NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|[imv]|",
      options: [],
      metrics: nil,
      views: views)
    
    allConstraints += consVerticalImv
    
    let consHorizontalImv = NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|[imv]|",
      options: [],
      metrics: nil,
      views: views)
    allConstraints += consHorizontalImv

    let consVerticalBtn = NSLayoutConstraint.constraintsWithVisualFormat(
      "V:[btnClickHere(35)]|",
      options: [],
      metrics: nil,
      views: views)
    
    allConstraints += consVerticalBtn
    
    let consHorizontalBtn = NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|[btnClickHere]|",
      options: [],
      metrics: nil,
      views: views)
    allConstraints += consHorizontalBtn
    
    NSLayoutConstraint.activateConstraints(allConstraints)
    
  }
  
}