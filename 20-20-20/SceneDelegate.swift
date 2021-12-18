//
//  SceneDelegate.swift
//  20-20-20
//
//  Created by Yoko Kuroshima on 2021/12/06.
//

import UIKit

// デリゲート用の変数、関数
protocol backgroundTimerDelegate: AnyObject {
    func checkBackground()
    func setCurrentTimer(_ elapsedTime: Int)
    func deleteTimer()
    var workingTimerIsBackground: Bool { set get }
    var restingTimerIsBackground: Bool { set get }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    weak var delegate: backgroundTimerDelegate?
    let ud = UserDefaults.standard
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    // アプリ画面に復帰した時
    func sceneDidBecomeActive(_ scene: UIScene) {
        if delegate?.workingTimerIsBackground == true {
            let calender = Calendar(identifier: .gregorian)
            let date1 = ud.value(forKey: "date1") as! Date
            let date2 = Date()
            let elapsedTime = calender.dateComponents([.second], from: date1, to: date2).second!
            delegate?.setCurrentTimer(elapsedTime)
        } else if delegate?.restingTimerIsBackground == true {
            let calender = Calendar(identifier: .gregorian)
            let date1 = ud.value(forKey: "date1") as! Date
            let date2 = Date()
            let elapsedTime = calender.dateComponents([.second], from: date1, to: date2).second!
            delegate?.setCurrentTimer(elapsedTime)
        }
    }
    
    // アプリ画面から離れる時
    func sceneWillResignActive(_ scene: UIScene) {
        ud.set(Date(), forKey: "date1")
        delegate?.checkBackground()
        delegate?.deleteTimer()
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

