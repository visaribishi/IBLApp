//
//  UIGradientView.swift
//  IBLApp
//
//  Created by Visar on 2/18/19.
//  Copyright © 2019 Visar. All rights reserved.
//

import UIKit

private enum EncodingKey: String {
    case startColor
    case endColor
}

protocol Gradientable: class {
    
    var startColor: UIColor? { get set }
    var endColor: UIColor? { get set }
    
    var gradientLayer: CAGradientLayer! { get set }
    
    // From UIView
    var bounds: CGRect { get }
    var layer: CALayer { get }
    
}

extension Gradientable {
    
    fileprivate func setupGradient() {
        gradientLayer?.removeFromSuperlayer()
        guard let startColor = startColor, let endColor = endColor else {
            return
        }
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [ startColor.cgColor, endColor.cgColor ]
        gradientLayer.cornerRadius = layer.cornerRadius
        gradientLayer.masksToBounds = layer.cornerRadius > 0.0
        gradientLayer.borderColor = layer.borderColor
        gradientLayer.borderWidth = layer.borderWidth
        gradientLayer.transform = CATransform3DIdentity
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
}

extension UIGradientView: Gradientable { }

@IBDesignable open class UIGradientView: UIView {
    
    // MARK: - Inspectable attributes
    
    @IBInspectable var startColor: UIColor? = UIColor.clear {
        didSet { setupGradient() }
    }
    
    @IBInspectable var endColor: UIColor? = UIColor.clear {
        didSet { setupGradient() }
    }
    
    @IBInspectable var isVertical: Bool = true {
        didSet { setupGradient() }
    }
    
    // MARK: - Initializers
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        startColor = aDecoder.decodeObject(forKey: EncodingKey.startColor.rawValue) as? UIColor ?? UIColor.clear
        endColor = aDecoder.decodeObject(forKey: EncodingKey.endColor.rawValue) as? UIColor ?? UIColor.clear
    }
    
    // MARK: - Layout updates
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
    }
    
    // MARK: - Private
    
    internal var gradientLayer: CAGradientLayer!
    
}

// MARK: - NSCoding

extension UIGradientView/*: NSCoding*/ {
    
    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(startColor, forKey: EncodingKey.startColor.rawValue)
        aCoder.encode(endColor, forKey: EncodingKey.endColor.rawValue)
    }
    
}
