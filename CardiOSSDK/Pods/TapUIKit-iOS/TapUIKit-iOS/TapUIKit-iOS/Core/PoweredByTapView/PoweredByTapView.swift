//
//  PoweredByTapView.swift
//  TapUIKit-iOS
//
//  Created by Osama Rabie on 29/09/2022.
//

import UIKit
import TapThemeManager2020
import LocalisationManagerKit_iOS

/// Represents the power by tap view
@objc public class PoweredByTapView: UIView {
    /// Represents the main holding view
    @IBOutlet weak var cardBlur: CardVisualEffectView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet public weak var poweredByTapLogo: UIImageView!
    internal let themePath:String = "poweredByTap"
    // Mark:- Init methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    /// Used as a consolidated method to do all the needed steps upon creating the view
    private func commonInit() {
        self.containerView = setupXIB()
        applyTheme()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.frame = bounds
    }
}




// Mark:- Theme methods
extension PoweredByTapView {
    /// Consolidated one point to apply all needed theme methods
    public func applyTheme() {
        matchThemeAttributes()
    }
    
    /// Match the UI attributes with the correct theming entries
    private func matchThemeAttributes() {
        poweredByTapLogo.image = TapThemeManager.imageValue(for: "\(themePath).tapLogo")
        //blurView.tap_theme_backgroundColor = .init(stringLiteral: "\(themePath).blurColor")
        poweredByTapLogo.contentMode = TapLocalisationManager.shared.localisationLocale == "ar" ? .left : .right
        backgroundColor = .clear
        layoutIfNeeded()
        
        cardBlur.scale = 1
        cardBlur.blurRadius = 6
        cardBlur.colorTint = TapThemeManager.colorValue(for: "\(themePath).blurColor")
        cardBlur.colorTintAlpha = CGFloat(TapThemeManager.numberValue(for: "\(themePath).blurAlpha")?.floatValue ?? 0)
    }
    
    /// Listen to light/dark mde changes and apply the correct theme based on the new style
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        TapThemeManager.changeThemeDisplay(for: self.traitCollection.userInterfaceStyle)
        applyTheme()
    }
}
