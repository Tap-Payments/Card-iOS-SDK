//
//  ThreeDSConfiguration.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 03/12/2022.
//

import Foundation
import UIKit

/// Defines the attributes/configurations when displaying the 3DS web page
@objc public class ThreeDSConfiguration: NSObject {
    
    /// The blur background shown behind the 3DS web page overlaying the current window
    internal var backgroundBlurStyle:UIBlurEffect.Style = .dark
    /// The animation duration when in the 3DS web page
    internal var animationDuration:TimeInterval = 1
    /// The animation type when popping in the 3DS web view
    internal var threeDsAnimationType:ThreeDsWebViewAnimationEnum = .BottomTransition
    /** Defines the attributes/configurations when displaying the 3DS web page
     - Parameter backgroundBlurStyle: The blur background shown behind the 3DS web page overlaying the current window. Default is DARK
     - Parameter zoomInAnimationDuration: The animation duration when zooming in the 3DS web page. Default is 1 second
     - Parameter threeDsAnimationType : The animation type when popping in the 3DS web view
     */
    @objc public init(backgroundBlurStyle: UIBlurEffect.Style = .dark, animationDuration: TimeInterval = 1, threeDsAnimationType:ThreeDsWebViewAnimationEnum = .BottomTransition) {
        self.backgroundBlurStyle = backgroundBlurStyle
        self.animationDuration = animationDuration
        self.threeDsAnimationType = threeDsAnimationType
    }
}
