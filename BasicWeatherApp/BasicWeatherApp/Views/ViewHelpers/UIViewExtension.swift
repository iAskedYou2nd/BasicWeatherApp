//
//  UIViewExtension.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 6/1/23.
//

import UIKit

extension UIView {
    
    static func generateSpacerView() -> UIView {
        let spacer = UIView(frame: .zero)
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.backgroundColor = .clear
        spacer.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        spacer.setContentHuggingPriority(UILayoutPriority(1), for: .horizontal)
        spacer.setContentCompressionResistancePriority(UILayoutPriority(1), for: .vertical)
        spacer.setContentCompressionResistancePriority(UILayoutPriority(1), for: .horizontal)
        return spacer
    }
    
    func bindToContainerView(edges: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)) {
        guard let containerViewSafeArea = self.superview?.safeAreaLayoutGuide else {
            fatalError("You forgot to add the view to the view hierarchy. Check your code")
        }
        
        self.topAnchor.constraint(equalTo: containerViewSafeArea.topAnchor, constant: edges.top).isActive = true
        self.leadingAnchor.constraint(equalTo: containerViewSafeArea.leadingAnchor, constant: edges.left).isActive = true
        self.trailingAnchor.constraint(equalTo: containerViewSafeArea.trailingAnchor, constant: -edges.right).isActive = true
        self.bottomAnchor.constraint(equalTo: containerViewSafeArea.bottomAnchor, constant: -edges.bottom).isActive = true
    }
    
}
