//
//  TabBarController.swift
//  20-20-20
//
//  Created by Yoko Kuroshima on 2021/12/10.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // タブアイコンの色
        self.tabBar.tintColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        // タブバーの背景色
        self.tabBar.barTintColor = UIColor(red: 0.9, green: 0.9, blue: 0.8, alpha: 1)
        
        // UITabBarControllerDelegateプロトコルのメソッドをこのクラスで処理する
        self.delegate = self
    }
    
    // タブバーのアイコンがタップされた時に呼ばれるdelegateメソッドを処理する
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is TimerViewController {
            // WorkingViewControllerはタブ切り替えではなくモーダル画面遷移する
            let WorkingViewController = storyboard!.instantiateViewController(withIdentifier: "Working")
            present(WorkingViewController, animated: true)
            return false
        } else {
            // 通常のタブ切り替えを実施
            return true
        }
    }
}
