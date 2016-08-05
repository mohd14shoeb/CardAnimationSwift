//
//  GGDraggableViewBackground.swift
//  GGCardAnimation
//
//  Created by An Le on 8/1/16.
//  Copyright © 2016 Le Thi An. All rights reserved.
//

import UIKit

protocol GGDraggableViewContainerDataSource: NSObjectProtocol {
  func numberOfCardsForCardContainerView(cardContainerView: GGDraggableViewContainer) -> Int
  func cardContainerView(cardContainerView: GGDraggableViewContainer, viewForCardAtIndex: Int) -> GGDraggableView?
}

class GGDraggableViewContainer: UIView {
  
  weak var datasource : GGDraggableViewContainerDataSource? {
    didSet { // Only start to work if delegate is set
      if datasource != nil {
        configure()
      }
    }
  }
  private var cardArray : [GGDraggableView]! = []
  private var cardsLoadedIndex = 0
  private var loadedCards: [GGDraggableView]! = []
  private var allCards: [GGDraggableView]! = []
  private var cardCount = 0
  
  private struct GGDraggableViewContainerPrivateConstants {
    static let maxBufferSize = 2
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
  }
  
  private func configure() {
    configureConstants()
    generateCards()
  }
  
  private func configureConstants() {
    cardCount = self.datasource?.numberOfCardsForCardContainerView(self) ?? 0
  }
  
  private func generateCards() {
    if cardCount > 0 {
      
      let numLoadedCardsCap = cardCount > GGDraggableViewContainerPrivateConstants.maxBufferSize ? cardCount : GGDraggableViewContainerPrivateConstants.maxBufferSize
      for index in 0..<cardCount {
        if let newCard = datasource?.cardContainerView(self, viewForCardAtIndex: index) {
          newCard.delegate = self
          allCards.append(newCard)
          if index < numLoadedCardsCap {
            loadedCards.append(newCard)
          }
        }
      }
      
      for index in 0..<loadedCards.count {
        if index > 0 {
          self.insertSubview(loadedCards[index], belowSubview: loadedCards[index-1])
        } else {
          self.addSubview(loadedCards[index])
        }
        cardsLoadedIndex += 1
      }
      
    }
  }
  
  func reloadData() {
    configure()
  }
  
  func swipeRight() {
    let dragView = loadedCards.first
    dragView?.overlayView.mode = .Right
    UIView.animateWithDuration(animationDuration, animations: {
      dragView?.overlayView.alpha = 1
    }) { (complete) in
      dragView?.rightAction()
    }
  }
  
  func swipeLeft() {
    let dragView = loadedCards.first
    dragView?.overlayView.mode = .Right
    UIView.animateWithDuration(animationDuration, animations: {
      dragView?.overlayView.alpha = 1
    }) { (complete) in
      dragView?.leftClickAction()
    }
  }
  
}

//MARK: GGDraggableViewDelegate

extension GGDraggableViewContainer: GGDraggableViewDelegate {
  
  func cardSwipeLeft(card: UIView) {
    loadedCards.removeAtIndex(0)
    if  cardsLoadedIndex < cardArray.count {
      loadedCards.append(cardArray[cardsLoadedIndex])
      cardsLoadedIndex += 1
      self.insertSubview(loadedCards[GGDraggableViewContainerPrivateConstants.maxBufferSize-1], belowSubview: loadedCards[GGDraggableViewContainerPrivateConstants.maxBufferSize-2])
    }
  }
  
  func cardSwipeRight(card: UIView) {
    loadedCards.removeAtIndex(0)
    if cardsLoadedIndex < cardArray.count {
      loadedCards.append(cardArray[cardsLoadedIndex])
      cardsLoadedIndex += 1
      self.insertSubview(loadedCards[GGDraggableViewContainerPrivateConstants.maxBufferSize-1], belowSubview: loadedCards[GGDraggableViewContainerPrivateConstants.maxBufferSize-2])
    }
  }
}
