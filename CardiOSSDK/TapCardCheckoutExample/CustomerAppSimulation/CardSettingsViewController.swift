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

class CardSettingsViewController: FormViewController {

    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        form +++ Section("Card Forum Settings")
        <<< SegmentedRow<String>(SettingsKeys.Localisation.rawValue, { row in
            row.title = "Localisation"
            row.options = ["en","ar"]
            row.value = sharedConfigurationSharedManager.selectedLocale
            row.onChange { segmentRow in
                sharedConfigurationSharedManager.selectedLocale = segmentRow.value ?? "en"
            }
        })
        <<< SwitchRow(SettingsKeys.BrandsBar.rawValue, { row in
            row.title = "Show brands bar"
            row.value = sharedConfigurationSharedManager.showCardBrands
            row.onChange { switchRow in
                sharedConfigurationSharedManager.showCardBrands = switchRow.value ?? true
            }
        })
        
        <<< SwitchRow(SettingsKeys.LoadingState.rawValue, { row in
            row.title = "Show loading state"
            row.value = sharedConfigurationSharedManager.showLoadingState
            row.onChange { switchRow in
                sharedConfigurationSharedManager.showLoadingState = switchRow.value ?? true
            }
        })
        
        <<< SwitchRow(SettingsKeys.SDKCardForceLTR.rawValue, { row in
            row.title = "Force LTR"
            row.value = sharedConfigurationSharedManager.forceLTR
            row.onChange { switchRow in
                sharedConfigurationSharedManager.forceLTR = switchRow.value ?? true
            }
        })
        
        <<< SwitchRow(SettingsKeys.FloatingSavedCard.rawValue, { row in
            row.title = "Show saved card as a floating view"
            row.value = sharedConfigurationSharedManager.floatingSavedCard
            row.onChange { switchRow in
                sharedConfigurationSharedManager.floatingSavedCard = switchRow.value ?? true
            }
        })
        
        <<< SegmentedRow<String>(SettingsKeys.CardType.rawValue, { row in
            row.title = "Allowed card types"
            row.options = cardTypes.allCases.map{ $0.description }
            row.value = sharedConfigurationSharedManager.allowedCardTypes.description
            row.onChange { segmentRow in
                sharedConfigurationSharedManager.allowedCardTypes = cardTypes.allCases.filter{ $0.description == (segmentRow.value ?? "") }.first ?? .All
            }
        })
        
        form +++ Section("Logging Configuration")
        <<< SwitchRow(SettingsKeys.SDKULogUI.rawValue, { row in
            row.title = "Log UI events"
            row.value = sharedConfigurationSharedManager.logUI
            row.onChange { switchRow in
                sharedConfigurationSharedManager.logUI = switchRow.value ?? false
            }
        })
        
        <<< SwitchRow(SettingsKeys.SDKLogApi.rawValue, { row in
            row.title = "Log Api calls"
            row.value = sharedConfigurationSharedManager.logAPI
            row.onChange { switchRow in
                sharedConfigurationSharedManager.logAPI = switchRow.value ?? false
            }
        })
        
        <<< SwitchRow(SettingsKeys.SDKLogEvents.rawValue, { row in
            row.title = "Log user's events"
            row.value = sharedConfigurationSharedManager.logEvents
            row.onChange { switchRow in
                sharedConfigurationSharedManager.logEvents = switchRow.value ?? false
            }
        })
        
        <<< SwitchRow(SettingsKeys.SDKLogConsole.rawValue, { row in
            row.title = "Log to Xcode console for development"
            row.value = sharedConfigurationSharedManager.logConsole
            row.onChange { switchRow in
                sharedConfigurationSharedManager.logConsole = switchRow.value ?? false
            }
        })
        
        
        +++ Section("Card Name Settings")
        <<< SwitchRow(SettingsKeys.CollectName.rawValue, { row in
            row.title = "Collect holder name"
            row.value = sharedConfigurationSharedManager.collectCardHolderName
            row.onChange { switchRow in
                sharedConfigurationSharedManager.collectCardHolderName = switchRow.value ?? false
            }
        })
        <<< TextRow(SettingsKeys.CardName.rawValue, { row in
            row.title = "Preload card name"
            row.placeholder = "Enter text here"
            row.value = sharedConfigurationSharedManager.cardName
            row.onChange { textRow in
                sharedConfigurationSharedManager.cardName = textRow.value ?? ""
            }
        })
        <<< SwitchRow(SettingsKeys.CardNameEdit.rawValue, { row in
            row.title = "Card name is editable"
            row.value = sharedConfigurationSharedManager.editCardHolderName
            row.onChange { switchRow in
                sharedConfigurationSharedManager.editCardHolderName = switchRow.value ?? false
            }
        })
        
        
        +++ Section("Scanner Settings")
        <<< SwitchRow(SettingsKeys.Scanning.rawValue, { row in
            row.title = "Show scanning"
            row.value =  sharedConfigurationSharedManager.showCardScanning
            row.onChange { switchRow in
                sharedConfigurationSharedManager.showCardScanning = switchRow.value ?? true
            }
        })
        <<< SwitchRow(SettingsKeys.ScanningBlur.rawValue, { row in
            row.title = "Scanner blured background"
            row.value = sharedConfigurationSharedManager.blurScanner
            row.onChange { switchRow in
                sharedConfigurationSharedManager.blurScanner = switchRow.value ?? true
            }
        })
        <<< SegmentedRow<String>(SettingsKeys.ScanningBorder.rawValue, { row in
            row.title = "Scanner border color"
            row.options = ScannerBlurColor.allCases.map{ $0.toString() }
            row.value = sharedConfigurationSharedManager.scannerColorEnum.toString()
            row.onChange { segmentRow in
                sharedConfigurationSharedManager.scannerColorEnum = ScannerBlurColor.allCases.filter{ $0.toString() == (segmentRow.value ?? "Green") }.first ?? .Green
            }
        })
        
        +++ Section("3DS Popup")
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
        })
        
        +++ Section("Customer")
        <<< ButtonRow(SettingsKeys.Customer.rawValue, { row in
            row.title = "Customer : \(sharedConfigurationSharedManager.customerDisplay)"
            row.onCellSelection { [weak self] cell, row in
                let customerCreate:CreateCustomerViewController = self?.storyboard?.instantiateViewController(withIdentifier: "CreateCustomerViewController") as! CreateCustomerViewController
                self?.present(customerCreate, animated: true)
                customerCreate.customerDelegate = self
                
            }
        })
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
        tableView.reloadData()
    }
}
