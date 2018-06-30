//
//  Zap
//
//  Created by Otto Suess on 26.03.18.
//  Copyright © 2018 Otto Suess. All rights reserved.
//

import UIKit

final class GradientView: UIView {
    enum Direction {
        case horizontal
        case diagonal
    }
    
    var direction: Direction = .horizontal {
        didSet {
            updateDirection()
        }
    }
    
    var gradient: [UIColor] = [UIColor.zap.lightMustard, UIColor.zap.peach] {
        didSet {
            updateColors()
        }
    }
    
    var gradientLayer: CAGradientLayer?
    
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let gradientLayer = layer as? CAGradientLayer
        self.gradientLayer = gradientLayer
        updateColors()
        updateDirection()
    }
    
    private func updateColors() {
        gradientLayer?.colors = gradient.map { $0.cgColor }
    }
    
    private func updateDirection() {
        switch direction {
        case .horizontal:
            gradientLayer?.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer?.endPoint = CGPoint(x: 1.0, y: 1.0)
        case .diagonal:
            gradientLayer?.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer?.endPoint = CGPoint(x: 1.0, y: 1.0)
        }
    }
}