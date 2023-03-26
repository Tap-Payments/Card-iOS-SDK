//
//  TestViewController.swift
//  TapCardCheckoutExample
//
//  Created by Osama Rabie on 24/03/2023.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func clicked(_ sender: Any) {
        
        
        let rect2 = button.frame
        let newRect = UIAccessibility.convertToScreenCoordinates(rect2, in: view)
        print(button.bounds)
        print(button.frame)
        print(rect2)
        print(newRect)
        
        
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
