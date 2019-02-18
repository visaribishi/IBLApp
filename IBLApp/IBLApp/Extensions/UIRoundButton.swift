//
//  UIRoundButton.swift
//  IBLApp
//
//  Created by Visar on 2/18/19.
//  Copyright © 2019 Visar. All rights reserved.
//

import UIKit

@IBDesignable open class UIRoundButton: UIButton {
    
    // MARK: - Inspectable attributes
    
    @IBInspectable open var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = max( 0.0, min( newValue, min( bounds.width, bounds.height ) / 2.0 ))
            // Apply shadowPath for performance
            shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        }
    }
    
    @IBInspectable open var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable open var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    @IBInspectable open var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set { layer.shadowColor = newValue?.cgColor }
    }
    
    @IBInspectable open var shadowOpacity: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }
    
    @IBInspectable open var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    
    @IBInspectable open var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    fileprivate var shadowPath: CGPath? {
        get { return layer.shadowPath }
        set {
            layer.shadowPath = newValue
            // Mask the image view with rounded corners
            if let imageLayer = imageView?.layer {
                let maskLayer = CAShapeLayer()
                maskLayer.path = layer.shadowPath
                maskLayer.position = CGPoint(x: imageLayer.bounds.midX - layer.bounds.midX, y: imageLayer.bounds.midY - layer.bounds.midY)
                imageLayer.mask = maskLayer
            }
        }
    }
    
    @IBInspectable open var highlightedBackgroundColor: UIColor? {
        didSet {
            updateBackgroundColor()
        }
    }
    
    @IBInspectable open var selectedBackgroundColor: UIColor? {
        didSet {
            updateBackgroundColor()
        }
    }
    
    @IBInspectable open var disabledBackgroundColor: UIColor? {
        didSet {
            updateBackgroundColor()
        }
    }
    
    override open var backgroundColor: UIColor? {
        didSet {
            originalBackgroundColor = backgroundColor
        }
    }
    
    override open var isEnabled: Bool {
        didSet {
            updateBackgroundColor()
        }
    }
    
    override open var isHighlighted: Bool {
        didSet {
            updateBackgroundColor()
        }
    }
    
    override open var isSelected: Bool {
        didSet {
            updateBackgroundColor()
        }
    }
    
    override open var contentMode: UIView.ContentMode {
        didSet {
            imageView?.contentMode = contentMode
        }
    }
    
    // MARK: - Initializers
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Decode attributes
        cornerRadius = aDecoder.decodeObject(forKey: EncodingKey.cornerRadius.rawValue) as? CGFloat ?? cornerRadius
        borderWidth = aDecoder.decodeObject(forKey: EncodingKey.borderWidth.rawValue) as? CGFloat ?? borderWidth
        borderColor = aDecoder.decodeObject(forKey: EncodingKey.borderColor.rawValue) as? UIColor
        shadowColor = aDecoder.decodeObject(forKey: EncodingKey.shadowColor.rawValue) as? UIColor
        shadowOpacity = aDecoder.decodeObject(forKey: EncodingKey.shadowOpacity.rawValue) as? Float ?? shadowOpacity
        shadowOffset = aDecoder.decodeObject(forKey: EncodingKey.shadowOffset.rawValue) as? CGSize ?? shadowOffset
        shadowRadius = aDecoder.decodeObject(forKey: EncodingKey.shadowRadius.rawValue) as? CGFloat ?? shadowRadius
        highlightedBackgroundColor = aDecoder.decodeObject(forKey: EncodingKey.highlightedBackgroundColor.rawValue) as? UIColor
        selectedBackgroundColor = aDecoder.decodeObject(forKey: EncodingKey.selectedBackgroundColor.rawValue) as? UIColor
        disabledBackgroundColor = aDecoder.decodeObject(forKey: EncodingKey.disabledBackgroundColor.rawValue) as? UIColor
        setup()
    }
    
    // MARK: - Layout updates
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        // Recompute cornerRadius from bounds
        cornerRadius = max(0.0, min(cornerRadius, min(bounds.width, bounds.height) / 2.0))
        shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    // MARK: - Private
    
    fileprivate var originalBackgroundColor: UIColor!
    
    fileprivate func setup() {
        // Set the rasterization on for performances
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
        // Compute cornerRadius from bounds
        cornerRadius = max(0.0, min(cornerRadius, min(bounds.width, bounds.height) / 2.0))
        
        // Remove clipping of the main layer to show shadows
        layer.masksToBounds = false
        layer.isOpaque = false
        
        updateBackgroundColor()
        setNeedsLayout()
    }
    
    fileprivate func updateBackgroundColor() {
        let newBackgroundColor: UIColor?
        if isHighlighted, let highlightedBackgroundColor = highlightedBackgroundColor {
            newBackgroundColor = highlightedBackgroundColor
        } else if isSelected, let selectedBackgroundColor = selectedBackgroundColor {
            newBackgroundColor = selectedBackgroundColor
        } else if !isEnabled, let disabledBackgroundColor = disabledBackgroundColor {
            newBackgroundColor = disabledBackgroundColor
        } else {
            newBackgroundColor = originalBackgroundColor
        }
        super.backgroundColor = newBackgroundColor
    }
    
}

// MARK: - NSCoding

extension UIRoundButton/*: NSCoding*/ {
    
    fileprivate enum EncodingKey: String {
        case cornerRadius
        case borderWidth
        case borderColor
        case shadowColor
        case shadowOpacity
        case shadowOffset
        case shadowRadius
        case highlightedBackgroundColor
        case selectedBackgroundColor
        case disabledBackgroundColor
    }
    
    open override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(cornerRadius, forKey: EncodingKey.cornerRadius.rawValue)
        aCoder.encode(shadowOpacity, forKey: EncodingKey.shadowOpacity.rawValue)
        aCoder.encode(shadowRadius, forKey: EncodingKey.shadowRadius.rawValue)
        aCoder.encode(shadowColor, forKey: EncodingKey.shadowColor.rawValue)
        aCoder.encode(shadowOffset, forKey: EncodingKey.shadowOffset.rawValue)
        aCoder.encode(borderWidth, forKey: EncodingKey.borderWidth.rawValue)
        aCoder.encode(borderColor, forKey: EncodingKey.borderColor.rawValue)
        aCoder.encode(highlightedBackgroundColor, forKey: EncodingKey.highlightedBackgroundColor.rawValue)
        aCoder.encode(selectedBackgroundColor, forKey: EncodingKey.selectedBackgroundColor.rawValue)
        aCoder.encode(disabledBackgroundColor, forKey: EncodingKey.disabledBackgroundColor.rawValue)
    }
    
}
