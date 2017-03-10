//
//  HotelWebViewController.swift
//  FrostedSidebar
//
//  Created by 井上正裕 on 2017/02/25.
//  Copyright © 2017年 Evan Dekhayser. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
// 商品ページのURL
var itemUrl: String?
var nearestStation: String?
var stationList = [String]()
var stationname = ""



class HotelWebViewController: UIViewController {
    
    //実験エリア
    var alert:UIAlertController!
    
    @IBAction func pushButton(_ sender: Any) {
        
        //アラートコントローラーを表示する。
        self.present(alert, animated: true, completion:{
            
            //アラートコントローラーの親ビューのユーザー操作を許可する。
            self.alert.view.superview?.isUserInteractionEnabled = true
            
            //アラートコントローラーにジェスチャーリコグナイザーを登録する。
            self.alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("tapOutside")))
        })
    }
    
    //画面タップ時の呼び出しメソッド
    func tapOutside(){
        //モーダル表示しているビューコントローラーを閉じる。
        self.dismiss(animated: true, completion: nil)
    }
    
    //実験エリア
    
    
    @IBOutlet weak var HotelWebView: UIWebView!
    //ステーション表示用のラベル
    @IBOutlet weak var carstation: UILabel!
    
 
    @IBOutlet weak var reservedurl: UILabel!
    var linkUrl = "http://www.tour.ne.jp/j_rentacar/"
    
    
    //出発地点情報読み出し用の配列
    var dataStartpoint:[String] = []
    var Startpoint:String = ""
    //表示用
    var reservedtimesURL : String = "https://api.timesclub.jp/view/pc/tpLogin.jsp?siteKbn=TP&doa=ON&redirectPath=https%3A%2F%2Fplus.timescar.jp%2Fview%2Fmember%2Fmypage.jsp"
    //ジオこURLの準備
    let geocoUrl: String = "https://maps.googleapis.com/maps/api/geocode/json?"
    //ドコモ駅たん検索APIのURl
    let routeSearchURL : String = "https://api.apigw.smt.docomo.ne.jp/ekispertCorp/v1/searchCourseExtreme?APIKEY=&searchType=departure&sort=price&viaList="
    //35.669107,139.6009514:35.4619297,139.5490379
    //出発地点の緯度経度
    var StartList = ""
    var EndList = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        //APIキーの取得
        let Setkey = APIkey()
        let appidG:String = Setkey.GoogleAPIkey()
        var Geolat:String=""
        var Geolng:String=""
        //初期化
        stationname = ""
        self.reservedurl.text! = ""
        //CSVの読み込み(自宅情報を読み込み)
        do {
            //CSVファイルのパスを取得する。
            let csvPath = Bundle.main.path(forResource: "config", ofType: "csv")
            //CSVファイルのデータを取得する。
            let csvData = try String(contentsOfFile:csvPath!, encoding:String.Encoding.utf8)
            //改行区切りでデータを分割して配列に格納する。
            dataStartpoint = csvData.components(separatedBy: "\n")
        } catch {
            print(error)
        }
        Startpoint = dataStartpoint[0]
        print (Startpoint)
        
        //入力文字数が0文字より多いかどうかチェックする
        guard  Startpoint.lengthOfBytes(using: String.Encoding.utf8) > 0 else{
            //0文字以上
            return
        }
        //出発地点をエンコーディング
        let escapedStartValue = Startpoint.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        //出発地点のgeocodingURLを生成
        let GetgeocoStartUrl = geocoUrl + "&address=" + escapedStartValue! + "&key=" + appidG
        
        
        
        stationList.removeAll()
        //①登録した地点の緯度経度、宿泊先の宿の緯度経度を取得
        
        
        
        //入力文字数が0文字より多いかどうかチェックする
        guard  nearestStation!.lengthOfBytes(using: String.Encoding.utf8) > 0 else{
            //0文字以上
            return
        }
        
        let escapedValue = (nearestStation!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        //到着地点のgeocodingURLを生成
        let GetgeocoEndUrl = geocoUrl + "&address=" + escapedValue! + "&key=" + appidG
        print ("最寄駅:\(nearestStation!)")
        
        //placeAPIのURL生成
        let key_place = "タイムズ+ステーション+\(nearestStation!)"
        let escapedValue2 = key_place.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        let GetplaceAPIURL = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=" + escapedValue2!+"&radius=50000&key=" + appidG
        
        print (GetplaceAPIURL)
        //ジオコーディングAPIの実施
        //非同期処理がうまくできないため冗長になってます。
        //本当は関数かしたい！！
        let queque = DispatchQueue.main
        //順番保証必須
        //出発地点の緯度経度を取得
        queque.async {
            Alamofire.request(GetgeocoStartUrl).responseJSON{ response in
                let json = JSON(response.result.value ?? 0)
                let results = json["results"]
                let json2 = results[0]
                let geometry = json2["geometry"]
                let location = geometry["location"]
                Geolat = String(describing: location["lat"].double!)
                Geolng = String(describing: location["lng"].double!)
                self.StartList = Geolat + "," + Geolng
                print (self.StartList)
                //念のための順番保証
                //到着地点の緯度経度を取得
                queque.async {
                    Alamofire.request(GetgeocoEndUrl).responseJSON{ response in
                        let json_end = JSON(response.result.value ?? 0)
                        let results_end = json_end["results"]
                        let json2_end = results_end[0]
                        let geometry_end = json2_end["geometry"]
                        let location_end = geometry_end["location"]
                        let Geolat_end = String(describing: location_end["lat"].double!)
                        let Geolng_end = String(describing: location_end["lng"].double!)
                        self.EndList = Geolat_end + "," + Geolng_end
                        print (self.EndList)
                        //念のための順番保証
                        //ホテル周辺のステーション数を返却
                        queque.async {
                            //この中で自宅の緯度経度を取得
                            Alamofire.request(GetplaceAPIURL).responseJSON{ response in
                                let json_place = JSON(response.result.value ?? 0)
                                let results_place = json_place["results"]
                                //debugよう
                                print ("数を数えるようー\(results_place.count)")
                                if results_place.count > 0{
                                    var url : NSString = self.reservedtimesURL as NSString
                                    let urlStr : NSString = url.addingPercentEscapes(using: String.Encoding.utf8.rawValue)! as NSString
                                    var searchURL : NSURL = NSURL(string: urlStr as String)!
                                    
                                    //self.reservedurl.text! = self.reservedtimesURL
                                    self.linkUrl = "http://plus.timescar.jp/view/sp/station/search.jsp"
                                    //ここで近隣カーシェアの数を返却
                                    self.carstation.text! = "宿泊先近くには\(results_place.count)件のカーシェアステーションがあります!!"
                                }else{
                                    self.carstation.text! = "宿泊先近くにはカーシエアはありません。"
                                    stationname = ""
                                    
                                }
                                
                                
                                //このループでステーションを取得
                                for i in 0...results_place.count{
                                    let json2_place = results_place[i]
                                    let station = json2_place["name"].string
                                    if station != nil{
                                        stationname += ("\(station!)\n")
                                        stationList.append(station!)
                                    }
                                }
                                //料金見積もりカーシェア
                                if predictfare != 0 && results_place.count != 0{
                                    stationname += ("\nカーシェア予想料金 :\(predictfare)円\n")
                                }
                                
                                
                                //料金見積もりカーシェア
                                if rentalcarfare != "" {
                                    stationname += ("レンタカー予想料金 : \(rentalcarfare)\n")
                                }
                                
                                //ここでアラートを作成
                                //アラートコントローラーを作成する。
                                self.alert = UIAlertController(title: self.carstation.text!, message: stationname, preferredStyle: .alert)
                                
                                if results_place.count != 0{
                                    //「続けるボタン」のアラートアクションを作成する。
                                    let alertAction = UIAlertAction(
                                        title: "カーシァエア予約",
                                        style: UIAlertActionStyle.default,
                                        handler: { action in
                                            
                                            let url = NSURL(string: self.linkUrl)
                                            if UIApplication.shared.canOpenURL(url! as URL){
                                                UIApplication.shared.openURL(url! as URL)
                                            }
                                    })
                                    self.alert.addAction(alertAction)

                                
                                }
                                

                                
                                let alertAction2 = UIAlertAction(
                                    title: "レンタカー予約",
                                    style: UIAlertActionStyle.default,
                                    handler: { action in
                                        
                                        let urlrenta = NSURL(string: "http://travel.rakuten.co.jp/cars/")
                                        if UIApplication.shared.canOpenURL(urlrenta! as URL){
                                            UIApplication.shared.openURL(urlrenta! as URL)
                                        }
                                })
                                
                                
                                //「キャンセルボタン」のアラートアクションを作成する。
                                let alertAction3 = UIAlertAction(
                                    title: "キャンセル",
                                    style: UIAlertActionStyle.cancel,
                                    handler: nil
                                )
                                
                                //アラートアクションを追加する。
     
                                self.alert.addAction(alertAction2)
                                self.alert.addAction(alertAction3)

                                
                                
                                
                                
                                let GetrouteSearchURL = self.routeSearchURL + self.StartList + ":" + self.EndList
                                
                                //ここでルート検索
                                queque.async {
                                    Alamofire.request(GetrouteSearchURL).responseJSON{ response in
                                        let json_route = JSON(response.result.value ?? 0)
                                        let results_route = json_route["ResultSet"]
                                        let results_course = results_route["Course"]
                                        let json_route2 = results_course[0]
                                        let pricelist = json_route2["Price"]
                                        print (pricelist)
                                        //このループでステーションを取得
                                        for j in 0...pricelist.count{
                                            
                                            let json2_fare = pricelist[j]
                                            //print (json2_fare)
                                            if  json2_fare["Round"] != nil{
                                                //                                                if json2_fare["Round"].string! != nil{
                                                //                                                    let fare = json2_fare["Round"].string!
                                                //                                                    print (fare)
                                                //                                                }
                                                print (json2_fare["Round"])
                                            }
                                            
                                            
                                        }
                                    }
                                    
                                    
                                }
                            }
                        }
                    }
                }
            }
            
            let url = URL(string: itemUrl!)
            
            //前の画面の情報を読み込み
            let request = URLRequest(url: url!)
            self.HotelWebView.loadRequest(request)
        }
    }
    
    
    @IBAction func carsharesafari(_ sender: Any) {
        let url = NSURL(string: linkUrl)
        if UIApplication.shared.canOpenURL(url! as URL){
            UIApplication.shared.openURL(url! as URL)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
