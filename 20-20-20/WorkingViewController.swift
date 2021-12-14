//
//  WorkingViewController.swift
//  20-20-20
//
//  Created by Yoko Kuroshima on 2021/12/06.
//

import UIKit
import AudioToolbox // サウンドを使用するため

class WorkingViewController: UIViewController {
    
    @IBOutlet weak var workingTimerLabel: UILabel!
    
    // タイマー
    var workingTimer: Timer!
    
    // タイマー用の時間のための変数
    var elapsedWorkingTime: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // タイマーの作成、開始
        self.workingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(workingTimerMethod), userInfo: nil, repeats: true)
    }
    
    @objc func workingTimerMethod(_ timer: Timer) {
        self.elapsedWorkingTime += 1
        // 秒数
        let second = Int(self.elapsedWorkingTime) % 60
        // 分数
        let minite = Int(self.elapsedWorkingTime / 60)
        self.workingTimerLabel.text = String(format: "%02d : %02d", minite, second)
        
        // 20分(1200秒)を経過したらタイマー音を再生&RestingViewControllerへ遷移する
        if (elapsedWorkingTime == 10) {
            // サウンド再生
            var soundIdLadder:SystemSoundID = 1026
            if let soundUrl = CFBundleCopyResourceURL(CFBundleGetMainBundle(), nil, nil, nil) {
                AudioServicesCreateSystemSoundID(soundUrl, &soundIdLadder)
                AudioServicesPlaySystemSound(soundIdLadder)
            }
            // タイマーを初期化
            self.workingTimer = nil
            // RestingViewControllerへ遷移
            self.performSegue(withIdentifier: "toRestingTimer", sender: self)
        }
    }
    
    // Startボタン
    @IBAction func startWorkingTimer(_ sender: Any) {
        if self.workingTimer == nil {
            // タイマー再スタート
            self.workingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(workingTimerMethod), userInfo: nil, repeats: true)
        }
    }
    
    // Stopボタン
    @IBAction func stopWorkingTimer(_ sender: Any) {
        if self.workingTimer != nil {
            // タイマーを一時停止
            self.workingTimer.invalidate()
            self.workingTimer = nil
        }
    }
    
    // Skipボタン
    @IBAction func skipWorkingTimer(_ sender: Any) {
        // RestingViewControllerに遷移
        self.performSegue(withIdentifier: "toRestingTimer", sender: self)
        // タイマーを初期化する
        self.elapsedWorkingTime = 0
        if self.workingTimer != nil {
            self.workingTimer.invalidate()
            self.workingTimer = nil
        }
    }
    
    // Homeボタン
    @IBAction func workingTimerToHome(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
