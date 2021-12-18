//
//  WorkingViewController.swift
//  20-20-20
//
//  Created by Yoko Kuroshima on 2021/12/06.
//

import UIKit
import AudioToolbox // サウンドを使用するため
import UICircularProgressRing // タイマーのプログレスバーを使用するため
import UserNotifications // Notificationsを使用するため

class TimerViewController: UIViewController, backgroundTimerDelegate {
    
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
    
    // タイマー起動中にバックグラウンドに移動したか
    var workingTimerIsBackground = false
    var restingTimerIsBackground = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SceneDelegateを取得
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else {
                  return
              }
        sceneDelegate.delegate = self
        
        // タイマーの作成、開始
        self.workingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(workingTimerMethod), userInfo: nil, repeats: true)
        
        // progressWorkingRing
        // プログレスバーの初期設定
        progressWorkingRing.maxValue = 1200
        progressWorkingRing.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
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
        progressRestingRing.maxValue = 20
        progressRestingRing.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
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
        self.progressWorkingRing.startProgress(to: 1200, duration: 1200)
        
        // 20分(1200秒)を経過したらタイマー音を再生&restingTimerMethodに移動
        if (workingElapsedTime == 1200) {
            // サウンド再生
            var soundIdLadder:SystemSoundID = 1026
            if let soundUrl = CFBundleCopyResourceURL(CFBundleGetMainBundle(), nil, nil, nil) {
                AudioServicesCreateSystemSoundID(soundUrl, &soundIdLadder)
                AudioServicesPlaySystemSound(soundIdLadder)
            }
            
            // ローカル通知の内容
            let restingNotification = UNMutableNotificationContent()
            restingNotification.title = "20 minutes have passed"
            restingNotification.body = "Look at something 20 feet away"
            restingNotification.sound = UNNotificationSound.default
            // 通知を表示
            let restingNotificationRequest = UNNotificationRequest(identifier: "immediately", content: restingNotification, trigger: nil)
            UNUserNotificationCenter.current().add(restingNotificationRequest, withCompletionHandler: nil)
            
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
        self.progressRestingRing.startProgress(to: 20, duration: 20)
        
        // 20秒経過したらタイマー音を再生&workingTimerMethodを実行
        if (restingElapsedTime == 20) {
            // サウンド再生
            var soundIdLadder:SystemSoundID = 1026
            if let soundUrl = CFBundleCopyResourceURL(CFBundleGetMainBundle(), nil, nil, nil) {
                AudioServicesCreateSystemSoundID(soundUrl, &soundIdLadder)
                AudioServicesPlaySystemSound(soundIdLadder)
            }
            
            // ローカル通知の内容
            let workingNotification = UNMutableNotificationContent()
            workingNotification.title = "20 seconds have passed"
            workingNotification.body = "You can back to work now"
            workingNotification.sound = UNNotificationSound.default
            // 通知を表示
            let workingNotificationRequest = UNNotificationRequest(identifier: "immediately", content: workingNotification, trigger: nil)
            UNUserNotificationCenter.current().add(workingNotificationRequest, withCompletionHandler: nil)
            
            // タイマーを初期化
            self.restingTimer.invalidate()
            self.restingElapsedTime = 0
            self.restingTimer = nil
            self.restingTimerPause = true
            // プログレスバーの色を初期状態に戻す
            self.progressRestingRing.resetProgress()
            
            // workingTimerMethodを実行
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
    
    // タイマー動作中にバックグラウンドへ移動した際の処理
    func checkBackground() {
        // 現在の時間を取得
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "en_US")
        // Woriking/Restingのどちらが起動中か確認
        if let _ = workingTimer {
            workingTimerIsBackground = true
            // タイマーの残り時間を計算
            let remainWorkingTime = 1200 - workingElapsedTime
            // 20分に到達したタイミングでローカル通知を出す
            let date2 = Date(timeInterval: TimeInterval(remainWorkingTime), since: date)
            let targetDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date2)
            // ローカル通知が発動するtriggerを作成
            let trigger = UNCalendarNotificationTrigger.init(dateMatching: targetDate, repeats: false)
            // ローカル通知の内容
            let workingNotification = UNMutableNotificationContent()
            workingNotification.title = "20 minutes have passed"
            workingNotification.body = "Tap here and start break time"
            workingNotification.sound = UNNotificationSound.default
            // 通知を表示
            let workingNotificationRequest = UNNotificationRequest(identifier: "immediately", content: workingNotification, trigger: trigger)
            UNUserNotificationCenter.current().add(workingNotificationRequest, withCompletionHandler: nil)
        } else if let _ = restingTimer {
            restingTimerIsBackground = true
            // タイマーの残り時間を計算
            let remainRestingTime = 20 - restingElapsedTime
            // 20秒に到達したタイミングでローカル通知を出す
            let date2 = Date(timeInterval: TimeInterval(remainRestingTime), since: date)
            let targetDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date2)
            // ローカル通知が発動するtriggerを作成
            let trigger = UNCalendarNotificationTrigger.init(dateMatching: targetDate, repeats: false)
            // ローカル通知の内容
            let restingNotification = UNMutableNotificationContent()
            restingNotification.title = "20 seconds have passed"
            restingNotification.body = "Tap here and start work"
            restingNotification.sound = UNNotificationSound.default
            // 通知を表示
            let restingNotificationRequest = UNNotificationRequest(identifier: "immediately", content: restingNotification, trigger: trigger)
            UNUserNotificationCenter.current().add(restingNotificationRequest, withCompletionHandler: nil)
        }
    }
    
    func setCurrentTimer(_ elapsedTime: Int) {
        if let _ = workingTimer {
            // 残り時間にバックグラウンドでの経過時間を足す
            workingElapsedTime += elapsedTime
            if (workingElapsedTime < 1200) {
                // workingタイマーを再始動
                self.workingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(workingTimerMethod), userInfo: nil, repeats: true)
            } else {
                
                // restingタイマーに遷移する
                self.restingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(restingTimerMethod), userInfo: nil, repeats: true)
                workingTimerIsBackground = false
                restingTimerIsBackground = true
                // タイマーを初期化
                self.workingTimer.invalidate()
                self.workingElapsedTime = 0
                self.workingTimer = nil
                self.workingTimerPause = true
                // プログレスバーの色を初期状態に戻す
                self.progressWorkingRing.resetProgress()
            }
        } else if let _ = restingTimer {
            // 残り時間にバックグラウンドでの経過時間を足す
            restingElapsedTime += elapsedTime
            if (restingElapsedTime < 20) {
                // restingタイマーを再始動
                self.restingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(restingTimerMethod), userInfo: nil, repeats: true)
            } else {
                // workingタイマーに遷移する
                self.workingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(workingTimerMethod), userInfo: nil, repeats: true)
                workingTimerIsBackground = true
                restingTimerIsBackground = false
                // タイマーを初期化
                self.restingTimer.invalidate()
                self.restingElapsedTime = 0
                self.restingTimer = nil
                self.restingTimerPause = true
                // プログレスバーの色を初期状態に戻す
                self.progressRestingRing.resetProgress()
            }
        }
    }
    
    func deleteTimer() {
        // 起動中のタイマーを破棄する
        if let _ = workingTimer {
            workingTimer.invalidate()
        } else if let _ = restingTimer {
            restingTimer.invalidate()
        }
    }
}
