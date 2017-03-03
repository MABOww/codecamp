//
//  WebViewController.swift
//  FrostedSidebar
//
//  Created by 井上正裕 on 2017/02/24.
//  Copyright © 2017年 Evan Dekhayser. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    
 
    @IBOutlet weak var webView: UIWebView!
    var urlcar:String = "https://carsharemap.jp"
    override func viewDidLoad() {
        super.viewDidLoad()
        //web画面を表示
        loadURL()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func loadURL() {
        let requestURL = NSURL(string: urlcar)
        let request = NSURLRequest(url: requestURL! as URL)
        webView.loadRequest(request as URLRequest)
    }

}
