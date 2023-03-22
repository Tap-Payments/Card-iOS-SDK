//
//  CartViewController.swift
//  TapCardCheckoutExample
//
//  Created by Osama Rabie on 02/12/2022.
//

import UIKit
import CollectionViewSlantedLayout
import SwiftEntryKit
import TapCardCheckOutKit
import CommonDataModelsKit_iOS

class CartViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: CollectionViewSlantedLayout!
    @IBOutlet weak var animatedBGImageView: UIImageView!
    
    internal var menu:[String] = ["0","1","2","3","4","5","0","1","2","3","4","5","0","1","2","3","4","5"]
    internal var price:[String:String] = ["0":"10","1":"20","2":"30","3":"40","4":"50","5":"60"]
    internal var titles:[String:String] = ["0":"Latte","1":"Tea","2":"Espresso","3":"Margherita Pizza","4":"Cheese Pizza","5":"Burger!"]
    
    let reuseIdentifier = "customViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let gif = try! UIImage(gifName: "giphy4.gif")
        animatedBGImageView.setGifImage(gif, loopCount: -1) // Will loop forever
        // Do any additional setup after loading the view.
        animatedBGImageView.addBackgroundPxEffect(strength: .Low)
        // Do any additional setup after loading the view.
        collectionViewLayout.isFirstCellExcluded = true
        collectionViewLayout.isLastCellExcluded = true
        
        // load merchant data
        configureSDK()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    
    // load merchant data
    func configureSDK() {
        // Override point for customization after application launch.
        view.isUserInteractionEnabled = false
        showProcessingNote(attributes: EntriesAttributes.customLoadingAttributes())
        let cardDataConfig:TapCardDataConfiguration = .init(sdkMode: .sandbox, localeIdentifier: sharedConfigurationSharedManager.selectedLocale, secretKey: .init(sandbox: "pk_test_YhUjg9PNT8oDlKJ1aE2fMRz7", production: "sk_live_V4UDhitI0r7sFwHCfNB6xMKp"),enableApiLogging: sharedConfigurationSharedManager.loggingCapabilities().map{ $0.rawValue })
        
        TapCardForumConfiguration.shared.configure(dataConfig: cardDataConfig, customTheme: nil) {
            DispatchQueue.main.async { [weak self] in
                SwiftEntryKit.dismiss()
                self?.view.isUserInteractionEnabled = true
            }
        } onErrorOccured: { error in
            DispatchQueue.main.async { [weak self] in
                SwiftEntryKit.dismiss()
                self?.view.isUserInteractionEnabled = true
                let uiAlertController:UIAlertController = .init(title: "Error from middleware", message: error?.localizedDescription ?? "", preferredStyle: .actionSheet)
                let uiAlertAction:UIAlertAction = .init(title: "Retry", style: .destructive) { _ in
                    self?.configureSDK()
                }
                uiAlertController.addAction(uiAlertAction)
                self?.present(uiAlertController, animated: true)
            }
        }
    }
    
    private func showProcessingNote(attributes: EKAttributes) {
        let text = "Fetching your data as a merchant.\nEncryption keys, your logo & other data"
        let style = EKProperty.LabelStyle(
            font: .systemFont(ofSize: 14, weight: .light),
            color: .white,
            alignment: .center,
            displayMode: .inferred
        )
        let labelContent = EKProperty.LabelContent(
            text: text,
            style: style
        )
        let contentView = EKProcessingNoteMessageView(
            with: labelContent,
            activityIndicator: UIActivityIndicatorView.Style.medium
        )
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    @IBAction func checkoutClicked(_ sender: Any) {
        let viewContoller:TapCardViewController = self.storyboard?.instantiateViewController(withIdentifier: "TapCardViewController") as! TapCardViewController
        viewContoller.savedCustomer = sharedConfigurationSharedManager.savedCustomer
        present(viewContoller, animated: false)
    }
    
    // Bumps a notification structured entry
    private func showNotificationMessage(attributes: EKAttributes,
                                         title: String,
                                         desc: String,
                                         textColor: EKColor,
                                         imageName: String? = nil) {
        
        let displayMode:EKAttributes.DisplayMode = .inferred
        let title = EKProperty.LabelContent(
            text: title,
            style: .init(
                font: .systemFont(ofSize: 16, weight: .medium),
                color: textColor,
                displayMode: displayMode
            ),
            accessibilityIdentifier: "title"
        )
        let description = EKProperty.LabelContent(
            text: desc,
            style: .init(
                font:.systemFont(ofSize: 14, weight: .light),
                color: textColor,
                displayMode: displayMode
            ),
            accessibilityIdentifier: "description"
        )
        var image: EKProperty.ImageContent?
        if let imageName = imageName {
            image = EKProperty.ImageContent(
                image: UIImage(named: imageName)!.withRenderingMode(.alwaysTemplate),
                displayMode: displayMode,
                size: CGSize(width: 35, height: 35),
                tint: textColor,
                accessibilityIdentifier: "thumbnail"
            )
        }
        let simpleMessage = EKSimpleMessage(
            image: image,
            title: title,
            description: description
        )
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
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




extension CartViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menu.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
                as? CustomCollectionCell else {
            fatalError()
        }
        
        cell.image = UIImage(named: menu[indexPath.row])!
        cell.price = price[menu[indexPath.row]]!
        
        if let layout = collectionView.collectionViewLayout as? CollectionViewSlantedLayout {
            cell.contentView.transform = CGAffineTransform(rotationAngle: layout.slantingAngle)
        }
        
        return cell
    }
}

extension CartViewController: CollectionViewDelegateSlantedLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NSLog("Did select item at indexPath: [\(indexPath.section)][\(indexPath.row)]")
        
        showNotificationMessage(attributes: EntriesAttributes.topFloatPopupAttributes(), title: titles[menu[indexPath.row]] ?? "", desc: "Great Choice! We added one for you!", textColor: .white)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: CollectionViewSlantedLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGFloat {
        return collectionViewLayout.scrollDirection == .vertical ? 275 : 325
    }
}

extension CartViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = collectionView else {return}
        guard let visibleCells = collectionView.visibleCells as? [CustomCollectionCell] else {return}
        for parallaxCell in visibleCells {
            let yOffset = (collectionView.contentOffset.y - parallaxCell.frame.origin.y) / parallaxCell.imageHeight
            let xOffset = (collectionView.contentOffset.x - parallaxCell.frame.origin.x) / parallaxCell.imageWidth
            parallaxCell.offset(CGPoint(x: xOffset * xOffsetSpeed, y: yOffset * yOffsetSpeed))
        }
    }
}
