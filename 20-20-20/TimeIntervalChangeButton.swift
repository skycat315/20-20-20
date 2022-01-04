//
//  TimeIntervalChangeButton.swift
//  20-20-20
//
//  Created by Yoko Kuroshima on 2021/12/25.
//

import UIKit
import CoreMIDI
import AudioToolbox

class TimeIntervalChangeButton: UIButton {
    
    var selectView: UIView! = nil
    
    required init?(coder aDecoder:  NSCoder) {
        super.init(coder: aDecoder)
        
        myInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        myInit()
    }
    
    func myInit() {
        
        // ボタンを押している間、ボタンを暗くする
        selectView = UIView(frame: self.bounds)
        selectView.backgroundColor = UIColor.black
        selectView.alpha = 0
        self.addSubview(selectView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectView.frame = self.bounds
    }
    
    // タッチ開始
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        UIView.animate(withDuration: 0.1, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {() -> Void in
            
            self.selectView.alpha = 0.5
            
        }, completion: {(finished: Bool) -> Void in
        })
    }
    
    // タッチ終了
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        UIView.animate(withDuration: 0.1, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {() -> Void in
            
            self.selectView.alpha = 0
            
        }, completion: {(finished: Bool) -> Void in
            
        })
    }
}
