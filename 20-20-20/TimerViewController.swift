//
//  WorkingViewController.swift
//  20-20-20
//
//  Created by Yoko Kuroshima on 2021/12/06.
//

import UIKit
import AudioToolbox // サウンドを使用するため
import UICircularProgressRing // タイマーのプログレスバーを使用するため

class TimerViewController: UIViewController {
    
    // ステータス表示ラベル
    @IBOutlet weak var statusLabel: UILabel!
    // タイマー表示ラベル
    @IBOutlet weak var timerLabel: UILabel!
    
    // タイマー
    var workingTimer: Timer!
    var restingTimer: Timer!
    
    // 一時停止用の変数
    var workingTimerPause: Bool = false
    var restingTimerPause: Bool = true
    
    // タイマー用の時間のための変数
    var workingElapsedTime: Int = 0
    var restingElapsedTime: Int = 0
    
    // プログレスバー
    var progressWorkingRing = UICircularProgressRing()
    var progressRestingRing = UICircularProgressRing()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // タイマーの作成、開始
        self.workingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(workingTimerMethod), userInfo: nil, repeats: true)
        
        // progressWorkingRing
        // プログレスバーの初期設定
        progressWorkingRing.maxValue = 10
        progressWorkingRing.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        progressWorkingRing.center = self.view.center
        self.view.addSubview(progressWorkingRing)
        // リング中の%を非表示にする
        progressWorkingRing.shouldShowValueText = false
        // バーの色を変更
        progressWorkingRing.outerRingColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        progressWorkingRing.innerRingColor = UIColor(red: 0.7, green: 0.7, blue: 1, alpha: 1)
        // バーの始点をリング上部に変更
        progressWorkingRing.startAngle = 270
        
        // progressRestingRing
        // プログレスバーの初期設定
        progressRestingRing.maxValue = 5
        progressRestingRing.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        progressRestingRing.center = self.view.center
        self.view.addSubview(progressRestingRing)
        // リング中の%を非表示にする
        progressRestingRing.shouldShowValueText = false
        // バーの色を変更
        progressRestingRing.outerRingColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        progressRestingRing.innerRingColor = UIColor(red: 1, green: 0.6, blue: 0.7, alpha: 1)
        // バーの始点をリング上部に変更
        progressRestingRing.startAngle = 270
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
        // プログレスバー表示
        self.progressWorkingRing.startProgress(to: 10, duration: 10)
        
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
            self.workingTimerPause = true
            // プログレスバーを初期化
            self.progressWorkingRing.resetProgress()
            // restingTimerMethodを実行
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
        // プログレスバー表示
        self.progressRestingRing.startProgress(to: 5, duration: 5)
        
        // 20秒経過したらタイマー音を再生&workingTimerMethodを実行
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
            self.restingTimerPause = true
            // プログレスバーの色を初期状態に戻す
            self.progressRestingRing.resetProgress()
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
            // プログレスタイマー再スタート
            self.progressWorkingRing.continueProgress()
        } else if (self.restingTimerPause == true && self.workingTimer == nil) {
            // restingタイマー再スタート
            self.restingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(restingTimerMethod), userInfo: nil, repeats: true)
            self.restingTimerPause = false
            // プログレスタイマー再スタート
            self.progressRestingRing.continueProgress()
        }
    }
    
    // Stopボタン
    @IBAction func stopTimer(_ sender: Any) {
        if (self.workingTimer != nil) {
            // workingタイマーを一時停止
            self.workingTimerPause = true
            self.workingTimer.invalidate()
            self.workingTimer = nil
            // プログレスタイマーを一時停止
            self.progressWorkingRing.pauseProgress()
        } else if (self.restingTimer != nil) {
            // restingタイマーを一時停止
            self.restingTimerPause = true
            self.restingTimer.invalidate()
            self.restingTimer = nil
            // プログレスタイマーを一時停止
            self.progressRestingRing.pauseProgress()
        }
    }
    
    // Skipボタン
    @IBAction func skipTimer(_ sender: Any) {
        if (self.workingTimer != nil) {
            // タイマーを初期化する
            self.workingTimer.invalidate()
            self.workingElapsedTime = 0
            self.workingTimer = nil
            // プログレスタイマーを初期化する
            self.progressWorkingRing.resetProgress()
            // restingタイマースタート
            self.restingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(restingTimerMethod), userInfo: nil, repeats: true)
        } else if (self.restingTimer != nil) {
            // タイマーを初期化する
            self.restingTimer.invalidate()
            self.restingElapsedTime = 0
            self.restingTimer = nil
            // プログレスタイマーを初期化する
            self.progressRestingRing.resetProgress()
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
