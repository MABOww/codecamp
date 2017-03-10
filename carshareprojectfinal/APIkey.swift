//
//  APIkey.swift
//  carshareprojectfinal
//
//  Created by 井上正裕 on 2017/03/03.
//  Copyright © 2017年 井上正裕. All rights reserved.
//

import Foundation

class APIkey{
    //GoogleAPIkeyの設定
    func GoogleAPIkey() -> String {
        let googleAPIkey = "AIzaSyDY3MOM0FzHigttKJp8MDMRgUD7llOgfhQ"
        return googleAPIkey
    }
    
    //楽天APIkeyの設定
    func rakutenkey() -> String {
        let rakutenAPIkey = "1029491270326438188"
        return rakutenAPIkey
    }
    
    //docomoAPIkeyの設定
    func docomokey() -> String {
        let docomoAPIkey = "72324d627448425665756b766b454176505369436f3441352e3666325751312f534530426b68684a4a3641"
        return docomoAPIkey
    }
 
    
}
