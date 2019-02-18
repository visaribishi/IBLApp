//
//  UIExtendedView.swift
//  IBLApp
//
//  Created by Visar on 2/18/19.
//  Copyright © 2019 Visar. All rights reserved.
//

import UIKit

@IBDesignable open class UIExtendedView: UIView {
    
    @IBInspectable open var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = max( 0.0, min( newValue, min( bounds.width, bounds.height ) / 2.0 ))
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    @IBInspectable public var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set { layer.shadowColor = newValue?.cgColor }
    }
    
    @IBInspectable public var shadowOpacity: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }
    
    @IBInspectable public var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    
    @IBInspectable public var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    fileprivate var shadowPath: CGPath? {
        get { return layer.shadowPath }
        set { layer.shadowPath = newValue }
    }
    
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Decode attributes
        cornerRadius = CGFloat(aDecoder.decodeFloat(forKey: EncodingKey.cornerRadius.rawValue))
        shadowOpacity = aDecoder.decodeFloat(forKey: EncodingKey.shadowOpacity.rawValue)
        shadowRadius = CGFloat(aDecoder.decodeFloat(forKey: EncodingKey.shadowRadius.rawValue))
        shadowColor = aDecoder.decodeObject(forKey: EncodingKey.shadowColor.rawValue) as? UIColor
        shadowOffset = aDecoder.decodeCGSize(forKey: EncodingKey.shadowOffset.rawValue)
        borderWidth = CGFloat(aDecoder.decodeFloat(forKey: EncodingKey.borderWidth.rawValue))
        borderColor = aDecoder.decodeObject(forKey: EncodingKey.borderColor.rawValue) as? UIColor
    }
    
    // MARK: - Layout updates
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        cornerRadius = max(0.0, min(cornerRadius, min(bounds.width, bounds.height) / 2.0))
        shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }
    
}

// MARK: - NSCoding

extension UIExtendedView/*: NSCoding*/ {
    
    fileprivate enum EncodingKey: String {
        case cornerRadius
        case borderWidth
        case borderColor
        case shadowColor
        case shadowOpacity
        case shadowOffset
        case shadowRadius
    }
    
    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(Float(cornerRadius), forKey: EncodingKey.cornerRadius.rawValue)
        aCoder.encode(shadowOpacity, forKey: EncodingKey.shadowOpacity.rawValue)
        aCoder.encode(Float(shadowRadius), forKey: EncodingKey.shadowRadius.rawValue)
        aCoder.encode(shadowColor, forKey: EncodingKey.shadowColor.rawValue)
        aCoder.encode(shadowOffset, forKey: EncodingKey.shadowOffset.rawValue)
        aCoder.encode(Float(borderWidth), forKey: EncodingKey.borderWidth.rawValue)
        aCoder.encode(borderColor, forKey: EncodingKey.borderColor.rawValue)
    }
    
}

