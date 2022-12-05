//
//  IntroViewController.swift
//  TapCardCheckoutExample
//
//  Created by Osama Rabie on 02/12/2022.
//

import UIKit
import SwiftyGif
import SwiftEntryKit

class IntroViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var animatedBGImageView: UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let gif = try! UIImage(gifName: "giphy4.gif")
        animatedBGImageView.setGifImage(gif, loopCount: -1) // Will loop forever
        // Do any additional setup after loading the view.
        animatedBGImageView.addBackgroundPxEffect(strength: .Low)
        titleLabel.addMiddlegroundPxEffect(strength: .High)
        startButton.addForegroundPxEffect(strength: .High)
    }
    
    @IBAction func startTheJournyClicked(_ sender: Any) {
        showTestingOrClientCredentials(attributes: EntriesAttributes.centeralPopUpAttributes())
        
    }
    
    
    func showTestingOrClientCredentials(attributes: EKAttributes) {
        
        let displayMode:EKAttributes.DisplayMode = .inferred
        
            let title = EKProperty.LabelContent(
                text: "You are in safe hands 🥷",
                style: .init(
                    font: .systemFont(ofSize: 15, weight: .medium),
                    color: .black,
                    alignment: .center,
                    displayMode: displayMode
                )
            )
            let text =
        """
        Which keys do you want to use?
        """
            let description = EKProperty.LabelContent(
                text: text,
                style: .init(
                    font: .systemFont(ofSize: 13, weight: .light),
                    color: .black,
                    alignment: .center,
                    displayMode: displayMode
                )
            )
            let image = EKProperty.ImageContent(
                imageName: "tap_logo.pdf",
                displayMode: displayMode,
                size: CGSize(width: 35, height: 55),
                contentMode: .scaleAspectFit,
                tint: .black
            )
            let simpleMessage = EKSimpleMessage(
                image: image,
                title: title,
                description: description
            )
        let buttonFont:UIFont = .systemFont(ofSize: 16, weight: .medium)
            let closeButtonLabelStyle = EKProperty.LabelStyle(
                font: buttonFont,
                color: Color.Gray.a800,
                displayMode: displayMode
            )
            let closeButtonLabel = EKProperty.LabelContent(
                text: "NOT NOW",
                style: closeButtonLabelStyle
            )
            let closeButton = EKProperty.ButtonContent(
                label: closeButtonLabel,
                backgroundColor: .clear,
                highlightedBackgroundColor: Color.Gray.a800.with(alpha: 0.05),
                displayMode: displayMode) {
                    SwiftEntryKit.dismiss()
                }
            let myKeysButtonLabelStyle = EKProperty.LabelStyle(
                font: buttonFont,
                color: Color.Teal.a600,
                displayMode: displayMode
            )
            let myKeysButtonLabel = EKProperty.LabelContent(
                text: "My Keys",
                style: myKeysButtonLabelStyle
            )
            let myKeysButton = EKProperty.ButtonContent(
                label: myKeysButtonLabel,
                backgroundColor: .clear,
                highlightedBackgroundColor: Color.Teal.a600.with(alpha: 0.05),
                displayMode: displayMode) {
                    SwiftEntryKit.dismiss(with:{ [weak self] in
                        self?.startWithMyKeys(attributes: attributes)
                    })
                }
            let testingKeysButtonLabelStyle = EKProperty.LabelStyle(
                font: buttonFont,
                color: Color.Teal.a600,
                displayMode: displayMode
            )
            let testingKeysButtonLabel = EKProperty.LabelContent(
                text: "Testing Keys",
                style: testingKeysButtonLabelStyle
            )
            let testingKeysButton = EKProperty.ButtonContent(
                label: testingKeysButtonLabel,
                backgroundColor: .clear,
                highlightedBackgroundColor: Color.Teal.a600.with(alpha: 0.05),
                displayMode: displayMode) {
                    SwiftEntryKit.dismiss(with:{ [weak self] in
                        self?.startWithSandBoxKeys(attributes: attributes)
                    })
                }
            // Generate the content
            let buttonsBarContent = EKProperty.ButtonBarContent(
                with: testingKeysButton, myKeysButton, closeButton,
                separatorColor: Color.Gray.light,
                displayMode: displayMode,
                expandAnimatedly: true
            )
            let alertMessage = EKAlertMessage(
                simpleMessage: simpleMessage,
                buttonBarContent: buttonsBarContent
            )
            let contentView = EKAlertMessageView(with: alertMessage)
            SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    
    func startWithMyKeys(attributes: EKAttributes) {
        let displayMode:EKAttributes.DisplayMode = .inferred
        
        let title = EKProperty.LabelContent(
            text: "Are you a Tap's client 🥷?",
            style: .init(
                font: .systemFont(ofSize: 15, weight: .medium),
                color: .black,
                alignment: .center,
                displayMode: displayMode
            )
        )
        let text =
        """
        Did you reigester an account with us and receive your keys?\nPS: We won't be overdoing it, when we say we are the easiest to integrate with in the region 🤷‍♂️
        """
        let description = EKProperty.LabelContent(
            text: text,
            style: .init(
                font: .systemFont(ofSize: 13, weight: .light),
                color: .black,
                alignment: .center,
                displayMode: displayMode
            )
        )
        let image = EKProperty.ImageContent(
            imageName: "tap_logo.pdf",
            displayMode: displayMode,
            size: CGSize(width: 35, height: 55),
            contentMode: .scaleAspectFit,
            tint: .black
        )
        let simpleMessage = EKSimpleMessage(
            image: image,
            title: title,
            description: description
        )
        let buttonFont:UIFont = .systemFont(ofSize: 16, weight: .medium)
        
        
        let reigtserButtonLabelStyle = EKProperty.LabelStyle(
            font: buttonFont,
            color: Color.Teal.a600,
            displayMode: displayMode
        )
        let reigtserButtonLabel = EKProperty.LabelContent(
            text: "Register me!",
            style: reigtserButtonLabelStyle
        )
        let reigtserButton = EKProperty.ButtonContent(
            label: reigtserButtonLabel,
            backgroundColor: .clear,
            highlightedBackgroundColor: Color.Teal.a600.with(alpha: 0.05),
            displayMode: displayMode) {
                SwiftEntryKit.dismiss(with:{
                    DispatchQueue.main.async {
                        UIApplication.shared.open(URL(string: "https://www.tap.company?openChat=true")!)
                    }
                })
            }
        let reigtseredButtonLabelStyle = EKProperty.LabelStyle(
            font: buttonFont,
            color: Color.Teal.a600,
            displayMode: displayMode
        )
        let reigtseredButtonLabel = EKProperty.LabelContent(
            text: "Already did 👏",
            style: reigtseredButtonLabelStyle
        )
        let reigtseredButton = EKProperty.ButtonContent(
            label: reigtseredButtonLabel,
            backgroundColor: .clear,
            highlightedBackgroundColor: Color.Teal.a600.with(alpha: 0.05),
            displayMode: displayMode) {
                SwiftEntryKit.dismiss(with:{ [weak self] in
                    self?.collectKeys(attributes: EntriesAttributes.centeralFormAttributes())
                })
            }
        // Generate the content
        let buttonsBarContent = EKProperty.ButtonBarContent(
            with: reigtseredButton, reigtserButton,
            separatorColor: Color.Gray.light,
            displayMode: displayMode,
            expandAnimatedly: true
        )
        let alertMessage = EKAlertMessage(
            simpleMessage: simpleMessage,
            buttonBarContent: buttonsBarContent
        )
        let contentView = EKAlertMessageView(with: alertMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    
    func collectKeys(attributes: EKAttributes) {
        let style:FormStyle = .light
        let displayMode:EKAttributes.DisplayMode = .inferred
        
        let titleStyle = EKProperty.LabelStyle(
            font: .systemFont(ofSize: 14, weight: .light),
            color: style.textColor,
            displayMode: displayMode
        )
        let title = EKProperty.LabelContent(
            text: "Fill your personal details",
            style: titleStyle
        )
        let textFields = FormFieldPresetFactory.fields(
            by: [.bundleID, .sandboxKey, .productionKey],
            style: style
        )
        let button = EKProperty.ButtonContent(
            label: .init(text: "Continue", style: style.buttonTitle),
            backgroundColor: style.buttonBackground,
            highlightedBackgroundColor: style.buttonBackground.with(alpha: 0.8),
            displayMode: displayMode) {
                SwiftEntryKit.dismiss()
            }
        let contentView = EKFormMessageView(
            with: title,
            textFieldsContent: textFields,
            buttonContent: button
        )
        //attributes.lifecycleEvents.didAppear = {
          //  contentView.becomeFirstResponder(with: 0)
        //}
        SwiftEntryKit.display(entry: contentView, using: attributes, presentInsideKeyWindow: true)
    }
    
    func startWithSandBoxKeys(attributes: EKAttributes) {
        let cartViewController:CartViewController = storyboard?.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        present(cartViewController, animated: true)
    }
}
