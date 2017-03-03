//
//  SearchViewController.swift
//  FrostedSidebar
//
//  Created by 井上正裕 on 2017/02/25.
//  Copyright © 2017年 Evan Dekhayser. All rights reserved.
//

import UIKit
var StartPoint_text:String = ""

class SearchViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var StartPoint: UITextField!
    
    @IBAction func DecideSpoint(_ sender: Any) {
        StartPoint_text = (StartPoint.text!)
        StartPoint.text = ""
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        StartPoint.resignFirstResponder()
        return true
    }
    

}
