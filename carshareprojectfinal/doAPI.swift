//
//  doAPI.swift
//  carshareprojectfinal
//
//  Created by 井上正裕 on 2017/03/04.
//  Copyright © 2017年 井上正裕. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class doAPI{
    
//   func GeocodingAPI(location : String) -> (String,String){
//
//        //APIキーの取得
//        let Setkey = APIkey()
//        let appidG:String = Setkey.GoogleAPIkey()
//        //初期設定
//        var Geolat:String=""
//        var Geolng:String=""
//        
//        
//        //入力文字数が0文字より多いかどうかチェックする
////        guard  location.lengthOfBytes(using: String.Encoding.utf8) > 0 else{
////            //0文字以上
////            return
////        }
//        
//        let escapedValue = location.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
//        let geocoUrl: String = "https://maps.googleapis.com/maps/api/geocode/json?"
//        let GetgeocoUrl = geocoUrl + "&address=" + escapedValue! + "&key=" + appidG
//        
//        //ジオコーディングAPI1の実施
//        let queque = DispatchQueue.main
//        queque.async {
//            Alamofire.request(GetgeocoUrl).responseJSON{ response in
//                let json = JSON(response.result.value ?? 0)
//                let results = json["results"]
//                let json2 = results[0]
//                let geometry = json2["geometry"]
//                let location = geometry["location"]
//                Geolat = String(describing: location["lat"].double!)
//                Geolng = String(describing: location["lng"].double!)
//        }
//        }
//        queque.async{
//     return(Geolat,Geolng)
//        }
//    }
//    



}
