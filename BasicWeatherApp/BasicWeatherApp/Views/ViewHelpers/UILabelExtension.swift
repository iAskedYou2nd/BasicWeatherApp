//
//  UILabelExtension.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 6/1/23.
//

import UIKit

extension UILabel {
    
    convenience init(initialText: String, alignment: NSTextAlignment, font: UIFont = UIFont.systemFont(ofSize: 17)) {
        self.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = initialText
        self.textAlignment = alignment
        self.font = font
        self.numberOfLines = 0
    }
    
}
