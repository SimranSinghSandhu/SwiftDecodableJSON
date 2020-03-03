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
        
        func settingConstraints() {
            descriptionViewHeightConstraint.constant = 0
            descriptionLabelHeightConstraint.constant = 0
        }
        
        func settingGestureRecognizer() {
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandle(sender:)))
            longPressGesture.delegate = self
            longPressGesture.minimumPressDuration = 1.0 // 1 Second Press
            self.tableViewHoliday.addGestureRecognizer(longPressGesture)
        }
        
        @objc func longPressHandle(sender: UILongPressGestureRecognizer) {
            if sender.state == .began {
                let touchPoint = sender.location(in: self.tableViewHoliday)
                    if let indexPath = tableViewHoliday.indexPathForRow(at: touchPoint) {
                        showDescription(description: holidayArray[indexPath.row].description)
                }
            }
        }
        
        func showDescription(description: String) {
            descriptionViewHeightConstraint.constant = 200
            descriptionLabelHeightConstraint.constant = 200
            descriptionLabel.text = description
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 4, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
}
    
