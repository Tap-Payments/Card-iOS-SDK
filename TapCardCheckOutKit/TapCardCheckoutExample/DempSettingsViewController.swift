//
//  DempSettingsViewController.swift
//  TapCardCheckoutExample
//
//  Created by Osama Rabie on 18/07/2022.
//

import UIKit
import TapCardCheckOutKit

class DempSettingsViewController: UIViewController {
    // MARK: - The outlets
    /// The button to choose the demo localisation value
    @IBOutlet weak var localisationButton: UIButton!
    @IBOutlet weak var collectNameSwitch: UISwitch!
    @IBOutlet weak var cardBrandsSwitch: UISwitch!
    @IBOutlet weak var scanningSwitch: UISwitch!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var allowedCardsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Preload
        preload()
        // load merchant data
        configureSDK()
    }
    
    
    private func configureSDK() {
        loadingIndicator.isHidden = false
        // Override point for customization after application launch.
        let cardDataConfig:TapCardDataConfiguration = .init(sdkMode: .sandbox, localeIdentifier: "en", secretKey: .init(sandbox: "sk_test_yKOxBvwq3oLlcGS6DagZYHM2", production: "sk_live_V4UDhitI0r7sFwHCfNB6xMKp"))
        TapCardForumConfiguration.shared.configure(dataConfig: cardDataConfig) {
            DispatchQueue.main.async { [weak self] in
                self?.loadingIndicator.isHidden = true
            }
        } onErrorOccured: { error in
            DispatchQueue.main.async { [weak self] in
                let uiAlertController:UIAlertController = .init(title: "Error from middleware", message: error?.localizedDescription ?? "", preferredStyle: .actionSheet)
                let uiAlertAction:UIAlertAction = .init(title: "Retry", style: .destructive) { _ in
                    self?.configureSDK()
                }
                uiAlertController.addAction(uiAlertAction)
                self?.present(uiAlertController, animated: true)
            }
        }
        
    }
    
    
    
    /// Preloads the configurtions with the last selected ones
    private func preload() {
        // define the locale button title
        localisationButton.setTitle(sharedConfigurationSharedManager.selectedLocale, for: .normal)
        // Set the collect card holder name switch
        collectNameSwitch.isOn = sharedConfigurationSharedManager.collectCardHolderName
        // Set the show card brand switch
        cardBrandsSwitch.isOn = sharedConfigurationSharedManager.showCardBrands
        // Set the show card scanning switch
        scanningSwitch.isOn = sharedConfigurationSharedManager.showCardScanning
        // Set the allowed card type
        allowedCardsButton.setTitle(sharedConfigurationSharedManager.allowedCardTypes.description, for: .normal)
    }
    
    
    // MARK: - The ui based events
    
    @IBAction func localisationButtonClicked(_ sender: Any) {
        let localizationAlertController:UIAlertController = .init(title: "Localisation", message: "Select your preferred locale to test with", preferredStyle: .actionSheet)
        
        let englishAction:UIAlertAction = .init(title: "English", style: .default) { [weak self] _ in
            sharedConfigurationSharedManager.selectedLocale = "en"
            self?.localisationButton.setTitle("en", for: .normal)
        }
        
        let arabicAction:UIAlertAction = .init(title: "العربية", style: .default) { [weak self] _ in
            sharedConfigurationSharedManager.selectedLocale = "ar"
            self?.localisationButton.setTitle("ar", for: .normal)
        }
        
        let cancelAction:UIAlertAction = .init(title: "Cancel", style: .default)
        
        localizationAlertController.addAction(englishAction)
        localizationAlertController.addAction(arabicAction)
        localizationAlertController.addAction(cancelAction)
        
        present(localizationAlertController, animated: true)
        
    }
    
    
    @IBAction func collectNameSwitchValueChanged(_ sender: Any) {
        
        sharedConfigurationSharedManager.collectCardHolderName = collectNameSwitch.isOn
    }
    
    @IBAction func cardBrandsSwitchValueChanged(_ sender: Any) {
        
        sharedConfigurationSharedManager.showCardBrands = cardBrandsSwitch.isOn
    }
    
    @IBAction func scanningSwitchValueChanged(_ sender: Any) {
        sharedConfigurationSharedManager.showCardScanning = scanningSwitch.isOn
    }
    
    @IBAction func allowedCardsClicked(_ sender: Any) {
        let localizationAlertController:UIAlertController = .init(title: "Card Type", message: "Select your allowed card type", preferredStyle: .actionSheet)
        
        let allAction:UIAlertAction = .init(title: "All", style: .default) { [weak self] _ in
            sharedConfigurationSharedManager.allowedCardTypes = .All
            self?.allowedCardsButton.setTitle("All", for: .normal)
        }
        
        let creditAction:UIAlertAction = .init(title: "Credit", style: .default) { [weak self] _ in
            sharedConfigurationSharedManager.allowedCardTypes = .Credit
            self?.allowedCardsButton.setTitle("Credit", for: .normal)
        }
        
        let debitAction:UIAlertAction = .init(title: "Debit", style: .default) { [weak self] _ in
            sharedConfigurationSharedManager.allowedCardTypes = .Debit
            self?.allowedCardsButton.setTitle("Debit", for: .normal)
        }
        
        let cancelAction:UIAlertAction = .init(title: "Cancel", style: .default)
        
        localizationAlertController.addAction(allAction)
        localizationAlertController.addAction(creditAction)
        localizationAlertController.addAction(debitAction)
        localizationAlertController.addAction(cancelAction)
        
        present(localizationAlertController, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
