//
//  NavigationBarController.swift
//  20-20-20
//
//  Created by Yoko Kuroshima on 2021/12/18.
//

import UIKit

class NavigationBarController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ナビゲーションバーの背景色
        navigationBar.barTintColor = UIColor(red: 0.9, green: 0.9, blue: 0.8, alpha: 1)
        
    }
}
