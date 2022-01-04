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
    
    // 各Text
    @IBOutlet weak var frameView: UIView!
    @IBOutlet weak var upgradeTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var itemExplainTextView: UITextView!
    
    // Button
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    
    
    var isPurchased = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 枠部分の設定
        self.frameView.backgroundColor = UIColor(red: 1, green: 1, blue: 0.9, alpha: 1)
        self.frameView.layer.borderColor = UIColor(red: 1, green: 0.7, blue: 0.2, alpha: 1).cgColor
        self.frameView.layer.borderWidth = 5.0
        self.frameView.layer.cornerRadius = 20.0
        self.frameView.layer.masksToBounds = true
        self.view.addSubview(frameView)
        
        // upgradeTextField
        self.upgradeTextField.backgroundColor = UIColor(red: 1, green: 1, blue: 0.9, alpha: 1)
        self.upgradeTextField.layer.borderColor = UIColor(red: 1, green: 1, blue: 0.9, alpha: 1).cgColor
        self.upgradeTextField.layer.borderWidth = 5.0
        self.upgradeTextField.font = UIFont(name: "TimesNewRomanPSMT", size: 28)
        
        // priceTextField
        self.priceTextField.backgroundColor = UIColor(red: 1, green: 1, blue: 0.9, alpha: 1)
        self.priceTextField.layer.borderColor = UIColor(red: 1, green: 1, blue: 0.9, alpha: 1).cgColor
        self.priceTextField.layer.borderWidth = 5.0
        self.priceTextField.textColor = UIColor(red: 1, green: 0.7, blue: 0.2, alpha: 1)
        self.priceTextField.font = UIFont.boldSystemFont(ofSize: 34)
        
        // itemTextField
        self.itemTextField.backgroundColor = UIColor(red: 1, green: 1, blue: 0.9, alpha: 1)
        self.itemTextField.layer.borderColor = UIColor(red: 1, green: 1, blue: 0.9, alpha: 1).cgColor
        self.itemTextField.layer.borderWidth = 5.0
        self.itemTextField.font = UIFont.systemFont(ofSize: 18)
        // 下線を引く
        guard let targetText = itemTextField.text else {return}
        let attributedString = NSMutableAttributedString(string: targetText)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSString(string: targetText).range(of: targetText))
        itemTextField.attributedText = attributedString
        
        // itemExplainTextView
        self.itemExplainTextView.backgroundColor = UIColor(red: 1, green: 1, blue: 0.9, alpha: 1)
        self.itemExplainTextView.layer.borderColor = UIColor(red: 1, green: 1, blue: 0.9, alpha: 1).cgColor
        self.itemExplainTextView.layer.borderWidth = 1.0
        self.itemExplainTextView.textColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        self.itemExplainTextView.font = UIFont.systemFont(ofSize: 14)
        
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
}


