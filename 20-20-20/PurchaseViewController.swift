//
//  PurchaseViewController.swift
//  20-20-20
//
//  Created by Yoko Kuroshima on 2022/01/03.
//

import UIKit
import StoreKit
import SwiftyStoreKit

class PurchaseViewController: UIViewController {
    
    // 各Label
    @IBOutlet weak var frameView: UIView!
    @IBOutlet weak var upgradeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var itemExplainLabel: UILabel!
    
    // Button
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    
    // 購入状況
    var isPurchased = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ページ上部のbackボタンを非表示にする
        self.navigationItem.hidesBackButton = true
        
        // frame部分の設定
        self.frameView.backgroundColor = UIColor(red: 1, green: 1, blue: 0.9, alpha: 1)
        self.frameView.layer.borderColor = UIColor(red: 1, green: 0.7, blue: 0.2, alpha: 1).cgColor
        self.frameView.layer.borderWidth = 5.0
        self.frameView.layer.cornerRadius = 20.0
        self.frameView.layer.masksToBounds = true
        self.view.addSubview(frameView)
        
        // upgradeLabe
        self.upgradeLabel.backgroundColor = UIColor(red: 1, green: 1, blue: 0.9, alpha: 1)
        self.upgradeLabel.layer.borderColor = UIColor(red: 1, green: 1, blue: 0.9, alpha: 1).cgColor
        self.upgradeLabel.layer.borderWidth = 1.0
        self.upgradeLabel.font = UIFont(name: "TimesNewRomanPS-BoldItalicMT", size: 28)
        
        // priceLabel
        self.priceLabel.backgroundColor = UIColor(red: 1, green: 1, blue: 0.9, alpha: 1)
        self.priceLabel.layer.borderColor = UIColor(red: 1, green: 1, blue: 0.9, alpha: 1).cgColor
        self.priceLabel.layer.borderWidth = 1.0
        self.priceLabel.textColor = UIColor(red: 1, green: 0.7, blue: 0.2, alpha: 1)
        self.priceLabel.font = UIFont.boldSystemFont(ofSize: 34)
        
        // itemLabel
        self.itemLabel.backgroundColor = UIColor(red: 1, green: 1, blue: 0.9, alpha: 1)
        self.itemLabel.layer.borderColor = UIColor(red: 1, green: 1, blue: 0.9, alpha: 1).cgColor
        self.itemLabel.layer.borderWidth = 1.0
        self.itemLabel.font = UIFont.systemFont(ofSize: 18)
        // 下線を引く
        guard let itemLabelTargetText = itemLabel.text else {return}
        let itemLabelAttributedString = NSMutableAttributedString(string: itemLabelTargetText)
        itemLabelAttributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSString(string: itemLabelTargetText).range(of: itemLabelTargetText))
        itemLabel.attributedText = itemLabelAttributedString
        
        // itemExplainLabel
        self.itemExplainLabel.backgroundColor = UIColor(red: 1, green: 1, blue: 0.9, alpha: 1)
        self.itemExplainLabel.layer.borderColor = UIColor(red: 1, green: 1, blue: 0.9, alpha: 1).cgColor
        self.itemExplainLabel.layer.borderWidth = 1.0
        self.itemExplainLabel.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.itemExplainLabel.font = UIFont.systemFont(ofSize: 14)
        
        // purchaseButton
        self.purchaseButton.frame = CGRect(x: 0, y: 0, width: 115, height: 35)
        self.purchaseButton.backgroundColor = UIColor(red: 1, green: 0.7, blue: 0.2, alpha: 1)
        self.purchaseButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        self.purchaseButton.layer.borderWidth = 3
        self.purchaseButton.layer.borderColor = UIColor(red: 1, green: 0.7, blue: 0.2, alpha: 1).cgColor
        self.purchaseButton.layer.cornerRadius = 10
        
        // restoreButton
        self.restoreButton.frame = CGRect(x: 0, y: 250, width: 115, height: 35)
        self.restoreButton.backgroundColor = UIColor.white
        self.restoreButton.layer.borderWidth = 3
        self.restoreButton.layer.borderColor = UIColor(red: 1, green: 0.7, blue: 0.2, alpha: 1).cgColor
        self.restoreButton.layer.cornerRadius = 10
    }
    
    
    // Purchaseボタン
    @IBAction func purchaseButton(_ sender: Any) {
        // 購入
        AppStoreClass().purchaseItemFromAppStore(productId: "jp.techacademy.skycat.202020.consumable.item1")
    }
    
    // Restoreボタン
    @IBAction func restoreButton(_ sender: Any) {
        // 購入復元
        AppStoreClass.shared.restore { isSuccess in
            if (isSuccess) {
                let successAlert = UIAlertController(title: "Succeeded", message: "Successfully restored setting functions.", preferredStyle: .alert)
                successAlert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(successAlert, animated: true, completion: nil)
            } else {
                let failAlert = UIAlertController(title: "Failed", message: "Failed to restore setting functions.", preferredStyle: .alert)
                failAlert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(failAlert, animated: true, completion: nil)
            }
        }
    }
    
    //Privacy PolicyボタンをタップするとポートフォリオサイトのPrivacyページに移動
    @IBAction func privacyPolicyButton(_ sender: Any) {
        let privacyPolicyUrl = NSURL(string: "https://skycat315.sakura.ne.jp/top/privacy-policy/")
        if UIApplication.shared.canOpenURL(privacyPolicyUrl! as URL) {
            UIApplication.shared.open(privacyPolicyUrl! as URL, options: [:], completionHandler: nil)
        }
    }
}


