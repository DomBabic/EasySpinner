//
//  EasySpinner.swift
//  EasySpinner
//
//  Created by Dominik Babić on 20/05/2020.
//  Copyright © 2020 HeliOs. All rights reserved.
//

import UIKit

public class EasySpinner: UIView {
    
    public var angleStep: CGFloat
    
    public var layerColor: CGColor
    public var dotColor: CGColor
    
    public var dotSize: CGFloat
    public var dotScale: CGFloat
    
    public var duration: TimeInterval = 2
    
    private var points: [CGPoint] = []
    private var sublayers: [CALayer] = []
    
    private var initialDraw = true {
        didSet {
            setProperties()
        }
    }
    
    private var isAnimating = false
    
    private enum AnimationKey: String {
        case rotation
        case scale
        case fadeIn
        case fadeOut
    }
    
    private lazy var rotation: CABasicAnimation = {
        let rightRound = CABasicAnimation(keyPath: "transform.rotation.z")
        rightRound.fromValue = 0
        rightRound.toValue = CGFloat.pi * 2
        rightRound.duration = duration
        rightRound.repeatCount = .infinity
        return rightRound
    } ()
    
    private lazy var scale: CABasicAnimation = {
        let a = CABasicAnimation(keyPath: "transform.scale")
        a.fromValue = NSValue.init(caTransform3D: CATransform3DMakeScale(1.00, 1.00, 1.00))
        a.toValue = NSValue.init(caTransform3D: CATransform3DMakeScale(dotScale, dotScale, 1.00))
        a.duration = duration
        a.repeatCount = .infinity
        a.autoreverses = true
        return a
    } ()
    
    private lazy var fadeIn: CABasicAnimation = {
        let a = CABasicAnimation(keyPath: "opacity")
        a.fromValue = 0.0
        a.toValue = 1.0
        a.duration = duration
        a.isRemovedOnCompletion = false
        a.fillMode = .forwards
        return a
    } ()
    
    private lazy var fadeOut: CABasicAnimation = {
        let a = CABasicAnimation(keyPath: "opacity")
        a.fromValue = 1.0
        a.toValue = 0.0
        a.duration = duration
        a.isRemovedOnCompletion = false
        a.fillMode = .forwards
        return a
    } ()
    
    public init(frame: CGRect = .zero,
         angleStep: CGFloat = 15,
         layerColor: UIColor = .init(red: 3, green: 194, blue: 252, alpha: 1.0),
         dotColor: UIColor = .white,
         dotSize: CGFloat = 5,
         dotScale: CGFloat = 2) {
        self.angleStep = angleStep
        
        self.layerColor = layerColor.cgColor
        self.dotColor = dotColor.cgColor
        
        self.dotSize = dotSize
        self.dotScale = dotScale
        
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        self.angleStep = 15
        
        self.layerColor = UIColor.init(red: 3, green: 194, blue: 252, alpha: 1.0).cgColor
        self.dotColor = UIColor.white.cgColor
        
        self.dotSize = 5
        self.dotScale = 2
        
        super.init(coder: coder)
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            if self.initialDraw {
                self.initialDraw.toggle()
            }
        })
    }
    
    private func setProperties() {
        layer.backgroundColor = layerColor
        layer.cornerRadius = frame.width / 2
        
        calculatePoints(&points)
        
        points.forEach({ point in
            drawLayer(for: point)
        })
    }
    
    private func calculatePoints(with angle: CGFloat = 0, _ points: inout [CGPoint]) {
        guard angle < 360 else {
            return
        }
        
        let r = (bounds.width / 2) - (dotSize * dotScale - 2.5)
        let cX = bounds.center.x
        let cY = bounds.center.y
        
        let x = cX + r * cos(CGFloat.pi - angle * (CGFloat.pi / 180))
        let y = cY + r * sin(CGFloat.pi - angle * (CGFloat.pi / 180))
        
        points.append(CGPoint(x: x, y: y))
        
        calculatePoints(with: angle + angleStep, &points)
    }
    
    private func drawLayer(for point: CGPoint) {
        let dotOffset = dotSize / 2
        
        let sub = CALayer(layer: layer)
        sub.backgroundColor = dotColor
        sub.cornerRadius = dotOffset
        sub.masksToBounds = false
        sub.opacity = 0.0
        sub.fillMode = .forwards
        sub.frame = CGRect(x: point.x - dotOffset, y: point.y - dotOffset, width: dotSize, height: dotSize)
        
        sublayers.append(sub)

        layer.addSublayer(sub)
    }
    
    func toggleAnimation() {
        isAnimating ? stopAnimation() : startAnimation()
        
        isAnimating.toggle()
    }
    
    public func startAnimation() {
        animate(start: true)
        
        layer.add(rotation, forKey: AnimationKey.rotation.rawValue)
    }
    
    public func stopAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration * 2, execute: { [weak self] in
            self?.layer.removeAnimation(forKey: AnimationKey.rotation.rawValue)
            
            self?.sublayers.forEach({
                $0.removeAnimation(forKey: AnimationKey.scale.rawValue)
            })
        })
        
        animate(start: false)
    }
    
    private func animate(start: Bool) {
        let delay = duration / Double(points.count)
        
        for (i, sublayer) in sublayers.enumerated() {
            let executionDelay = Double(i) * delay
            
            DispatchQueue.main.asyncAfter(deadline: .now() + executionDelay, execute: { [weak self] in
                start ? self?.addAnimations(to: sublayer) : self?.removeAnimations(from: sublayer)
            })
        }
    }
    
    private func addAnimations(to sublayer: CALayer?) {
        sublayer?.removeAnimation(forKey: AnimationKey.fadeOut.rawValue)
        sublayer?.add(fadeIn, forKey: AnimationKey.fadeIn.rawValue)
        sublayer?.add(scale, forKey: AnimationKey.scale.rawValue)
    }
    
    private func removeAnimations(from sublayer: CALayer?) {
        sublayer?.removeAnimation(forKey: AnimationKey.fadeIn.rawValue)
        sublayer?.add(fadeOut, forKey: AnimationKey.fadeOut.rawValue)
    }
}
