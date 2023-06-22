//
//  TriangleLoadingView.swift
//  BasicWeatherApp
//
//  Created by iAskedYou2nd on 6/7/23.
//

import UIKit

class TriangleLoadingView: UIView {
    
    private var animationGroup: CAAnimationGroup?
    private var shapeLayer: CAShapeLayer?
    
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.drawShape()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawShape() {
                
        let path = self.drawPath()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        
        self.layer.addSublayer(shapeLayer)
        
        let fillAnimation = CAKeyframeAnimation(keyPath: "fillColor")
        fillAnimation.values = [UIColor.clear.cgColor, UIColor.label.cgColor, UIColor.clear.cgColor]
        fillAnimation.keyTimes = [0, 0.5, 1]
        
        let rotationAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.values = [0, 2 * Double.pi]
        
        let aniGroup = CAAnimationGroup()
        aniGroup.animations = [fillAnimation, rotationAnimation]
        aniGroup.duration = 1.5
        aniGroup.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        aniGroup.repeatCount = .infinity

        self.animationGroup = aniGroup
        self.shapeLayer = shapeLayer
        
        self.backgroundColor = .clear
    }
    
    private func drawPath() -> UIBezierPath {
        let path = UIBezierPath()
        
        let circle = UIBezierPath()
        let centerPoint = CGPoint(x: 0, y: 0)
        let radius: CGFloat = 75 * (2/3)
        
        circle.addArc(withCenter: centerPoint, radius: radius, startAngle: 1.5 * Double.pi, endAngle: 1.5 * Double.pi, clockwise: true)
        // Top
        path.move(to: circle.currentPoint)
        
        circle.addArc(withCenter: centerPoint, radius: radius, startAngle: 1.5 * Double.pi, endAngle: 2.167 * Double.pi, clockwise: true)
        // Right
        path.addLine(to: circle.currentPoint)
        
        circle.addArc(withCenter: centerPoint, radius: radius, startAngle: 2.167 * Double.pi, endAngle: 2.833 * Double.pi, clockwise: true)
        // Left
        path.addLine(to: circle.currentPoint)
        
        path.close()
        
        return path
    }
    
    public func start() {
        guard let group = self.animationGroup else { return }
        self.shapeLayer?.add(group, forKey: "TriangleSpinFadeAnimation")
    }
    
    public func end() {
        self.shapeLayer?.removeAllAnimations()
    }

}
