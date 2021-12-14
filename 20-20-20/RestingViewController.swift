//
//  RestingViewController.swift
//  20-20-20
//
//  Created by Yoko Kuroshima on 2021/12/06.
//

import UIKit
import AudioToolbox // サウンドを使用するため

class RestingViewController: UIViewController {
    
    @IBOutlet weak var restingTimerLabel: UILabel!
    
    // タイマー
    var restingTimer: Timer!
    
    // タイマー用の時間のための変数
    var elapsedRestingTime: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // タイマーの作成、開始
        self.restingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(restingTimerMethod), userInfo: nil, repeats: true)
    }
    
    @objc func restingTimerMethod(_ timer: Timer) {
        self.elapsedRestingTime += 1
        // 秒数
        let second = Int(self.elapsedRestingTime) % 60
        // 分数
        let minite = Int(self.elapsedRestingTime / 60)
        self.restingTimerLabel.text = String(format: "%02d : %02d", minite, second)
        
        // 20秒を経過したらサウンド再生&WorkingViewControllerへ遷移する
        if (elapsedRestingTime == 5) {
            // サウンド再生
            var soundIdLadder:SystemSoundID = 1026
            if let soundUrl = CFBundleCopyResourceURL(CFBundleGetMainBundle(), nil, nil, nil) {
                AudioServicesCreateSystemSoundID(soundUrl, &soundIdLadder)
                AudioServicesPlaySystemSound(soundIdLadder)
            }
            // タイマーを初期化
            self.restingTimer = nil
            // WorkingViewControllerへ遷移
            self.performSegue(withIdentifier: "toWorkingTimer", sender: self)
        }
    }
    
    // Startボタン
    @IBAction func startRestingTimer(_ sender: Any) {
        if self.restingTimer == nil {
            // タイマー再スタート
            self.restingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(restingTimerMethod), userInfo: nil, repeats: true)
        }
    }
    
    // Stopボタン
    @IBAction func stopRestingTimer(_ sender: Any) {
        if self.restingTimer != nil {
            // タイマーを一時停止
            self.restingTimer.invalidate()
            self.restingTimer = nil
        }
    }
    
    // Skipボタン
    @IBAction func skipRestingTimer(_ sender: Any) {
        // RestingViewControllerに遷移
        self.performSegue(withIdentifier: "toWorkingTimer", sender: self)
        // タイマーを初期化する
        self.elapsedRestingTime = 0
        if self.restingTimer != nil {
            self.restingTimer.invalidate()
            self.restingTimer = nil
        }
    }
    
    // Homeボタン
    @IBAction func restingTimerToHome(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
