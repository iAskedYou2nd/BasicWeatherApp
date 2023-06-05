//
//  StackViewExtension.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 6/1/23.
//

import UIKit

extension UIStackView {
    
    convenience init(axis: NSLayoutConstraint.Axis, alignment: Alignment, spacing: CGFloat = 2, distribution: Distribution = .fill) {
        self.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
    }
    
}
