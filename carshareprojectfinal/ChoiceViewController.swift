//
//  ChoiceViewController.swift
//  FrostedSidebar
//
//  Created by 井上正裕 on 2017/02/24.
//  Copyright © 2017年 Evan Dekhayser. All rights reserved.
//

import UIKit

var checkindate = ""
var checkoutdate = ""
var hotelname = ""

class ChoiceViewController: UIViewController,UITextFieldDelegate  {
    
    let test = TableViewController()
    var tag : Int = 0



    @IBOutlet weak var bkimg: UIImageView!


 
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var textField2: UITextField!
    
    @IBOutlet weak var searchField: UITextField!
    

    
    @IBAction func pickerchoice(_ sender: UITextField) {
        
        switch (sender as AnyObject).tag {
        case 0:
            tag = 0
            textField.placeholder = dateToString(date: Date()) //<-`dateToString`のパラメータは`Date`型なので最初から`Date()`を渡す
            textField.text        = dateToString(date: Date()) //<-同上
            self.view.addSubview(textField)
            textField.inputView = myDatePicker
            textField.inputAccessoryView = toolBar
        case 1:
            tag = 1
            textField2.placeholder = dateToString(date: Date()) //<-`dateToString`のパラメータは`Date`型なので最初から`Date()`を渡す
            textField2.text        = dateToString(date: Date()) //<-同上
            self.view.addSubview(textField2)
            textField2.inputView = myDatePicker
            textField2.inputAccessoryView = toolBar
        default:
            break
        }
    }
  

    

    //変数を宣言する
    var toolBar:UIToolbar!
    var myDatePicker: UIDatePicker!


    override func viewDidLoad() {
        super.viewDidLoad()
        //エラー回避のため初期を入力欄の設定
        textField.text = "日付を選択ください"
        textField2.text = "日付を選択ください"
        searchField.text = ""
        
        
        bkimg.image = UIImage(named: "travel.jpg")
        self.view.sendSubview(toBack: bkimg)
        textField.backgroundColor = UIColor.clear
        textField2.backgroundColor = UIColor.clear
        
        //ここからpicker
        // 入力欄の設定
        
        // UIDatePickerの設定
        myDatePicker = UIDatePicker()
        myDatePicker.addTarget(self, action: #selector(changedDateEvent), for: UIControlEvents.valueChanged)
        myDatePicker.datePickerMode = UIDatePickerMode.date
        
        
        // UIToolBarの設定
        toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = .blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.black
        
        let toolBarBtn      = UIBarButtonItem(title: "完了", style: .plain, target: self, action: #selector(tappedToolBarBtn))
        let toolBarBtnToday = UIBarButtonItem(title: "今日", style: .plain, target: self, action: #selector(tappedToolBarBtnToday))
        toolBarBtn.tag = 1
        toolBar.items = [toolBarBtnToday,toolBarBtn ]

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        

    }
    

    
    // 「完了」を押すと閉じる
    func tappedToolBarBtn(_ sender: UIBarButtonItem) {
        textField.resignFirstResponder()
        textField2.resignFirstResponder()
    }
    // 「今日」を押すと今日の日付をセットする
    func tappedToolBarBtnToday(_ sender: UIBarButtonItem) {
        myDatePicker.date = Date()  //<-Date型のプロパティに現在時刻を入れるなら`Date()`を渡すだけでOK
        changeLabelDate(date: Date())  //<-Date型の引数に現在時刻を渡すときも同じく`Date()`だけでOK
    }
    func changedDateEvent(_ sender: UIDatePicker){ //<- `UIDatePicker`からのactionの`sender`は必ず`UIDatePicker`になる
        //`sender`を直接`UIDatePicker`として使えばいいのでキャストは不要
        self.changeLabelDate(date: sender.date)
    }
    
    func changeLabelDate(date: Date) { //<- `NSDate`を使っているところは全て`Date`に置き換える
        if tag == 0{
        textField.text = self.dateToString(date: date)
        } else {
        textField2.text = self.dateToString(date: date)
        }
    }
    
    func dateToString(date: Date) -> String {
        //DateFormatterは参照型なので、letが適切
        let date_formatter = DateFormatter()
        let send_date_formatter = DateFormatter()
        //曜日の1文字表記をしたいならweekdaysなんて配列はいらない
        
        date_formatter.locale     = Locale(identifier: "ja")
        date_formatter.dateFormat = "yyyy年MM月dd日（E） " //<-`E`は曜日出力用のフォーマット文字
        send_date_formatter.dateFormat = "yyyy-MM-dd"
        print (send_date_formatter)
        if tag == 0{
        checkindate = send_date_formatter.string(from: date as Date)
        }else{
        checkoutdate = send_date_formatter.string(from: date as Date)
        }
        return date_formatter.string(from: date as Date)
    }

    @IBAction func hotelname(_ sender: UITextField) {
    }

    //ここで値の受け渡し
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let tableViewController:TableViewController = segue.destination as! TableViewController

        tableViewController.input = searchField.text!
        tableViewController.checkindate = checkindate
        tableViewController.checkoutdate = checkoutdate
    }

    
    
}
