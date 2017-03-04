//
//  CaluclatarViewController.swift
//  FrostedSidebar
//
//  Created by 井上正裕 on 2017/02/25.
//  Copyright © 2017年 Evan Dekhayser. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

var distanceval : String?
//ピッカーで選択した
var componentday : Int = 0
var dayrrow : Int = 0
var componenthour : Int = 0
var hourrow : Int = 0
var componenttime : Int = 0
var timerow : Int = 0
var utilhour: Double = 0

class CaluclatarViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIToolbarDelegate{
    
    //初期設定
    
    @IBOutlet weak var StartPoint: UITextField!

    @IBOutlet weak var EndPoint: UITextField!
   

    @IBOutlet weak var utilTime: UITextField!
    @IBOutlet weak var cailfare: UILabel!
    

    //ここら辺はテキストフィールドの初期設定//
    //エンターキーを押した際の動作
    //主発地テキストフィールドタップ時の動作
    @IBAction func getStart(_ sender: Any) {
    }
    //目的地テキストフィールドタップ時の動作
    @IBAction func GetEnd(_ sender: Any) {
    }

    
    //初期値
    let key = APIkey()
    let DirectionsUrl : String = "https://maps.googleapis.com/maps/api/directions/json?"
    let region = "ja"
    let carshare = calculationfare()
    //タイムズカーシェアの料金
    var timesfare = 0

    
    
    
    // UIPickerView.
    var myUIPicker: UIPickerView!
    
    var toolBar:UIToolbar!
    
    // 表示する値の配列.
    let myValues = [["","1日","2日"],["","1時間","2時間","3時間","4時間","5時間","6時間","7時間","8時間","9時間","10時間","11時間","12時間","13時間","14時間","15時間","16時間","17時間","18時間","19時間","20時間","21時間","22時間","23時間"],["","15分","30分","45分"]]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //出発地登録
        StartPoint.text = StartPoint_text
        //ここからpicker
        // UIPickerViewを生成.
        myUIPicker = UIPickerView()
        
        // サイズを指定する.
        myUIPicker.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 160.0)
        
        // Delegateを設定する.
        myUIPicker.delegate = self
        
        // DataSourceを設定する.
        myUIPicker.dataSource = self
        
        // Viewに追加する.
        let vi = UIView(frame: myUIPicker.bounds)
        vi.backgroundColor = UIColor.white
        vi.addSubview(myUIPicker)
       utilTime.inputView = vi
        
        
        //self.view.addSubview(myUIPicker)
        //utilTime.inputView = myUIPicker
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        let doneButton   = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(CaluclatarViewController.donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CaluclatarViewController.cancelPressed))
        let spaceButton  = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        utilTime.inputAccessoryView = toolBar
        
    }
    
    // Done
    func donePressed() {
        //print (componentday)
        //print (componenthour)
        //print (componenttime)
        utilhour = Double(dayrrow*24*60 + hourrow*60 + timerow*15)/60.0
        utilTime.text = String("\(utilhour) 時間")
        view.endEditing(true)
    }
    
    // Cancel
    func cancelPressed() {
        utilTime.text = ""
        view.endEditing(true)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    /*
     pickerに表示する行数を返すデータソースメソッド.
     (実装必須)
     */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myValues[component].count
    }
    
    /*
     pickerに表示する値を返すデリゲートメソッド.
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myValues[component][row] as? String
    }
    
    /*
     pickerが選択された際に呼ばれるデリゲートメソッド.
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let queque = DispatchQueue.main
        //処理①　APIの実行
        queque.async {
        if component == 0{
            componentday = component
            dayrrow = row
        }
        if component == 1{
            componenthour = component
            hourrow = row
        }
        if component == 2{
            componenttime = component
            timerow = row
        }
        }
        queque.async {
        let timecalc = self.carshare.timecalc(componentday : componentday, dayrrow : dayrrow, componenthour : componenthour, hourrow : hourrow, componenttime : componenttime,timerow : timerow)
        //print (timecalc)
        }
        //print("component:\(component),row: \(row)")
        //print("value: \(myValues[row])")
        utilTime.text = ""

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func calculation(_ sender: Any) {
        //初期か
        self.cailfare.text = ""
        
        let keyG = key.GoogleAPIkey()
        //APIで利用するためエンコーディング
        let Start = (StartPoint.text!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let End = (EndPoint.text!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        
        
        //エラーハンドリング処理はまだ
  
        
        var GetDirectionsUrl = DirectionsUrl + "origin=" + Start! + "&destination=" + End! + "&region=" + region + "&key=" + keyG
        var distanceval: Double = 0.0
        print (GetDirectionsUrl)

        //ここから入力された２点間の距離を求める
        let queque = DispatchQueue.main
        //処理①　APIの実行
        queque.async {
            
            Alamofire.request(GetDirectionsUrl).responseJSON{response in
                let json = JSON(response.result.value ?? 0)
                print (json)
                if  json["status"] != "INVALID_REQUEST"{
                let routes = json["routes"]
                let json2 = routes[0]
                let legs = json2["legs"]
                let json3 = legs[0]
                let distance = json3["distance"]
                let distanceval = Double(distance["value"].int!)
                }
                
                //
                queque.async {
                    //ここで計算処理
                    //処理①利用時間の取得
                    let timecalc = self.carshare.timecalc(componentday : componentday, dayrrow : dayrrow, componenthour : componenthour, hourrow : hourrow, componenttime : componenttime,timerow : timerow)
                    print(distanceval)

                    //処理②利用料金を算出
                   self.timesfare = self.carshare.TimesSharingFare(time : Double(timecalc), distance : distanceval/1000 )
                    self.cailfare.text = String(self.timesfare)
                }
            }
            
        }
        
        
        
    }
//    
    //ここで値の受け渡し
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let chartViewController:ChartViewController = segue.destination as! ChartViewController
        //グラフのx軸の数を取得
        let timecalc = self.carshare.timecalc(componentday : componentday, dayrrow : dayrrow, componenthour : componenthour, hourrow : hourrow, componenttime : componenttime,timerow : timerow)
        
        let farelist = self.carshare.faresimulation(datapoint : timecalc, distance : 20.0)
        print (farelist)
        //処理②利用料金を算出
        //self.timesfare = self.carshare.TimesSharingFare(time : Double(timecalc), distance : distanceval/1000 )
        self.cailfare.text = String(self.timesfare)
        chartViewController.timepoints = timecalc
        chartViewController.farepoints = farelist
        //tableViewController.input = searchField.text!
        //tableViewController.checkindate = checkindate!
        //tableViewController.checkoutdate = checkoutdate!
    }

    
    
    
    
    
}
