//
//  GGOverlayView.swift
//  GGCardAnimation
//
//  Created by Le Thi An on 8/1/16.
//  Copyright © 2016 Le Thi An. All rights reserved.
//

import UIKit

enum GGOverlayViewMode {
  
  case Left
  case Right
  
}

class GGOverlayView: UIView {
  
//  MARK: Properties
  
  var mode: GGOverlayViewMode!
  var imageView : UIImageView!

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = UIColor.whiteColor()
    imageView = UIImageView(image: UIImage(named: "noButton"))
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    imageView.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
  }
  
  func setMode(mode mode: GGOverlayViewMode) {
    if self.mode == mode {
      return
    }
    if mode == GGOverlayViewMode.Left {
      imageView.image = UIImage(named: "noButton")
    } else {
      imageView.image = UIImage(named: "yesButton")
    }
  }
  
}
