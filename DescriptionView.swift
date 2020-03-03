//
//  DescriptionView.swift
//  SwiftDecodableJSON
//
//  Created by Simran Singh Sandhu on 03/03/20.
//  Copyright © 2020 Simran Singh Sandhu. All rights reserved.
//

import Foundation
import UIKit

extension ViewController: UIGestureRecognizerDelegate {
    
    // Adding Long Press Gesture on TableViewHoliday
    func settingGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandle(sender:)))
        longPressGesture.delegate = self
        longPressGesture.minimumPressDuration = 1.0 // 1 Second Press
        self.tableViewHoliday.addGestureRecognizer(longPressGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandle(sender:)))
        self.descriptionView.addGestureRecognizer(panGesture)
    }
    
    
    @objc func longPressHandle(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: self.tableViewHoliday)
                if let indexPath = tableViewHoliday.indexPathForRow(at: touchPoint) {
                    updateDescriptionViewConstraints(height: 200, animation: true)
                    updateDescription(description: holidayArray[indexPath.row].description)
            }
        }
    }
    
    @objc func panGestureHandle(sender: UIPanGestureRecognizer) {
        
            // When Pan Gesture Begins
        if sender.state == .began {
            
        }
            // When Pan Gesture Changes
        else if sender.state == .changed {
            let speed : CGFloat = 10
            let velocity = sender.velocity(in: view)
            
            if velocity.y < 0 {
                descriptionViewHeightConstraint.constant += speed
            } else {
                descriptionViewHeightConstraint.constant -= speed
            }
        }
            // When Pan Gesture Ends
        else if sender.state == .ended {
            // Update DescriptionView with Animation
            if descriptionViewHeightConstraint.constant < 100 {
               updateDescriptionViewConstraints(height: 0, animation: true)
            } else if descriptionViewHeightConstraint.constant > 200 {
               updateDescriptionViewConstraints(height: 200, animation: true)
            }
        }
    }
    
    // Animating Description View when LongPressed on any Holiday with DescriptionLabel.
    func updateDescriptionViewConstraints(height: CGFloat, animation: Bool) {
        
        descriptionViewHeightConstraint.constant = height
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 4, options: .curveEaseIn, animations: {
            if animation {
                self.view.layoutIfNeeded()
            }
        }, completion: nil)
    }
    
    // Update Description Text in DescriptionLabel
    func updateDescription(description: String) {
        descriptionLabel.text = description
    }
}
    
