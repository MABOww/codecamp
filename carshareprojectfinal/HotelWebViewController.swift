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


class HotelWebViewController: UIViewController {
    
    @IBOutlet weak var HotelWebView: UIWebView!
    //ステーション表示用のラベル
    @IBOutlet weak var carstation: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //初期か
        stationList.removeAll()
        //①登録した地点の緯度経度、宿泊先の宿の緯度経度を取得
        //APIキーの取得
        let Setkey = APIkey()
        let appidG:String = Setkey.GoogleAPIkey()
        //初期設定
        var Geolat:String=""
        var Geolng:String=""
        
        
        //入力文字数が0文字より多いかどうかチェックする
        guard  nearestStation!.lengthOfBytes(using: String.Encoding.utf8) > 0 else{
            //0文字以上
            return
        }
        
        let escapedValue = nearestStation!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let geocoUrl: String = "https://maps.googleapis.com/maps/api/geocode/json?"
        let GetgeocoUrl = geocoUrl + "&address=" + escapedValue! + "&key=" + appidG

        //placeAPIのURL生成
        let key_place = "タイムズ+ステーション+\(nearestStation!)"
        let escapedValue2 = key_place.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        let GetplaceAPIURL = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=" + escapedValue2!+"&radius=50000&key=" + appidG
        
        print (GetplaceAPIURL)
        //ジオコーディングAPIの実施
        //非同期処理がうまくできないため冗長になってます。
        //本当は関数かしたい！！
        let queque = DispatchQueue.main
        queque.async {
            Alamofire.request(GetgeocoUrl).responseJSON{ response in
                let json = JSON(response.result.value ?? 0)
                let results = json["results"]
                let json2 = results[0]
                let geometry = json2["geometry"]
                let location = geometry["location"]
                Geolat = String(describing: location["lat"].double!)
                Geolng = String(describing: location["lng"].double!)
                queque.async {
                    //この中で自宅の緯度経度を取得
                    Alamofire.request(GetplaceAPIURL).responseJSON{ response in
                        let json_place = JSON(response.result.value ?? 0)
                        let results_place = json_place["results"]
                        print ("数を数えるようー\(results_place.count)")
                        for i in 0...results_place.count{
                            let json2_place = results_place[i]
                            let station = json2_place["name"].string
                            if station != nil{
                            stationList.append(station!)
                            }
                        }
                        
                        //これは近隣カーシェアリスト
                        self.carstation.text! = "宿泊先近くには\(results_place.count)件のステーションがあります!!"
                    }
                }
            }
            
            let url = URL(string: itemUrl!)
            
            //前の画面の情報を読み込み
            let request = URLRequest(url: url!)
            self.HotelWebView.loadRequest(request)
        }
    }
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destinationViewController.
         // Pass the selected object to the new view controller.
         }
         */
        
}
