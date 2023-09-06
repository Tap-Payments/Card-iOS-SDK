//
//  CardSettingsViewController.swift
//  TapCardCheckoutExample
//
//  Created by Osama Rabie on 02/12/2022.
//

import UIKit
import Eureka
import CommonDataModelsKit_iOS
import TapCardCheckOutKit
import TapCardVlidatorKit_iOS
import TapCardScanner_iOS

class CardSettingsViewController: FormViewController {
    let brands:[CardBrand] = [.americanExpress, .mada, .masterCard, .omanNet, .visa, .meeza]
    let sampleBorderColors:[UIColor] = [.red, .green]
    let sampleBorderColorsString:[String] = ["Red", "Green"]
    
    @IBOutlet weak var doneButton: UIButton!
    override func viewDidLoad() {
        //let cardDataConfig:TapCardDataConfiguration = .init(sdkMode: .sandbox, localeIdentifier: sharedConfigurationSharedManager.selectedLocale, secretKey: .init(sandbox: "pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7", production: "sk_live_V4UDhitI0r7sFwHCfNB6xMKp"),enableApiLogging: sharedConfigurationSharedManager.loggingCapabilities().map{ $0.rawValue })
        
        super.viewDidLoad()
        form +++ Section("Operator")
        <<< TextRow(SettingsKeys.OperatorSandBoxKey.rawValue, { row in
            row.title = "Sandbox Key"
            row.placeholder = "Your sandbox key"
            row.value = sharedConfigurationSharedManager.publicKey.sandbox
            row.onChange { textRow in
                sharedConfigurationSharedManager.publicKey = .init(sandbox: textRow.value ?? "pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7", production: sharedConfigurationSharedManager.publicKey.production)
            }
        })
        
        <<< TextRow(SettingsKeys.OperatorProductionKey.rawValue, { row in
            row.title = "Production Key"
            row.placeholder = "Your production key"
            row.value = sharedConfigurationSharedManager.publicKey.production
            row.onChange { textRow in
                sharedConfigurationSharedManager.publicKey = .init(sandbox: sharedConfigurationSharedManager.publicKey.production, production: textRow.value ?? "sk_live_V4UDhitI0r7sFwHCfNB6xMKp")
            }
        })
        
        
        form +++ Section("Scope")
        <<< PickerInlineRow<String>(SettingsKeys.Scope.rawValue, { row in
            row.title = "SDK's scope"
            row.options = ["Tap token"]
            row.value = "Tap token"
            row.onChange { row in
                sharedConfigurationSharedManager.scope = .TapToken
            }
        })
        
       
        form +++ Section("Order")
        <<< TextRow("CardOrderID", { row in
            row.title = "Tap order id"
            row.placeholder = "Create order and pass its id if needed"
            row.value = sharedConfigurationSharedManager.order?.identifier ?? ""
            row.onChange { textRow in
                sharedConfigurationSharedManager.order = Order(identifier: textRow.value ?? "")
            }
        })
        
        form +++ Section("Transaction")
        <<< PickerInlineRow<String>(SettingsKeys.TransactionCurrency.rawValue, { row in
            row.title = "Currency"
            row.options = TapCurrencyCode.allCases.map{ $0.appleRawValue }
            row.value = sharedConfigurationSharedManager.transcation.currency.appleRawValue
            row.onChange { row in
                sharedConfigurationSharedManager.transcation.currency = .init(appleRawValue: row.value ?? "SAR") ?? .SAR
            }
        })
        
        <<< TextRow(SettingsKeys.TransactionAmount.rawValue, { row in
            row.title = "Amount"
            row.placeholder = "Your amount"
            row.value = "\(sharedConfigurationSharedManager.transcation.amount)"
            row.onChange { textRow in
                guard let doubleValue: Double = Double(textRow.value ?? "0"),
                      doubleValue > 1 else {
                    sharedConfigurationSharedManager.transcation.amount = 1
                    return
                }
                sharedConfigurationSharedManager.transcation.amount = doubleValue
            }
        })
        
        form +++ Section("Merchant")
        <<< TextRow(SettingsKeys.MerchantMerchantIDKey.rawValue, { row in
            row.title = "Tap MID"
            row.placeholder = "Merchant id provided by Tap team"
            row.value = sharedConfigurationSharedManager.merchant.id
            row.onChange { textRow in
                sharedConfigurationSharedManager.merchant.id = textRow.value ?? ""
            }
        })
        
        
        +++ Section("Customer")
        <<< ButtonRow(SettingsKeys.Customer.rawValue, { row in
            row.title = "Customer : \(sharedConfigurationSharedManager.customerDisplay())"
            row.onCellSelection { [weak self] cell, row in
                let customerCreate:CreateCustomerViewController = self?.storyboard?.instantiateViewController(withIdentifier: "CreateCustomerViewController") as! CreateCustomerViewController
                self?.present(customerCreate, animated: true)
                customerCreate.customerDelegate = self
                
            }
        })
        
        form +++ Section("Features")
        
        <<< SwitchRow("AddonsdisplayPaymentBrands", { row in
            row.title = "Display acceptance badge"
            row.value =  sharedConfigurationSharedManager.features.acceptanceBadge
            row.onChange { switchRow in
                sharedConfigurationSharedManager.features.acceptanceBadge = switchRow.value ?? true
            }
        })
        
        form +++ Section("Acceptance")
        
        <<< MultipleSelectorRow<String>(tag: SettingsKeys.AcceptanceBrands.rawValue)
            .cellSetup { cell, row in
                row.title = "Supported brands"
                row.options = self.brands.map{ $0.toString }
                row.value = Set(sharedConfigurationSharedManager.acceptance.supportedBrands.map{ $0.toString })
            }
            .cellUpdate{ cell, row in
                let selected:[String] = Array(row.value ?? [])
                if selected.isEmpty {
                    sharedConfigurationSharedManager.acceptance.supportedBrands = [.americanExpress, .mada, .masterCard, .omanNet, .visa, .meeza]
                }else{
                    sharedConfigurationSharedManager.acceptance.supportedBrands = selected.map{ CardBrand.from(string: $0) }
                }
            }
        
        <<< PickerInlineRow<String>(SettingsKeys.AcceptanceFundSource.rawValue, { row in
            row.title = "Card fund source"
            row.options = cardTypes.allCases.map{ $0.description }
            row.value = sharedConfigurationSharedManager.acceptance.supportedFundSource.description
            row.onChange { row in
                sharedConfigurationSharedManager.acceptance.supportedFundSource = cardTypes.from(string: row.value ?? "All")
            }
        })
        
        
        <<< PickerInlineRow<String>(SettingsKeys.AcceptanceAuthentications.rawValue, { row in
            row.title = "Authentications"
            row.options = ["3DS"]
            row.value = "3DS"
        })
        
        <<< PickerInlineRow<String>(SettingsKeys.AcceptanceSdkMode.rawValue, { row in
            row.title = "SDK Mode"
            row.options = SDKMode.allCases.map{ $0.description }
            row.value = sharedConfigurationSharedManager.acceptance.sdkMode.description
            row.onChange { row in
                if let sdkMode:SDKMode = SDKMode.allCases.first(where: { $0.description == row.value }) {
                    sharedConfigurationSharedManager.acceptance.sdkMode = sdkMode
                }
            }
        })
        
        
        form +++ Section("Fields")
        <<< SwitchRow("FieldsName", { row in
            row.title = "Card name"
            row.value = sharedConfigurationSharedManager.fields.cardHolder
            row.onChange { segmentRow in
                sharedConfigurationSharedManager.fields.cardHolder = segmentRow.value ?? false
            }
        })
        
        
        form +++ Section("Addons")
        <<< SwitchRow("AddonsLoader", { row in
            row.title = "Show processing loader"
            row.value =  sharedConfigurationSharedManager.addons.loader
            row.onChange { switchRow in
                sharedConfigurationSharedManager.addons.loader = switchRow.value ?? true
            }
        })
        
        <<< SwitchRow("AddonsdisplayCardScannings", { row in
            row.title = "Display card scanning"
            row.value =  sharedConfigurationSharedManager.addons.displayCardScanning
            row.onChange { switchRow in
                sharedConfigurationSharedManager.addons.displayCardScanning = switchRow.value ?? true
            }
        })
        
        
        +++ Section("Interface")
        <<< SegmentedRow<String>("InterfaceLocale", { row in
            row.title = "Locale"
            row.options = ["en","ar"]
            row.value =  sharedConfigurationSharedManager.interface.locale
            row.onChange { switchRow in
                sharedConfigurationSharedManager.interface.locale = switchRow.value ?? "en"
            }
        })
        
        
        <<< SegmentedRow<String>("InterfaceDirection", { row in
            row.title = "Card direction"
            row.options = CardDirection.allCases.map{ $0.toString }
            row.value =  sharedConfigurationSharedManager.interface.direction.toString
            row.onChange { switchRow in
                sharedConfigurationSharedManager.interface.direction =  CardDirection.allCases.first(where: { $0.toString == row.value }) ?? .Dynamic
            }
        })
        
        
        <<< SegmentedRow<String>("InterfaceEdges", { row in
            row.title = "Card edges"
            row.options = CardEdges.allCases.map{ $0.toString }
            row.value =  sharedConfigurationSharedManager.interface.edges.toString
            row.onChange { switchRow in
                sharedConfigurationSharedManager.interface.edges =  CardEdges.allCases.first(where: { $0.toString == row.value }) ?? .Curved
            }
        })
        
        <<< SwitchRow("CardPowered", { row in
            row.title = "Powered by tap"
            row.value = sharedConfigurationSharedManager.interface.powered
            row.onChange { switchRow in
                sharedConfigurationSharedManager.interface.powered = switchRow.value ?? true
            }
        })
        
        <<< SwitchRow(SettingsKeys.ScanningBlur.rawValue, { row in
            row.title = "Scanner blured background"
            row.value = sharedConfigurationSharedManager.interface.tapScannerUICustomization.blurCardScannerBackground
            row.onChange { switchRow in
                sharedConfigurationSharedManager.interface.tapScannerUICustomization.blurCardScannerBackground = switchRow.value ?? true
            }
        })
        <<< SegmentedRow<String>(SettingsKeys.ScanningBorder.rawValue, { row in
            row.title = "Scanner border color"
            row.options = ScannerBlurColor.allCases.map{ $0.toString() }
            row.value = sampleBorderColorsString[sampleBorderColors.firstIndex(of: sharedConfigurationSharedManager.interface.tapScannerUICustomization.tapFullScreenScanBorderColor) ?? 0]
            row.onChange { segmentRow in
                sharedConfigurationSharedManager.interface.tapScannerUICustomization.tapFullScreenScanBorderColor = self.sampleBorderColors[self.sampleBorderColorsString.firstIndex(of:row.value ?? "Green") ?? 0]
            }
        })
        
        /*+++ Section("3DS Popup")
         <<< SwitchRow(SettingsKeys.FloatingSavedCard.rawValue, { row in
         row.title = "Show saved card as a floating view"
         row.value = sharedConfigurationSharedManager.floatingSavedCard
         row.onChange { switchRow in
         sharedConfigurationSharedManager.floatingSavedCard = switchRow.value ?? true
         }
         })
         
        <<< SegmentedRow<String>(SettingsKeys.ThreeDsAnimationType.rawValue, { row in
            row.title = "Intro animation type"
            row.options = ThreeDsWebViewAnimationEnum.allCases.map{ $0.toString() }
            row.value = sharedConfigurationSharedManager.animationType.toString()
            row.onChange { segmentRow in
                sharedConfigurationSharedManager.animationType = ThreeDsWebViewAnimationEnum.allCases.filter{ $0.toString() == (segmentRow.value ?? "Bottom modal") }.first ?? .BottomTransition
                switch sharedConfigurationSharedManager.animationType {
                case .ZoomIn:
                    sharedConfigurationSharedManager.animationDuration = 1.0
                case .BottomTransition:
                    sharedConfigurationSharedManager.animationDuration = 0.5
                }
                self.tableView.reloadData()
            }
        })
        
        <<< PickerInlineRow<Double>(SettingsKeys.ThreeDsAnimationDuration.rawValue, { row in
            row.title = "Animation duration"
            row.value = sharedConfigurationSharedManager.animationDuration
            row.options = [0.5,1,1.5,2,2.5]
            row.onCellSelection { cell, row in
                sharedConfigurationSharedManager.animationDuration = row.value ?? 0.5
            }
        })
        
        <<< PickerInlineRow<String>(SettingsKeys.ThreeDsBlur.rawValue, { row in
            row.title = "Backgroun blur"
            row.value = sharedConfigurationSharedManager.threeDSBlurStyle.toString()
            row.options = ThreeDSBlurStyle.allCases.map{ $0.toString() }
            row.onCellSelection { cell, row in
                sharedConfigurationSharedManager.threeDSBlurStyle = ThreeDSBlurStyle.allCases.filter{ $0.toString() == (row.value ?? "Dark") }.first ?? .Dark
            }
        })
        
        <<< SwitchRow(SettingsKeys.ThreeDsHeader.rawValue, { row in
            row.title = "Show header for web view"
            row.value = sharedConfigurationSharedManager.showWebViewHeader
            row.onChange { row in
                sharedConfigurationSharedManager.showWebViewHeader = row.value ?? true
            }
        })*/
        
        view.bringSubviewToFront(doneButton)
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        dismiss(animated: true)
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

enum SettingsKeys:String {
    case OperatorSandBoxKey
    case OperatorProductionKey
    
    case Scope
    
    case TransactionCurrency
    case TransactionAmount
    
    case MerchantMerchantIDKey
    
    case CustomerCardName
    case CustomerCardEditable
    
    case AcceptanceBrands
    case AcceptanceFundSource
    case AcceptanceAuthentications
    case AcceptanceSdkMode
    
    case Localisation
    case CollectName
    case BrandsBar
    case Scanning
    case CardName
    case CardNameEdit
    case ScanningBlur
    case ScanningBorder
    case CardType
    case Customer
    case ThreeDsAnimationDuration
    case ThreeDsAnimationType
    case ThreeDsBlur
    case ThreeDsHeader
    case LoadingState
    case FloatingSavedCard
    case SDKCardForceLTR
    case SDKULogUI
    case SDKLogApi
    case SDKLogConsole
    case SDKLogEvents
    
}




extension CardSettingsViewController:CreateCustomerDelegate {
    func customerCreated(customer: TapCustomer) {
        sharedConfigurationSharedManager.customer = customer
        tableView.reloadData()
    }
}
