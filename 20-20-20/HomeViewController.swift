//
//  HomeViewController.swift
//  20-20-20
//
//  Created by Yoko Kuroshima on 2021/12/06.
//

import UIKit
import Accounts

class HomeViewController: UIViewController {
    
    // shareボタン
    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // shareボタンの色
        self.shareBarButtonItem.tintColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        
    }
    
    //シェアアイコン
    @IBAction func share(_ sender: Any) {
        
        let shareText = "20-20-20 for your eyes"
        let shareWebsite = NSURL(string: "https://apps.apple.com/jp/app/20-20-20-for-your-eyes/id1602228878?l=en")!
        let shareImage = UIImage(named: "Icon")!
        
        let activityItems: Array<Any> = [shareText, shareWebsite, shareImage]
        
        // 初期化処理
        let activityVC: UIActivityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, activityError: Error?) in
            
            guard completed else {return}
            
            switch activityType {
            case UIActivity.ActivityType.postToTwitter:
                print("Tweeted")
            case UIActivity.ActivityType.print:
                print("Printed")
            case UIActivity.ActivityType.saveToCameraRoll:
                print("Save to Camera Roll")
            default:
                print("Done")
            }
        }
        
        // UIActivityViewControllerを表示
        self.present(activityVC, animated: true, completion: nil)
    }
}
