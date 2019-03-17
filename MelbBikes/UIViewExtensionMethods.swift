//
//  UIViewExtensionMethods.swift
//  MelbBikes
//
//  Created by Sam Wright on 21/2/19.
//  Copyright © 2019 Sam Wright. All rights reserved.
//

import UIKit

extension UIView {
    func setGradientBackgroundColor(colorOne: UIColor, colorTow: UIColor) {
        var existingLayer: CALayer?
        if((layer.sublayers) != nil) {
            existingLayer = layer.sublayers!.first!
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTow.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        
        if(existingLayer != nil) {
            layer.replaceSublayer(existingLayer!, with: gradientLayer)
        } else {
            layer.insertSublayer(gradientLayer, at: 0)
        }
        
    }
}
