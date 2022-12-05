//
//  ThreeDsWebViewAnimationEnum.swift
//  TapCardCheckOutKit
//
//  Created by Osama Rabie on 05/12/2022.
//

import Foundation

/// Defines the animation to be used when showing the web view for approving the payment
@objc public enum ThreeDsWebViewAnimationEnum:Int, CaseIterable {
    
    /// Zoom in animation
    @objc(ZoomIn) case ZoomIn
    /// Bottom Transition animation
    @objc(BottomTransition) case BottomTransition
    
    public func toString() -> String {
        switch self {
            
        case .ZoomIn:
            return "Zoom in"
        case .BottomTransition:
            return "Bottom modal"
        }
    }
}
