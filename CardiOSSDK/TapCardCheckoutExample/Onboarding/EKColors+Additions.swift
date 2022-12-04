//
//  EKColors+Additions.swift
//  TapCardCheckoutExample
//
//  Created by Osama Rabie on 02/12/2022.
//

import UIKit
import SwiftEntryKit


struct Color {
    struct BlueGray {
        static let c50 = EKColor(rgb: 0xeceff1)
        static let c100 = EKColor(rgb: 0xcfd8dc)
        static let c300 = EKColor(rgb: 0x90a4ae)
        static let c400 = EKColor(rgb: 0x78909c)
        static let c700 = EKColor(rgb: 0x455a64)
        static let c800 = EKColor(rgb: 0x37474f)
        static let c900 = EKColor(rgb: 0x263238)
    }
    
    struct Netflix {
        static let light = EKColor(rgb: 0x485563)
        static let dark = EKColor(rgb: 0x29323c)
    }
    
    struct Gray {
        static let a800 = EKColor(rgb: 0x424242)
        static let mid = EKColor(rgb: 0x616161)
        static let light = EKColor(red: 230, green: 230, blue: 230)
    }
    
    struct Purple {
        static let a300 = EKColor(rgb: 0xba68c8)
        static let a400 = EKColor(rgb: 0xab47bc)
        static let a700 = EKColor(rgb: 0xaa00ff)
        static let deep = EKColor(rgb: 0x673ab7)
    }
    
    struct BlueGradient {
        static let light = EKColor(red: 100, green: 172, blue: 196)
        static let dark = EKColor(red: 27, green: 47, blue: 144)
    }
    
    struct Yellow {
        static let a700 = EKColor(rgb: 0xffd600)
    }
    
    struct Teal {
        static let a700 = EKColor(rgb: 0x00bfa5)
        static let a600 = EKColor(rgb: 0x00897b)
    }
    
    struct Orange {
        static let a50 = EKColor(rgb: 0xfff3e0)
    }
    
    struct LightBlue {
        static let a700 = EKColor(rgb: 0x0091ea)
    }
    
    struct LightPink {
        static let first = EKColor(rgb: 0xff9a9e)
        static let last = EKColor(rgb: 0xfad0c4)
    }
}



extension EKColor {
    
    static var segmentedControlTint: EKColor {
        return EKColor(.gray)
    }
    
    static var navigationItemColor: EKColor {
        return EKColor(light: .gray,
                       dark: .musicRedish)
    }
    
    static var navigationBackgroundColor: EKColor {
        return EKColor(light: .lightNavigationBarBackground,
                       dark: .black)
    }
    
    static var headerBackground: EKColor {
        return EKColor(light: Color.BlueGray.c50.with(alpha: 0.95).light,
                       dark: .darkHeaderBackground)
    }
    
    static var headerText: EKColor {
        return EKColor(.white).with(alpha: 0.95)
    }
    
    static var satCyan: EKColor {
        return EKColor(.satCyan)
    }
    
    static var amber: EKColor {
        return EKColor(.amber)
    }
    
    static var pinky: EKColor {
        return EKColor(.pinky)
    }
    
    static var greenGrass: EKColor {
        return EKColor(.greenGrass)
    }
    
    static var redish: EKColor {
        return EKColor(.redish)
    }
    
    static var ratingStar: EKColor {
        return EKColor(light: .amber,
                       dark: .musicRedish)
    }
    
    static var musicBackground: EKColor {
        return EKColor(light: .white,
                       dark: .musicBackgroundDark)
    }
    
    static var musicText: EKColor {
        return EKColor(light: .black,
                       dark: .musicRedish)
    }
    
    static var selectedBackground: EKColor {
        return EKColor(light: UIColor(white: 0.9, alpha: 1),
                       dark: UIColor(white: 0.1, alpha: 1))
    }
    
    static var dimmedDarkBackground: EKColor {
        return EKColor(light: .dimmedDarkBackground,
                       dark: .dimmedDarkestBackground)
    }
    
    static var dimmedLightBackground: EKColor {
        return EKColor(light: .dimmedLightBackground,
                       dark: .dimmedDarkestBackground)
    }
    
    static var chatMessage: EKColor {
        return EKColor(light: .chatMessageLightMode,
                       dark: .chatMessageLightMode)
    }
    
    static var text: EKColor {
        return EKColor(light: .textLightMode,
                       dark: .textDarkMode)
    }
    
    static var subText: EKColor {
        return EKColor(light: .subTextLightMode,
                       dark: .subTextDarkMode)
    }
}


extension UIColor {
    static func by(r: Int, g: Int, b: Int, a: CGFloat = 1) -> UIColor {
        let d = CGFloat(255)
        return UIColor(red: CGFloat(r) / d, green: CGFloat(g) / d, blue: CGFloat(b) / d, alpha: a)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    var ekColor: EKColor {
        return EKColor(self)
    }
    
    static let dimmedLightBackground = UIColor(white: 100.0/255.0, alpha: 0.3)
    static let dimmedDarkBackground = UIColor(white: 50.0/255.0, alpha: 0.3)
    static let dimmedDarkestBackground = UIColor(white: 0, alpha: 0.5)
    
    static let pinky = UIColor(rgb: 0xE91E63)
    static let amber = UIColor(rgb: 0xFFC107)
    static let satCyan = UIColor(rgb: 0x00BCD4)
    static let redish = UIColor(rgb: 0xFF5252)
    static let greenGrass = UIColor(rgb: 0x4CAF50)
    
    static let chatMessageLightMode = UIColor(red: 48, green: 47, blue: 48)
    static let chatMessageDarkMode = UIColor(red: 207, green: 208, blue: 207)
    
    static let textLightMode = UIColor(red: 33, green: 33, blue: 33)
    static let textDarkMode = UIColor(red: 222, green: 222, blue: 222)
    
    static let subTextLightMode = UIColor(red: 117, green: 117, blue: 117)
    static let subTextDarkMode = UIColor(red: 138, green: 138, blue: 138)
    
    static let musicBackgroundDark = UIColor(red: 36, green: 39, blue: 42)
    static let musicRedish = UIColor(red: 219, green: 58, blue: 94)
    
    static let lightNavigationBarBackground = UIColor(red: 251, green: 251, blue: 253)
    
    static let darkHeaderBackground = UIColor(red: 25, green: 26, blue: 25)
    
    static let darkSegmentedControl = UIColor(red: 55, green: 71, blue: 79)
}




struct TextFieldOptionSet: OptionSet {
    let rawValue: Int
    static let fullName = TextFieldOptionSet(rawValue: 1 << 0)
    static let mobile = TextFieldOptionSet(rawValue: 1 << 1)
    static let email = TextFieldOptionSet(rawValue: 1 << 2)
    static let password = TextFieldOptionSet(rawValue: 1 << 3)
    static let bundleID = TextFieldOptionSet(rawValue: 1 << 4)
    static let sandboxKey = TextFieldOptionSet(rawValue: 1 << 5)
    static let productionKey = TextFieldOptionSet(rawValue: 1 << 6)
}

enum FormStyle {
    case light
    case metallic
    
    var buttonTitle: EKProperty.LabelStyle {
        return .init(
            font: .systemFont(ofSize: 15, weight: .bold),
            color: buttonTitleColor
        )
    }
    
    var textColor: EKColor {
        switch self {
        case .metallic:
            return .white
        case .light:
            return .standardContent
        }
    }
    
    var buttonTitleColor: EKColor {
        switch self {
        case .metallic:
            return .black
        case .light:
            return .white
        }
    }
    
    var buttonBackground: EKColor {
        switch self {
        case .metallic:
            return .white
        case .light:
            return .redish
        }
    }
    
    var placeholder: EKProperty.LabelStyle {
        let font:UIFont = .systemFont(ofSize: 14, weight: .light)
        switch self {
        case .metallic:
            return .init(font: font, color: UIColor(white: 0.8, alpha: 1).ekColor)
        case .light:
            return .init(font: font, color: UIColor(white: 0.5, alpha: 1).ekColor)
        }
    }
    
    var separator: EKColor {
        return UIColor(white: 0.8784, alpha: 0.6).ekColor
    }
}

final class FormFieldPresetFactory {
    
    private static var displayMode: EKAttributes.DisplayMode {
        return .inferred
    }
    
    class func email(placeholderStyle: EKProperty.LabelStyle,
                     textStyle: EKProperty.LabelStyle,
                     separatorColor: EKColor,
                     style: FormStyle) -> EKProperty.TextFieldContent {
        let emailPlaceholder = EKProperty.LabelContent(
            text: "Email Address",
            style: placeholderStyle
        )
        return .init(keyboardType: .emailAddress,
                     placeholder: emailPlaceholder,
                     tintColor: style.textColor,
                     displayMode: displayMode,
                     textStyle: textStyle,
                     leadingImage: UIImage(named: "ic_mail_light")!.withRenderingMode(.alwaysTemplate),
                     bottomBorderColor: separatorColor,
                     accessibilityIdentifier: "emailTextField")
    }
    
    class func fullName(placeholderStyle: EKProperty.LabelStyle,
                        textStyle: EKProperty.LabelStyle,
                        separatorColor: EKColor,
                        style: FormStyle) -> EKProperty.TextFieldContent {
        let fullNamePlaceholder = EKProperty.LabelContent(
            text: "Full Name",
            style: placeholderStyle
        )
        return .init(keyboardType: .namePhonePad,
                     placeholder: fullNamePlaceholder,
                     tintColor: style.textColor,
                     displayMode: displayMode,
                     textStyle: textStyle,
                     leadingImage: UIImage(named: "ic_user_light")!.withRenderingMode(.alwaysTemplate),
                     bottomBorderColor: separatorColor,
                     accessibilityIdentifier: "nameTextField")
    }
    
    class func bundleID(placeholderStyle: EKProperty.LabelStyle,
                        textStyle: EKProperty.LabelStyle,
                        separatorColor: EKColor,
                        style: FormStyle) -> EKProperty.TextFieldContent {
        let bundleIDPlaceholder = EKProperty.LabelContent(
            text: "Bundle ID",
            style: placeholderStyle
        )
        return .init(keyboardType: .namePhonePad,
                     placeholder: bundleIDPlaceholder,
                     tintColor: style.textColor,
                     displayMode: displayMode,
                     textStyle: textStyle,
                     leadingImage: UIImage(named: "bundleID")!.withRenderingMode(.alwaysTemplate),
                     bottomBorderColor: separatorColor,
                     accessibilityIdentifier: "nameTextField")
    }
    
    
    class func sandboxKey(placeholderStyle: EKProperty.LabelStyle,
                        textStyle: EKProperty.LabelStyle,
                        separatorColor: EKColor,
                        style: FormStyle) -> EKProperty.TextFieldContent {
        let sandBoxPlaceholder = EKProperty.LabelContent(
            text: "Sandbox key",
            style: placeholderStyle
        )
        return .init(keyboardType: .namePhonePad,
                     placeholder: sandBoxPlaceholder,
                     tintColor: style.textColor,
                     displayMode: displayMode,
                     textStyle: textStyle,
                     leadingImage: UIImage(named: "ic_lock_light")!.withRenderingMode(.alwaysTemplate),
                     bottomBorderColor: separatorColor,
                     accessibilityIdentifier: "nameTextField")
    }
    
    
    class func productionKey(placeholderStyle: EKProperty.LabelStyle,
                        textStyle: EKProperty.LabelStyle,
                        separatorColor: EKColor,
                        style: FormStyle) -> EKProperty.TextFieldContent {
        let productionKeyPlaceholder = EKProperty.LabelContent(
            text: "Production key",
            style: placeholderStyle
        )
        return .init(keyboardType: .namePhonePad,
                     placeholder: productionKeyPlaceholder,
                     tintColor: style.textColor,
                     displayMode: displayMode,
                     textStyle: textStyle,
                     leadingImage: UIImage(named: "ic_lock_light")!.withRenderingMode(.alwaysTemplate),
                     bottomBorderColor: separatorColor,
                     accessibilityIdentifier: "nameTextField")
    }
    
    class func mobile(placeholderStyle: EKProperty.LabelStyle,
                      textStyle: EKProperty.LabelStyle,
                      separatorColor: EKColor,
                      style: FormStyle) -> EKProperty.TextFieldContent {
        let mobilePlaceholder = EKProperty.LabelContent(
            text: "Mobile Phone",
            style: placeholderStyle
        )
        return .init(keyboardType: .decimalPad,
                     placeholder: mobilePlaceholder,
                     tintColor: style.textColor,
                     displayMode: displayMode,
                     textStyle: textStyle,
                     leadingImage: UIImage(named: "ic_phone_light")!.withRenderingMode(.alwaysTemplate),
                     bottomBorderColor: separatorColor,
                     accessibilityIdentifier: "mobilePhoneTextField")
    }
    
    class func password(placeholderStyle: EKProperty.LabelStyle,
                        textStyle: EKProperty.LabelStyle,
                        separatorColor: EKColor,
                        style: FormStyle) -> EKProperty.TextFieldContent {
        let passwordPlaceholder = EKProperty.LabelContent(text: "Password",
                                                          style: placeholderStyle)
        return .init(keyboardType: .namePhonePad,
                     placeholder: passwordPlaceholder,
                     tintColor: style.textColor,
                     displayMode: displayMode,
                     textStyle: textStyle,
                     isSecure: true,
                     leadingImage: UIImage(named: "ic_lock_light")!.withRenderingMode(.alwaysTemplate),
                     bottomBorderColor: separatorColor,
                     accessibilityIdentifier: "passwordTextField")
    }
    
    class func fields(by set: TextFieldOptionSet,
                      style: FormStyle) -> [EKProperty.TextFieldContent] {
        var array: [EKProperty.TextFieldContent] = []
        let placeholderStyle = style.placeholder
        let textStyle = EKProperty.LabelStyle(
            font: .systemFont(ofSize: 14, weight: .light),
            color: .standardContent,
            displayMode: displayMode
        )
        let separatorColor = style.separator
        if set.contains(.fullName) {
            array.append(fullName(placeholderStyle: placeholderStyle,
                                  textStyle: textStyle,
                                  separatorColor: separatorColor,
                                  style: style))
        }
        if set.contains(.bundleID) {
            array.append(bundleID(placeholderStyle: placeholderStyle,
                                  textStyle: textStyle,
                                  separatorColor: separatorColor,
                                  style: style))
        }
        if set.contains(.productionKey) {
            array.append(productionKey(placeholderStyle: placeholderStyle,
                                  textStyle: textStyle,
                                  separatorColor: separatorColor,
                                  style: style))
        }
        if set.contains(.sandboxKey) {
            array.append(sandboxKey(placeholderStyle: placeholderStyle,
                                  textStyle: textStyle,
                                  separatorColor: separatorColor,
                                  style: style))
        }
        if set.contains(.mobile) {
            array.append(mobile(placeholderStyle: placeholderStyle,
                                textStyle: textStyle,
                                separatorColor: separatorColor,
                                style: style))
        }
        if set.contains(.email) {
            array.append(email(placeholderStyle: placeholderStyle,
                               textStyle: textStyle,
                               separatorColor: separatorColor,
                               style: style))
        }
        if set.contains(.password) {
            array.append(password(placeholderStyle: placeholderStyle,
                                  textStyle: textStyle,
                                  separatorColor: separatorColor,
                                  style: style))
        }
        return array
    }
}
