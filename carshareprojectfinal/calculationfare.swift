//
//  calculationfare.swift
//  FrostedSidebar
//
//  Created by 井上正裕 on 2017/02/25.
//  Copyright © 2017年 Evan Dekhayser. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class calculationfare{
    
    //ここはタイムズカーシェア用の料金計算の変数
    var distanceval : String = ""
    var Fare_short = 0.0
    var Fare_Pack6 = 0.0
    var Fare_Pack12 = 0.0
    var Fare_Pack24 = 0.0
    let short = 206.0
    let Pack6 = 4020.0
    let Pack12 = 6690.0
    let Pack24 = 8230.0
    var fares = [Int]()

    
    //ここは利用時間算出のための変数
    var utiltime : Int = 0

    
    func timecalc (componentday : Int, dayrrow : Int, componenthour : Int, hourrow : Int, componenttime : Int,timerow : Int) -> Int{
        utiltime = 0
        //利用日数から時間を算出
        if componentday == 0{
            utiltime += (dayrrow * 24 * 60)/15
        }
        //利用時間から時間を算出
        if componenthour == 1{
            utiltime += hourrow * 4
        }
        if componenttime == 2{
            utiltime += timerow
        }
        print (utiltime)

        //合計利用時間
        return utiltime
    }
    
    //時間に対する料金変動
    func faresimulation (datapoint : Int, distance : Double) -> Array<Int>{
        let distance = ceil(distance*2.0)
        var fareslist = [Int]()
        //ここで計算
        for time in 0 ... datapoint {
            //最安値料金を算出
            var time = Double(time)
            if  time <= 24.0 {
                Fare_short = 206 * time
                Fare_Pack6 = Pack6
                Fare_Pack12 = Pack12 + 16.0 * distance
                Fare_Pack24 = Pack24 + 16.0 * distance
            }else if time > 24.0 && time <= 48.0{
                Fare_short = 206 * time
                Fare_Pack6 = Pack6 + 206 * (time - 24.0)
                Fare_Pack12 = Pack12 + 16.0 * distance
                Fare_Pack24 = Pack24 + 16.0 * distance
            }else if time > 48.0 && time <= 72.0{
                Fare_short = 206 * time
                Fare_Pack6 = 0.0
                Fare_Pack12 = Pack12 + 16.0 * distance + 206 * (time - 48.0)
                Fare_Pack24 = Pack24 + 16.0 * distance
            }else if time > 72.0 && time <= 120.0{
                Fare_short = 206 * time
                Fare_Pack6 = 0.0
                Fare_Pack12 = 0.0
                Fare_Pack24 = Pack24 + 16.0 * distance + 206 * (time - 72.0)
            }else if time > 120.0{
                Fare_Pack6 = 0.0
                Fare_Pack12 = 0.0
                Fare_Pack24 = 0.0
                Fare_short = 206 * time
            }
            //配列に料金をセット
            var fares = [Int(Fare_short), Int(Fare_Pack6),Int(Fare_Pack12),Int(Fare_Pack24)]
            print (fares)
            var Fare = fares[0]
            //print (fares)
            //料金計算
            for i in fares{
                if i != 0{
                    if i <= Fare{
                        Fare = i
                    }
                }
            }
            //ここで料金計算
            fareslist.append(Fare)
        }
   
        return fareslist
    }

    
    
    
    func DirectionsAPI(URL:String) -> JSON{
        var json: JSON!
        Alamofire.request(URL).responseJSON{response in
            let json = JSON(response.result.value ?? 0)
            //print (response)
            let routes = json["routes"]
            let json2 = routes[0]
            let legs = json2["legs"]
            let json3 = legs[0]
            let distance = json3["distance"]
            self.distanceval = String(describing: distance["text"].string!)
        }
        return json
    }
    
    //カーシェア料金算出
    func TimesSharingFare(time:Double , distance : Double ) -> Int{
        let distance = ceil(distance*2.0)
        //print (distance)
        if  time <= 24.0 {
            Fare_short = 206 * time
            Fare_Pack6 = Pack6
            Fare_Pack12 = Pack12 + 16.0 * distance
            Fare_Pack24 = Pack24 + 16.0 * distance
        }else if time > 24.0 && time <= 48.0{
            Fare_short = 206 * time
            Fare_Pack6 = Pack6 + 206 * (time - 24.0)
            Fare_Pack12 = Pack12 + 16.0 * distance
            Fare_Pack24 = Pack24 + 16.0 * distance
        }else if time > 48.0 && time <= 72.0{
            Fare_short = 206 * time
            Fare_Pack6 = 0.0
            Fare_Pack12 = Pack12 + 16.0 * distance + 206 * (time - 48.0)
            Fare_Pack24 = Pack24 + 16.0 * distance
        }else if time > 72.0 && time <= 120.0{
            Fare_short = 206 * time
            Fare_Pack6 = 0.0
            Fare_Pack12 = 0.0
            Fare_Pack24 = Pack24 + 16.0 * distance + 206 * (time - 72.0)
        }else if time > 120.0{
            Fare_Pack6 = 0.0
            Fare_Pack12 = 0.0
            Fare_Pack24 = 0.0
            Fare_short = 206 * time
        }
        //配列に料金をセット
        var fares = [Int(Fare_short), Int(Fare_Pack6),Int(Fare_Pack12),Int(Fare_Pack24)]
        var Fare = fares[0]
        //料金計算
        for i in fares{
            if i != 0{
                if i <= Fare{
                    Fare = i
                }
            }
        }
        return Fare
    }
    
    
}
