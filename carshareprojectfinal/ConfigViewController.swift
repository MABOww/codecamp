//
//  ConfigViewController.swift
//  FrostedSidebar
//
//  Created by 井上正裕 on 2017/02/27.
//  Copyright © 2017年 Evan Dekhayser. All rights reserved.
//

import UIKit

class ConfigViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //CSVで読み出される
    var dataList:[String] = []
    var dataList2:[String] = []
    
    // Sectionで使用する配列を定義する.
    private let mySections: NSArray = ["出発地設定", "カーシェア会社"]
    
    
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
        //
        
        
        
        // Status Barの高さを取得を.する.
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        
        // Viewの高さと幅を取得する.
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        // TableViewの生成( status barの高さ分ずらして表示 ).
        let myTableView: UITableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        
        // Cell名の登録をおこなう.
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        // DataSourceの設定をする.
        myTableView.dataSource = self
        
        // Delegateを設定する.
        myTableView.delegate = self
        
        // Viewに追加する.
        self.view.addSubview(myTableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     セクションの数を返す.
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return mySections.count
    }
    
    /*
     セクションのタイトルを返す.
     */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mySections[section] as? String
    }
    
    /*
     Cellが選択された際に呼び出される.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            print("Value: \(dataList[indexPath.row])")
        } else if indexPath.section == 1 {
            print("Value: \(dataList2[indexPath.row])")
        }
    }
    
    /*
     テーブルに表示する配列の総数を返す.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dataList.count
        } else if section == 1 {
            return dataList2.count
        } else {
            return 0
        }
    }
    
    /*
     Cellに値を設定する.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        //カンマでデータを分割して配列に格納する。
        let dataDetail = dataList[indexPath.row].components(separatedBy: ",")
        let dataDetail2 = dataList2[indexPath.row].components(separatedBy: ",")
        print (dataDetail2)
        if indexPath.section == 0 {
            cell.textLabel?.text = "\(dataDetail[0])"
        } else if indexPath.section == 1 {
            cell.textLabel?.text = "\(dataDetail2[0])"
        }
        
        return cell
    }
    
    // スワイプ削除
    func tableView(tableView: UITableView,canEditRowAtIndexPath indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "削除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        
        if indexPath.section == 0 {
            if editingStyle == .delete {
                dataList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }else if indexPath.section == 1 {
            if editingStyle == .delete {
                dataList2.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}



