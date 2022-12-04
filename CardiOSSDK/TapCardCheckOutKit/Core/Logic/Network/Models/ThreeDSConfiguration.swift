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
    /// The animation duration when zooming in the 3DS web page
    internal var zoomInAnimationDuration:TimeInterval = 1
    
    /** Defines the attributes/configurations when displaying the 3DS web page
     - Parameter backgroundBlurStyle: The blur background shown behind the 3DS web page overlaying the current window. Default is DARK
     - Parameter zoomInAnimationDuration: The animation duration when zooming in the 3DS web page. Default is 1 second
     */
    @objc public init(backgroundBlurStyle: UIBlurEffect.Style = .dark, zoomInAnimationDuration: TimeInterval = 1) {
        self.backgroundBlurStyle = backgroundBlurStyle
        self.zoomInAnimationDuration = zoomInAnimationDuration
    }
}
