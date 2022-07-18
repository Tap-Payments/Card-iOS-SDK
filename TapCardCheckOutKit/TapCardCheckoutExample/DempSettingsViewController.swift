//
//  DempSettingsViewController.swift
//  TapCardCheckoutExample
//
//  Created by Osama Rabie on 18/07/2022.
//

import UIKit

class DempSettingsViewController: UIViewController {
    // MARK: - The outlets
    /// The button to choose the demo localisation value
    @IBOutlet weak var localisationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Preload
        preload()
    }
    
    
    /// Preloads the configurtions with the last selected ones
    private func preload() {
        // define the locale button title
        localisationButton.setTitle(sharedConfigurationSharedManager.selectedLocale, for: .normal)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
