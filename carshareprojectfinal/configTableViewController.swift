//
//  configTableViewController.swift
//  FrostedSidebar
//
//  Created by 井上正裕 on 2017/03/01.
//  Copyright © 2017年 Evan Dekhayser. All rights reserved.
//

import UIKit

class configTableViewController: UITableViewController {
    
    @IBOutlet var test: UITableView!
    //CSVで読み出される
    var dataList:[String] = []
    var dataList2:[String] = []
    
    // Sectionで使用する配列を定義する.
    private let mySections: NSArray = ["出発地設定", "カーシェア会社"]
    let continent:[String] = ["アジア","北アメリカ","南アメリカ","ヨーロッパ","アフリカ","オセアニア"]

    override func viewDidLoad() {
        super.viewDidLoad()
test.delegate = self
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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return continent.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return continent[section]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath as IndexPath)
        return cell
    }

//    /*
//     セクションの数を返す.
//     */
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return mySections.count
//    }
//    
//    /*
//     セクションのタイトルを返す.
//     */
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return mySections[section] as? String
//    }
//    
//    /*
//     Cellが選択された際に呼び出される.
//     */
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 0 {
//            print("Value: \(dataList[indexPath.row])")
//        } else if indexPath.section == 1 {
//            print("Value: \(dataList2[indexPath.row])")
//        }
//    }
//    
//    /*
//     テーブルに表示する配列の総数を返す.
//     */
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return dataList.count
//        } else if section == 1 {
//            return dataList2.count
//        } else {
//            return 0
//        }
//    }
//    
//    /*
//     Cellに値を設定する.
//     */
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
//        //カンマでデータを分割して配列に格納する。
//        let dataDetail = dataList[indexPath.row].components(separatedBy: ",")
//        let dataDetail2 = dataList2[indexPath.row].components(separatedBy: ",")
//        print (dataDetail2)
//        if indexPath.section == 0 {
//            cell.textLabel?.text = "\(dataDetail[0])"
//        } else if indexPath.section == 1 {
//            cell.textLabel?.text = "\(dataDetail2[0])"
//        }
//        
//        return cell
//    }
    
  

    
}
