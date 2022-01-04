//
//  SettingTableViewController.swift
//  20-20-20
//
//  Created by Yoko Kuroshima on 2021/12/21.
//

import UIKit

class SettingTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var workPickerView: UIPickerView!
    @IBOutlet weak var restPickerView: UIPickerView!
    @IBOutlet var timeIntervalTableView: UITableView!
    @IBOutlet weak var changeButton: TimeIntervalChangeButton!
    
    // AppDelegateのインスタンスを作成
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var workingTimeList = ["5:00", "10:00", "15:00", "20:00", "25:00", "30:00", "35:00", "40:00", "45:00", "50:00", "55:00", "60:00"]
    var restingTimeList = ["0:05", "0:10", "0:15", "0:20", "0:25", "0:30", "0:35", "0:40", "0:45", "0:50", "0:55", "1:00"]
    
    // 選択されたtime interval
    var chosenWorkTime: Int = 5
    var chosenRestTime: Int = 5
    
    // 変更後のtime interval
    var setWorkTime: Int = 0
    var setRestTime: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegate設定
        workPickerView.delegate = self
        workPickerView.dataSource = self
        workPickerView.tag = 1
        restPickerView.delegate = self
        restPickerView.delegate = self
        restPickerView.tag = 2
        
        // セルの高さを設定
        //timeIntervalTableView.rowHeight = 70.0
        timeIntervalTableView.frame = CGRect(x: 0, y: 0, width: 5, height: 70)
        
        // 設定ボタン
        if AppStoreClass.shared.isPurchased == false {
            self.changeButton.setTitle("🔒Change", for: .normal)
        } else {
            self.changeButton.setTitle("Change", for: .normal)
        }
    }
        
        // 表示するリストの数
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        // 表示する配列の数
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if pickerView.tag == 1 {
                return workingTimeList.count
            } else {
                return restingTimeList.count
            }
        }
        
        // データを返すメソッド
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if pickerView.tag == 1 {
                return workingTimeList[row]
            } else {
                return restingTimeList[row]
            }
        }
        
        // データが選択された時のメソッド
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if pickerView.tag == 1 {
                // workingタイマー
                if (workingTimeList[row] == "5:00") {
                    chosenWorkTime = 300
                } else if (workingTimeList[row] == "10:00") {
                    chosenWorkTime = 600
                } else if (workingTimeList[row] == "15:00") {
                    chosenWorkTime = 900
                } else if (workingTimeList[row] == "20:00") {
                    chosenWorkTime = 1200
                } else if (workingTimeList[row] == "25:00") {
                    chosenWorkTime = 1500
                } else if (workingTimeList[row] == "30:00") {
                    chosenWorkTime = 1800
                } else if (workingTimeList[row] == "35:00") {
                    chosenWorkTime = 2100
                } else if (workingTimeList[row] == "40:00") {
                    chosenWorkTime = 2400
                } else if (workingTimeList[row] == "45:00") {
                    chosenWorkTime = 2700
                } else if (workingTimeList[row] == "50:00") {
                    chosenWorkTime = 3000
                } else if (workingTimeList[row] == "55:00") {
                    chosenWorkTime = 3300
                } else {
                    chosenWorkTime = 3600
                }
            } else {
                // restingタイマー
                if (restingTimeList[row] == "0:05") {
                    chosenRestTime = 5
                } else if (restingTimeList[row] == "0:10") {
                    chosenRestTime = 10
                } else if (restingTimeList[row] == "0:15") {
                    chosenRestTime = 15
                } else if (restingTimeList[row] == "0:20") {
                    chosenRestTime = 20
                } else if (restingTimeList[row] == "0:25") {
                    chosenRestTime = 25
                } else if (restingTimeList[row] == "0:30") {
                    chosenRestTime = 30
                } else if (restingTimeList[row] == "0:35") {
                    chosenRestTime = 35
                } else if (restingTimeList[row] == "0:40") {
                    chosenRestTime = 40
                } else if (restingTimeList[row] == "0:45") {
                    chosenRestTime = 45
                } else if (restingTimeList[row] == "0:50") {
                    chosenRestTime = 50
                } else if (restingTimeList[row] == "0:55") {
                    chosenRestTime = 55
                } else {
                    chosenRestTime = 60
                }
            }
            print("chosenWorkTime:", chosenWorkTime)
            print("chosenRestTime:", chosenRestTime)
        }
        
        @IBAction func changeButton(_ sender: Any) {
            if AppStoreClass.shared.isPurchased == false {
                // 購入前の場合はPurchaseページに誘導
                self.performSegue(withIdentifier: "toPurchasePage", sender: self)
                return
            } else if AppStoreClass.shared.isPurchased == true {
                // 購入済の場合はtime intevalの変更が可能
                // 変更を確定
                setWorkTime = chosenWorkTime
                setRestTime = chosenRestTime
                // 設定したデータをAppDelegateの変数に代入
                appDelegate.newWorkTime = setWorkTime
                appDelegate.newRestTime = setRestTime
                // 動作確認用
                print("setWorkTime:", setWorkTime)
                print("setRestTime:", setRestTime)
            }
        }
    }
