//
//  Configform.swift
//  
//
//  Created by 井上正裕 on 2017/03/07.
//
//

import Eureka

class MyFormViewController: FormViewController {
    
    //CSVで読み出される
    var dataList:[String] = []
    var dataList2:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //CSVの読み込み
        do {
            //CSVファイルのパスを取得する。
            let csvPath = Bundle.main.path(forResource: "config", ofType: "csv")
            let csvPath2 = Bundle.main.path(forResource: "config2", ofType: "csv")
            
            //CSVファイルのデータを取得する。
            let csvData = try String(contentsOfFile:csvPath!, encoding:String.Encoding.utf8)
            let csvData2 = try String(contentsOfFile:csvPath2!, encoding:String.Encoding.utf8)
            
            //改行区切りでデータを分割して配列に格納する。
            dataList = csvData.components(separatedBy: "\n")
            dataList2 = csvData2.components(separatedBy: "\n")
            print (dataList2)
            
        } catch {
            print(error)
        }
        
        
        form +++ Section("基本設定")
            <<< TextRow(){ row in
                row.title = "出発地設定①"
                row.placeholder = "出発地を入力ください"
                row.value = dataList[0]
            }
            <<< TextRow(){
                $0.title = "出発地設定②"
                $0.placeholder = "出発地を入力ください"
            }

            +++ Section("カーシェア情報の設定")
            <<< ActionSheetRow<String>() {
                $0.title = "カーシァ会社選択"
                $0.selectorTitle = "Pick a number"
                $0.options = ["タイムズ","オリックス"]
                $0.value = "タイムズ"    // initially selected
            }
 
    }
}
