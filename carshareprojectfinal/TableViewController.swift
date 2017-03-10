//
//  TableViewController.swift
//  CustomcellAPI
//
//  Created by 井上正裕 on 2017/02/13.
//  Copyright © 2017年 井上正裕. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


//グローバル変数として定義
// 商品情報を格納する配列
var items: [JSON] = []
var connum:Int = 0
var lat : String?
var lng : String?
var cnt:Int = 0




class TableViewController: UITableViewController,UISearchBarDelegate {
    
    //実験エリア
    var alert2:UIAlertController!
    
    var Setkey = APIkey()
    //初期設定
    var itemDataArray = [ItemData]()
    var selectedInfo : String?
    var selectednearestStation : String?
    var input = ""
    var checkindate = ""
    var checkoutdate = ""
    var error : String?
    //    var lat : String?
    //    var lng : String?
    
    //APIキーの設定(URL埋め込まない)
    
    
    //リクエストURL
    let urlString = "https://app.rakuten.co.jp/services/api/Travel/VacantHotelSearch/20131024"
    let geocoUrl: String = "https://maps.googleapis.com/maps/api/geocode/json?"
    let rakutenUrl : String = "https://app.rakuten.co.jp/services/api/Travel/VacantHotelSearch/20131024?"
    var inputText = ""
    
    
    
    
    @IBOutlet var TableView2: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let appidG:String = Setkey.GoogleAPIkey()
        let applicationId = Setkey.rakutenkey()
        items.removeAll()
        print (input)
        connum = 0
        //ここは画面受け渡し
        inputText = ""
        inputText = input
        
        
        
        //入力文字数が0文字より多いかどうかチェックする
        guard  inputText.lengthOfBytes(using: String.Encoding.utf8) > 0 else{
            //0文字以上
            return
        }
        
        let escapedValue = inputText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let GetgeocoUrl = self.geocoUrl + "&address=" + escapedValue! + "&key=" + appidG
        
        
        //じおコーディングAPI1の実施
        let queque = DispatchQueue.main
        
        queque.async {
            Alamofire.request(GetgeocoUrl).responseJSON{ response in
                let json = JSON(response.result.value ?? 0)
                if json["status"] == "OK"{
                let results = json["results"]
                let json2 = results[0]
                let geometry = json2["geometry"]
                let location = geometry["location"]
                lat = String(describing: location["lat"].double!)
                lng = String(describing: location["lng"].double!)
                }
                //この中でホテル検索
                queque.async {
                    
                    
                    //緯度経度取得
                    
                    //パラメータを指定する
                    let parameter = ["applicationId": applicationId,"format":"json","checkinDate": self.checkindate,"checkoutDate":self.checkoutdate,"latitude":lat,"longitude":lng,"searchRadius":"1","datumType":"1"]
                    
                    //ここでurlを作成
                    let url = self.Encodeinput(parameter: parameter as! [String : String])
                    //print(url)
                    
                    
                    
                    // APIでデータ取得
                    Alamofire.request(url).responseJSON{ response in
                        //print(response.result.value)
                    let json = JSON(response.result.value ?? 0)
                        self.error = "wrong_parameter"
                        if json["error"].string != self.error || json["error"].string != "not_found" {
                            print(json["error"])
                            json["hotels"].forEach{(_, data) in
                                let type = data["hotel"]
                                let hotel = type[0]
                                items.append(hotel["hotelBasicInfo"])
                                //print (items)
                                connum = items.count
                                self.tableView.reloadData()
                                print("b")
                            }}else{
                            //アラートコントローラーを表示する。
                            self.present(self.alert2, animated: true, completion:{
                                
                                //アラートコントローラーの親ビューのユーザー操作を許可する。
                                self.alert2.view.superview?.isUserInteractionEnabled = true
                                
                                //アラートコントローラーにジェスチャーリコグナイザーを登録する。
                                self.alert2.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("tapOutside")))
                            })
                            
                            //「キャンセルボタン」のアラートアクションを作成する。
                            let alertAction3 = UIAlertAction(
                                title: "キャンセル",
                                style: UIAlertActionStyle.cancel,
                                handler: nil
                            )
                            
                            self.alert2.addAction(alertAction3)
                            print ("1")
                        }
                    }
                }
            }
            
            
        }
        
        
        //        // キーボードのsearchボタンがタップされたときに呼び出される
        //        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //
        //
        //            //検索のたびに前の検索を削除
        //            items.removeAll()
        //            // 入力された文字の取り出しここはsearchbarを用いる時
        //            //        guard let inputText = searchBar.text else {
        //            //            // 入力文字なし
        //            //            return
        //            //        }
        //            //
        //            //ここは画面受け渡し
        //            guard let inputText = input else {
        //                return
        //            }
        //
        //            //入力文字数が0文字より多いかどうかチェックする
        //            guard  inputText.lengthOfBytes(using: String.Encoding.utf8) > 0 else{
        //                //0文字以上
        //                return
        //            }
        //
        //
        //
        //
        //            let escapedValue = inputText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        //
        //            let GetgeocoUrl = self.geocoUrl + "&address=" + escapedValue! + "&key=" + self.appidG
        //
        //
        //
        //            //じおコーディングAPI1の実施
        //            let queque = DispatchQueue.main
        //            queque.async {
        //                Alamofire.request(GetgeocoUrl).responseJSON{ response in
        //                    let json = JSON(response.result.value ?? 0)
        //                    let results = json["results"]
        //                    let json2 = results[0]
        //                    let geometry = json2["geometry"]
        //                    let location = geometry["location"]
        //                    lat = String(describing: location["lat"].double!)
        //                    lng = String(describing: location["lng"].double!)
        //                    //print (lat)
        //                    //この中でホテル検索
        //                    queque.async {
        //
        //                        //緯度経度取得
        //
        //                        //パラメータを指定する
        //                        let parameter = ["applicationId": self.applicationId,"format":"json","checkinDate": "2017-03-02","checkoutDate":"2017-03-03","latitude":lat,"longitude":lng,"searchRadius":"1","datumType":"1"]
        //
        //                        //ここでurlを作成
        //                        let url = self.Encodeinput(parameter: parameter as! [String : String])
        //                        print(url)
        //
        //
        //
        //                        // APIでデータ取得
        //                        Alamofire.request(url).responseJSON{ response in
        //                            //print(response.result.value)
        //                            let json = JSON(response.result.value ?? 0)
        //                            json["hotels"].forEach{(_, data) in
        //                                let type = data["hotel"]
        //                                let hotel = type[0]
        //                                items.append(hotel["hotelBasicInfo"])
        //                                print (items)
        //                                connum = items.count
        //                                self.tableView.reloadData()
        //                            }
        //                        }
        //
        //                    }
        //
        //                }
        //
        //            }
        //        }
        //
        //
        //
        //
        //
        //        //
        //        //
        //        //        // パラメータをエンコードしたURLを作成する
        //        //        let requestUrl = createRequestUrl(parameter: parameter as! [String : String])
        //
        //        // キーボードを閉じる
        //        //searchBar.resignFirstResponder()
    }
    
    //##
    // URL作成処理
    func Encodeinput(parameter: [String: String]) -> String {
        var parameterString = ""
        for key in parameter.keys {
            // 値の取り出し
            guard let value = parameter[key] else {
                // 値なし。次のfor文の処理を行なう
                continue
            }
            
            // 既にパラメータが設定されていた場合
            if parameterString.lengthOfBytes(using: String.Encoding.utf8) > 0 {
                // パラメータ同士のセパレータである&を追加する
                parameterString += "&"
            }
            
            // 値をエンコードする
            guard let encodeValue = encodeParameter(key: key, value: value) else {
                // エンコード失敗。次のfor文の処理を行なう
                continue
            }
            // エンコードした値をパラメータとして追加する
            parameterString += encodeValue
            
        }
        let requestUrl = urlString + "?" + parameterString
        return requestUrl
    }
    //##
    
    //パラメータのURLエンコード処理
    func encodeParameter(key: String, value: String) -> String?{
        //値をエンコードする
        guard let escapedValue = value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else{
            //エンコード失敗
            return nil
        }
        // エンコードした値をkey = vaueの形式で返却する
        return "\(key)=\(escapedValue)"
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    //テーブル数を返却
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connum
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        var item = items[indexPath.row]
        //print (item)
        cell.itemTitleLabel?.text = items[indexPath.row]["hotelName"].string
        let number: Int = items[indexPath.row]["hotelMinCharge"].int!
        cell.itemPriceLabel?.text = "宿泊最安値 : \(String(number))"
        
        let url = NSURL(string: items[indexPath.row]["hotelImageUrl"].string!);
        //print (url!)
        let imageData = NSData(contentsOf: url! as URL)
        //(imageData)
        let data = NSData(contentsOf: url! as URL)
        var img = UIImage(data:imageData as! Data);
        cell.imageView?.image = img?.resize(size: CGSize(width: 100, height: 100))
        
        return cell
    }
    
    //ここでデータの受け渡し
    override func tableView(_ table: UITableView,didSelectRowAt indexPath: IndexPath) {
        self.selectedInfo = items[indexPath.row]["hotelInformationUrl"].string
        self.selectednearestStation  = items[indexPath.row]["nearestStation"].string
        itemUrl = self.selectedInfo!
        nearestStation = self.selectednearestStation!
        print(itemUrl!)
        cnt+=1
        if cnt == 0{
            performSegue(withIdentifier: "toDetail", sender: nil)
        }
        
    }
    
}





//画像サイズを固定するためにUIImageを拡張
extension UIImage {
    
    func resize(size: CGSize) -> UIImage {
        let widthRatio = size.width / self.size.width
        let heightRatio = size.height / self.size.height
        let ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio
        let resizedSize = CGSize(width: (self.size.width * ratio), height: (self.size.height * ratio))
        // 画質を落とさないように以下を修正
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0)
        draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    
}

