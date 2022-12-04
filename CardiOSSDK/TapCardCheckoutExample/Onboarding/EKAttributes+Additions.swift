//
//  EKAttributes+Additions.swift
//  TapCardCheckoutExample
//
//  Created by Osama Rabie on 02/12/2022.
//

import UIKit
import SwiftEntryKit


class EntriesAttributes {
    
    
    static func centeralPopUpAttributes() -> EKAttributes {
        var attributes: EKAttributes
        let displayMode:EKAttributes.DisplayMode = .inferred
        let minEdge = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
        
        
        attributes = .centerFloat
        attributes.displayMode = displayMode
        attributes.windowLevel = .alerts
        attributes.displayDuration = .infinity
        attributes.hapticFeedbackType = .success
        attributes.screenInteraction = .absorbTouches
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .disabled
        attributes.screenBackground = .color(color: .dimmedDarkBackground)
        attributes.entryBackground = .color(color: .musicBackground)
        
        attributes.entranceAnimation = .init(
            scale: .init(
                from: 0.9,
                to: 1,
                duration: 0.4,
                spring: .init(damping: 1, initialVelocity: 0)
            ),
            fade: .init(
                from: 0,
                to: 1,
                duration: 0.3
            )
        )
        attributes.exitAnimation = .init(
            fade: .init(
                from: 1,
                to: 0,
                duration: 0.2
            )
        )
        attributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.3,
                radius: 5
            )
        )
        attributes.positionConstraints.maxSize = .init(
            width: .constant(value: minEdge),
            height: .intrinsic
        )
        
        return attributes
        
    }
    
    
    static func customLoadingAttributes() -> EKAttributes {
        var attributes: EKAttributes
        let displayMode:EKAttributes.DisplayMode = .inferred
        
        attributes = .topNote
        attributes.displayMode = displayMode
        attributes.hapticFeedbackType = .success
        attributes.displayDuration = .infinity
        attributes.popBehavior = .animated(animation: .translation)
        attributes.entryBackground = .color(color: Color.BlueGradient.dark)
        attributes.statusBar = .light
        
        return attributes
    }
    
    static func customControllerAttributes() -> EKAttributes {
        var attributes: EKAttributes
        let displayMode:EKAttributes.DisplayMode = .inferred
        
        attributes = .bottomFloat
        attributes.displayMode = displayMode
        attributes.displayDuration = .infinity
        attributes.screenBackground = .color(color: .dimmedLightBackground)
        attributes.entryBackground = .color(color: .white)
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .edgeCrossingDisabled(swipeable: true)
        attributes.entranceAnimation = .init(
            translate: .init(
                duration: 0.5,
                spring: .init(damping: 1, initialVelocity: 0)
            )
        )
        attributes.exitAnimation = .init(
            translate: .init(duration: 0.35)
        )
        attributes.popBehavior = .animated(
            animation: .init(
                translate: .init(duration: 0.35)
            )
        )
        attributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.3,
                radius: 6
            )
        )
        attributes.positionConstraints.size = .init(
            width: .fill,
            height: .ratio(value: 0.6)
        )
        attributes.positionConstraints.verticalOffset = 0
        attributes.positionConstraints.safeArea = .overridden
        attributes.statusBar = .dark
        
        return attributes
    }
    
    static func topFloatPopupAttributes() -> EKAttributes {
        var attributes: EKAttributes
        let displayMode:EKAttributes.DisplayMode = .inferred
        let minEdge = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
        
        // Preset I
        attributes = .topFloat
        attributes.displayMode = displayMode
        attributes.hapticFeedbackType = .success
        attributes.entryBackground = .gradient(
            gradient: .init(
                colors: [Color.BlueGradient.dark, Color.BlueGradient.light],
                startPoint: .zero,
                endPoint: CGPoint(x: 1, y: 1)
            )
        )
        attributes.popBehavior = .animated(
            animation: .init(
                translate: .init(duration: 0.3),
                scale: .init(from: 1, to: 0.7, duration: 0.7)
            )
        )
        attributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.5,
                radius: 10
            )
        )
        attributes.statusBar = .dark
        attributes.scroll = .enabled(
            swipeable: true,
            pullbackAnimation: .easeOut
        )
        attributes.positionConstraints.maxSize = .init(
            width: .constant(value: minEdge),
            height: .intrinsic
        )
        
        return attributes
    }
    
    static func centeralFormAttributes() -> EKAttributes {
        var attributes:EKAttributes
        let displayMode:EKAttributes.DisplayMode = .inferred
        let minEdge = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
        
        attributes = .float
        attributes.displayMode = displayMode
        attributes.windowLevel = .normal
        attributes.position = .center
        attributes.displayDuration = .infinity
        attributes.entranceAnimation = .init(
            translate: .init(
                duration: 0.65,
                anchorPosition: .bottom,
                spring: .init(damping: 1, initialVelocity: 0)
            )
        )
        attributes.exitAnimation = .init(
            translate: .init(
                duration: 0.65,
                anchorPosition: .top,
                spring: .init(damping: 1, initialVelocity: 0)
            )
        )
        attributes.popBehavior = .animated(
            animation: .init(
                translate: .init(
                    duration: 0.65,
                    spring: .init(damping: 1, initialVelocity: 0)
                )
            )
        )
        attributes.entryInteraction = .absorbTouches
        attributes.screenInteraction = .dismiss
        attributes.entryBackground = .color(color: .standardBackground)
        attributes.screenBackground = .color(color: .dimmedDarkBackground)
        attributes.border = .value(
            color: UIColor(white: 0.6, alpha: 1),
            width: 1
        )
        attributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.3,
                radius: 3
            )
        )
        attributes.scroll = .enabled(
            swipeable: false,
            pullbackAnimation: .jolt
        )
        attributes.statusBar = .light
        attributes.positionConstraints.keyboardRelation = .bind(
            offset: .init(
                bottom: 15,
                screenEdgeResistance: 0
            )
        )
        attributes.positionConstraints.maxSize = .init(
            width: .constant(value: minEdge),
            height: .intrinsic
        )
        
        return attributes
    }
    
}
