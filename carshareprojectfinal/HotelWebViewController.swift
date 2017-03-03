//
//  HotelWebViewController.swift
//  FrostedSidebar
//
//  Created by 井上正裕 on 2017/02/25.
//  Copyright © 2017年 Evan Dekhayser. All rights reserved.
//

import UIKit
// 商品ページのURL
var itemUrl: String?


class HotelWebViewController: UIViewController {

    @IBOutlet weak var HotelWebView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        print(itemUrl!)
        
        let url = URL(string: itemUrl!)
        
        let request = URLRequest(url: url!)
        HotelWebView.loadRequest(request)
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
