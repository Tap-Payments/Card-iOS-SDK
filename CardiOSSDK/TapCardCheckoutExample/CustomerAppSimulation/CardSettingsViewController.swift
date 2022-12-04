//
//  CardSettingsViewController.swift
//  TapCardCheckoutExample
//
//  Created by Osama Rabie on 02/12/2022.
//

import UIKit
import Eureka
import CommonDataModelsKit_iOS

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
        <<< SegmentedRow<String>(SettingsKeys.CardType.rawValue, { row in
            row.title = "Allowed card types"
            row.options = cardTypes.allCases.map{ $0.description }
            row.value = sharedConfigurationSharedManager.allowedCardTypes.description
            row.onChange { segmentRow in
                sharedConfigurationSharedManager.allowedCardTypes = cardTypes.allCases.filter{ $0.description == (segmentRow.value ?? "") }.first ?? .All
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
        <<< PickerInlineRow<Double>(SettingsKeys.ThreeDsDuration.rawValue, { row in
            row.title = "Zoom in animation duration"
            row.value = sharedConfigurationSharedManager.threeDSAnimationDuration
            row.options = [0.5,1,1.5,2,2.5]
            row.onCellSelection { cell, row in
                sharedConfigurationSharedManager.threeDSAnimationDuration = row.value ?? 1.0
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
    case ThreeDsDuration
    case ThreeDsBlur
    
}




extension CardSettingsViewController:CreateCustomerDelegate {
    func customerCreated(customer: TapCustomer) {
        tableView.reloadData()
    }
}
