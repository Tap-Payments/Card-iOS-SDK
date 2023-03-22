//
//  DempSettingsViewController.swift
//  TapCardCheckoutExample
//
//  Created by Osama Rabie on 18/07/2022.
//

import UIKit
import TapCardCheckOutKit
import CommonDataModelsKit_iOS

class DempSettingsViewController: UIViewController, CreateCustomerDelegate {
    
    
    // MARK: - The outlets
    /// The button to choose the demo localisation value
    @IBOutlet weak var localisationButton: UIButton!
    @IBOutlet weak var collectNameSwitch: UISwitch!
    @IBOutlet weak var cardBrandsSwitch: UISwitch!
    @IBOutlet weak var scanningSwitch: UISwitch!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var allowedCardsButton: UIButton!
    @IBOutlet weak var customerButton: UIButton!
    @IBOutlet weak var editCardNameSwitch: UISwitch!
    @IBOutlet weak var customCardNameButton: UIButton!
    @IBOutlet weak var blurScannerSwitch: UISwitch!
    @IBOutlet weak var scannerBorderColorButton: UIButton!
    
    @IBOutlet weak var customThemeSwitch: UISwitch!
    @IBOutlet weak var showBrandIconSwitch: UISwitch!
    
    var savedCustomer:TapCustomer? {
        if let data = UserDefaults.standard.value(forKey:"customerSevedKey") as? Data {
            do {
                return try PropertyListDecoder().decode(TapCustomer.self, from: data)
            } catch {
                print("error paymentTypes: \(error.localizedDescription)")
            }
        }
        return try! .init(identifier: "cus_TS075220212320q2RD0707283")
    }
    
    
    var customerDisplay:String {
        guard let customerName = savedCustomer?.firstName else {
            return savedCustomer?.identifier ?? ""
        }
        
        return customerName
    }
    
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
        let cardDataConfig:TapCardDataConfiguration = .init(sdkMode: .sandbox, localeIdentifier: "en", secretKey: .init(sandbox: "pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7", production: "sk_live_V4UDhitI0r7sFwHCfNB6xMKp"))
        
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
        // Set the usage of the online custom theme files
        customThemeSwitch.isOn = sharedConfigurationSharedManager.customTheme
        // Set the blur scan
        blurScannerSwitch.isOn = sharedConfigurationSharedManager.blurScanner
        // Set the allowed card type
        allowedCardsButton.setTitle(sharedConfigurationSharedManager.allowedCardTypes.description, for: .normal)
        // set the customer name and id
        customerButton.setTitle(customerDisplay, for: .normal)
        // set the card name
        customCardNameButton.setTitle(sharedConfigurationSharedManager.cardName, for: .normal)
        // Set the editing card name
        editCardNameSwitch.isOn = sharedConfigurationSharedManager.editCardHolderName
        // deines whether to show the detected brand icon besides the card number instead of the placeholdder
        showBrandIconSwitch.isOn = sharedConfigurationSharedManager.showBrandIcon
        // Tells if the scanner borders colors
        scannerBorderColorButton.tintColor = sharedConfigurationSharedManager.scannerColor
    }
    
    
    // MARK: - The ui based events
    
    @IBAction func showCardFormClicked(_ sender: Any) {
        //let viewContoller:ViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        //viewContoller.savedCustomer = savedCustomer
        //present(viewContoller, animated: true)
        
        let viewContoller:TapCardViewController = self.storyboard?.instantiateViewController(withIdentifier: "TapCardViewController") as! TapCardViewController
        viewContoller.savedCustomer = savedCustomer
        present(viewContoller, animated: true)
    }
    
    
    @IBAction func customThemeSwitchChanged(_ sender: Any) {
        loadingIndicator.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { [weak self] in
            self?.loadingIndicator.isHidden = true
        }
        sharedConfigurationSharedManager.customTheme = customThemeSwitch.isOn
        DispatchQueue.main.async { [weak self] in
            TapCardForumConfiguration.shared.customTheme = self?.customThemeSwitch.isOn ?? false ? .init(with: "https://firebasestorage.googleapis.com/v0/b/tapcardcheckout.appspot.com/o/LightTheme.json?alt=media&token=4f58decf-6e60-4053-bc1d-92794f39de13", and: "https://firebasestorage.googleapis.com/v0/b/tapcardcheckout.appspot.com/o/DarkTheme.json?alt=media&token=e6f51e9f-4101-4d10-8a47-86c0c193b54d", from: .RemoteJsonFile) : nil
        }
    }
    
    
    @IBAction func scannerBorderColorClicked(_ sender: Any) {
        let localizationAlertController:UIAlertController = .init(title: "Border", message: "Select your preferred border scanner color", preferredStyle: .actionSheet)
        
        let colors:[UIColor] = [.blue,.black,.green,.red]
        let strings:[String] = [ "blue", "black", "green", "red"]
        
        for (index,string) in strings.enumerated() {
            let colorAction:UIAlertAction = .init(title: string, style: .default) { [weak self] _ in
                //sharedConfigurationSharedManager.scannerColor = colors[index]
                self?.scannerBorderColorButton.tintColor = sharedConfigurationSharedManager.scannerColor
            }
            
            localizationAlertController.addAction(colorAction)
        }
        
        let cancelAction:UIAlertAction = .init(title: "Cancel", style: .default)

        localizationAlertController.addAction(cancelAction)
        
        present(localizationAlertController, animated: true)
        
    }
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
    
    @IBAction func showBrandIconSwitchChanged(_ sender: Any) {
        sharedConfigurationSharedManager.showBrandIcon = showBrandIconSwitch.isOn
    }
    
    @IBAction func blurScannerSwitchChanged(_ sender: Any) {
        sharedConfigurationSharedManager.blurScanner = blurScannerSwitch.isOn
    }
    
    @IBAction func editCardNameSwitchChanged(_ sender: Any) {
        sharedConfigurationSharedManager.editCardHolderName = editCardNameSwitch.isOn
    }
    
    @IBAction func customerButtonClicked(_ sender: Any) {
        let customerCreate:CreateCustomerViewController = self.storyboard?.instantiateViewController(withIdentifier: "CreateCustomerViewController") as! CreateCustomerViewController
        present(customerCreate, animated: true)
        customerCreate.customerDelegate = self
    }
    
    @IBAction func cardNameClicked(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Preload the card holder name field", message: "Please note, it has to be alphabet only, more than 2 charachters and less than 27!", preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { [weak self] alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            
            if let passedCardName = firstTextField.text,
               !passedCardName.isEmpty,
               self?.alphabetOnly(passedCardName) == passedCardName.lowercased(),
               passedCardName.count > 2,
               passedCardName.count <= 26 {
                sharedConfigurationSharedManager.cardName = passedCardName
            }else{
                sharedConfigurationSharedManager.cardName = "None"
            }
            self?.customCardNameButton.setTitle(sharedConfigurationSharedManager.cardName, for: .normal)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter the card name"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)

    }
    
    func alphabetOnly(_ string:String) -> String {
        return string.lowercased().filter { "abcdefghijklmnopqrstuvwxyz ".contains($0) }
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

    
    func customerCreated(customer: TapCustomer) {
        customerButton.setTitle(customerDisplay, for: .normal)
    }
}
