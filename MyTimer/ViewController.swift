//
//  ViewController.swift
//  MyTimer
//
//  Created by Sakurako Shimbori on 2020/06/23.
//  Copyright © 2020 Taisei Hikawa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //タイマーの変数を作成
    var timer : Timer?
    //カウント（経過時間）の変数を作成
    var count = 0
    //設定値を扱うキーを設定
    let settingKey = "timer_value"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //UserDefaultsnのインスタンスを生成
        let settings = UserDefaults.standard
        
        //UserDefaultsに初期値を設定
        
        settings.register(defaults: [settingKey:10])
    }

    @IBOutlet weak var countDownLabel: UILabel!
    
    @IBAction func settingButtonAction(_ sender: Any) {
        //timerをアンラップしてnowTimerに代入
        if let nowTimer = timer{
            //もしタイマーが、実行中だったら停止
            if nowTimer.isValid == true{
                //タイマー停止
                nowTimer.invalidate()
            }
        }
        performSegue(withIdentifier: "goSetting", sender: nil)
    }
    
    @IBAction func startButtonAction(_ sender: Any) {
        //timerをアンラップしてnowTimerに代入
        if let nowTimer = timer{
            //もしタイマーが、実行中だったらスタートしない
            if nowTimer.isValid == true{
                //何もしない
                return
            }
        }
        
        //タイマーをスタート
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerInterrupt(_:)), userInfo: nil, repeats: true)
    }
    
    @IBAction func stopButtonAction(_ sender: Any) {
        
        if let nowTimer = timer {
            //もしタイマーが、実行中だったら停止
            if nowTimer.isValid == true{
                //タイマー停止
                nowTimer.invalidate()
            }
        }
    }
    
    func displayUpdate() -> Int{
        //UserDefaultsのインスタンスを作成
        let settings = UserDefaults.standard
        //取得した秒数をtimerValueに渡す
        let timerValue = settings.integer(forKey: settingKey)
        //残り時間(remainCount)を生成
        let remainCount = timerValue - count
        //remainCount(残り時間)をラベルに表示
        countDownLabel.text = "残り\(remainCount)秒"
        //残り時間を戻り値に設定
        return remainCount
    }
    
    //経過時間の処理
    @objc func timerInterrupt(_ timer:Timer){
        //経過時間に１足してく
        count += 1;
        
        //残り時間が０以下の時に、タイマーを止める
        if displayUpdate() <= 0{
            //初期化
            count = 0
            //タイマー停止
            timer.invalidate()
            
            //ダイアログを作成
            let alertController = UIAlertController(title: "終了", message: "タイマー終了時間です", preferredStyle: .alert)
            //ダイアログに表示させるOKボタンを作成
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            //アクションを追加
            alertController.addAction(alertAction)
            //ダイアログの表示
            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    //画面切り替えのタイミングで処理を行う
    override func viewDidAppear(_ animated: Bool) {
        //カウントをゼロにする
        count = 0
        //タイマーの表示を更新する
        _ = displayUpdate()

    }
}

