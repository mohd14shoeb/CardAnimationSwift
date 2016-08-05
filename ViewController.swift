//
//  ViewController.swift
//  GGCardAnimation
//
//  Created by Le Thi An on 8/2/16.
//  Copyright © 2016 Le Thi An. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var draggableContainer: GGDraggableViewContainer!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    draggableContainer = GGDraggableViewContainer(frame: view.frame)
    draggableContainer.datasource = self
    view.addSubview(draggableContainer)
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}

extension ViewController: GGDraggableViewContainerDataSource {
  
  func numberOfCardsForCardContainerView(cardContainerView: GGDraggableViewContainer) -> Int {
    return 5
  }
  
  func cardContainerView(cardContainerView: GGDraggableViewContainer, viewForCardAtIndex: Int) -> GGDraggableView? {
    let newCard = TestCustomDraggableView()
    newCard.pushViewDelegate = self
    return newCard
  }
}

extension ViewController: GGDraggableViewPushViewDelegate {
  func pushViewController() {
    let vc = SecondVC()
    
    let transition = CATransition()
    transition.duration = 0.5
    transition.type = "flip"
    transition.subtype = kCATransitionFromRight
    navigationController?.view.layer.addAnimation(transition, forKey: kCATransition)
    navigationController?.pushViewController(vc, animated: false)
  }
}
