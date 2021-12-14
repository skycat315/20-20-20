//
//  WorkingViewController.swift
//  20-20-20
//
//  Created by Yoko Kuroshima on 2021/12/06.
//

import UIKit
import AudioToolbox // サウンドを使用するため

class TimerViewController: UIViewController {
    
    // ステータス表示ラベル
    @IBOutlet weak var statusLabel: UILabel!
    // タイマー表示ラベル
    @IBOutlet weak var timerLabel: UILabel!
    
    // workingタイマー
    var workingTimer: Timer!
    // restingタイマー
    var restingTimer: Timer!
    
    // 一時停止用の変数
    var workingTimerPause: Bool = false
    var restingTimerPause: Bool = true
    
    // workingタイマー用の時間のための変数
    var workingElapsedTime: Int = 0
    // restingタイマー用の時間のための変数
    var restingElapsedTime: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // タイマーの作成、開始
        self.workingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(workingTimerMethod), userInfo: nil, repeats: true)
    }
    
    @objc func workingTimerMethod(_ timer: Timer) {
        // タイマーの一時停止を解除
        self.workingTimerPause = false
        self.workingElapsedTime += 1
        // 秒数
        let second = Int(self.workingElapsedTime) % 60
        // 分数
        let minute = Int(self.workingElapsedTime / 60)
        // タイマー表示
        self.timerLabel.text = String(format: "%02d : %02d", minute, second)
        // status表示
        self.statusLabel.text = String("Time to work")
        
        // 20分(1200秒)を経過したらタイマー音を再生&restingTimerMethodに移動
        if (workingElapsedTime == 10) {
            // サウンド再生
            var soundIdLadder:SystemSoundID = 1026
            if let soundUrl = CFBundleCopyResourceURL(CFBundleGetMainBundle(), nil, nil, nil) {
                AudioServicesCreateSystemSoundID(soundUrl, &soundIdLadder)
                AudioServicesPlaySystemSound(soundIdLadder)
            }
            // タイマーを初期化
            self.workingTimer.invalidate()
            self.workingElapsedTime = 0
            self.workingTimer = nil
            // restingTimerMethodに移動
            self.restingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(restingTimerMethod), userInfo: nil, repeats: true)
        }
    }
    
    @objc func restingTimerMethod(_ timer: Timer) {
        // タイマーの一時停止を解除
        self.restingTimerPause = false
        self.restingElapsedTime += 1
        // 秒数
        let second = Int(self.restingElapsedTime) % 60
        // 分数
        let minute = Int(self.restingElapsedTime) / 60
        // タイマー表示
        self.timerLabel.text = String(format: "%02d : %02d", minute, second)
        // status表示
        self.statusLabel.text = String("Time to take a break")
        
        // 20秒経過したらタイマー音を再生&workingTimerMethodに移動
        if (restingElapsedTime == 5) {
            // サウンド再生
            var soundIdLadder:SystemSoundID = 1026
            if let soundUrl = CFBundleCopyResourceURL(CFBundleGetMainBundle(), nil, nil, nil) {
                AudioServicesCreateSystemSoundID(soundUrl, &soundIdLadder)
                AudioServicesPlaySystemSound(soundIdLadder)
            }
            // タイマーを初期化
            self.restingTimer.invalidate()
            self.restingElapsedTime = 0
            self.restingTimer = nil
            // workingTimerMethodに移動
            self.workingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(workingTimerMethod), userInfo: nil, repeats: true)
            
        }
    }
    
    // Startボタン
    @IBAction func startTimer(_ sender: Any) {
        if (self.workingTimerPause == true && self.restingTimer == nil) {
            // workingタイマー再スタート
            self.workingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(workingTimerMethod), userInfo: nil, repeats: true)
            self.workingTimerPause = false
        } else if (self.restingTimerPause == true && self.workingTimer == nil) {
            // restingタイマー再スタート
            self.restingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(restingTimerMethod), userInfo: nil, repeats: true)
            self.restingTimerPause = false
        }
    }
    
    // Stopボタン
    @IBAction func stopTimer(_ sender: Any) {
        if (self.workingTimer != nil) {
            // workingタイマーを一時停止
            self.workingTimerPause = true
            self.workingTimer.invalidate()
            self.workingTimer = nil
        } else if (self.restingTimer != nil) {
            // restingタイマーを一時停止
            self.restingTimerPause = true
            self.restingTimer.invalidate()
            self.restingTimer = nil
        }
    }
    
    // Skipボタン
    @IBAction func skipTimer(_ sender: Any) {
        if (self.workingTimer != nil) {
            // タイマーを初期化する
            self.workingTimer.invalidate()
            self.workingElapsedTime = 0
            self.workingTimer = nil
            // restingタイマースタート
            self.restingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(restingTimerMethod), userInfo: nil, repeats: true)
        } else if (self.restingTimer != nil) {
            // タイマーを初期化する
            self.restingTimer.invalidate()
            self.restingElapsedTime = 0
            self.restingTimer = nil
            // workingタイマースタート
            self.workingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(workingTimerMethod), userInfo: nil, repeats: true)
        }
    }
    
    // Homeボタン
    @IBAction func backToHome(_ sender: Any) {
        // 動作中のタイマーを停止
        if (workingTimer != nil) {
            // タイマーを初期化する
            self.workingTimer.invalidate()
            self.workingElapsedTime = 0
            self.workingTimer = nil
        } else if (restingTimer != nil) {
            // タイマーを初期化する
            self.restingTimer.invalidate()
            self.restingElapsedTime = 0
            self.restingTimer = nil
        }
        // トップ画面に遷移する
        self.dismiss(animated: true, completion: nil)
    }
}
