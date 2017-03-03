//
//  GraphicViewController.swift
//  FrostedSidebar
//
//  Created by 井上正裕 on 2017/03/02.
//  Copyright © 2017年 Evan Dekhayser. All rights reserved.
//

import UIKit

class GraphicViewController: UIViewController {
    var timepoints : Int = 0
    var farepoints = [Int]()

    @IBOutlet weak var graphView: GraphView!
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        graphView.setupPoints(points: farepoints)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
