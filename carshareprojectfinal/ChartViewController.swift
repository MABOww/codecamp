//
//  ChartViewController.swift
//  carshareprojectfinal
//
//  Created by 井上正裕 on 2017/03/04.
//  Copyright © 2017年 井上正裕. All rights reserved.
//

import UIKit
import PNChartSwift

class ChartViewController: UIViewController {
    var timepoints : Int = 0
    var farepoints = [Int]()
    var dataArr = [Int]()
    var count : Double = 0.0
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let item1 = PNPieChartDataItem(dateValue: 20, dateColor:  PNLightGreen, description: "Build")
        let item2 = PNPieChartDataItem(dateValue: 20, dateColor: PNFreshGreen, description: "I/O")
        let item3 = PNPieChartDataItem(dateValue: 45, dateColor: PNDeepGreen, description: "WWDC")
        
        let frame = CGRect(x: 40.0, y: 155.0, width: 260.0, height: 240.0)
        let items: [PNPieChartDataItem] = [item1, item2, item3]
        let pieChart = PNPieChart(frame: frame, items: items)
        pieChart.descriptionTextColor = UIColor.white
        pieChart.descriptionTextFont = UIFont(name: "Avenir-Medium", size: 14.0)!
        pieChart.center = self.view.center
        
        let barChart = PNBarChart(frame: CGRect(x: 0.0, y: 135.0, width: 320.0, height: 200.0))
        barChart.backgroundColor = UIColor.clear
        barChart.animationType = .Waterfall
        barChart.labelMarginTop = 5.0
        barChart.xLabels = ["Sep 1", "Sep 2", "Sep 3", "Sep 4", "Sep 5", "Sep 6", "Sep 7"]
        barChart.yValues = [1, 23, 12, 18, 30, 12, 21]
        barChart.strokeChart()
        barChart.center = self.view.center
        
        let lineChart = PNLineChart(frame: CGRect(x: 0.0, y: 135.0, width: 320.0, height: 400.0))
        lineChart.yLabelFormat = "%1f"
        lineChart.showLabel = true
        lineChart.backgroundColor = UIColor.clear
        lineChart.xLabels = ["1", "2", "3", "4", "5", "6", "7","8","9","10"]
        lineChart.showCoordinateAxis = true
        lineChart.center = self.view.center
        print ("カウント数\(farepoints.count)")
        if farepoints.count <= 12 {
            dataArr = farepoints
        }else {
            for i in farepoints{
                //1時間毎
                if count.truncatingRemainder(dividingBy: 4.0) == 0.0{
                    dataArr.append(i)
                    print ("aga")
                }
                count += 1.0
            }
        
        }
        print (dataArr)

        
        let data = PNLineChartData()
        data.color = PNGreen
        data.itemCount = dataArr.count
        data.inflexPointStyle = .None
        data.getData = ({
            (index: Int) -> PNLineChartDataItem in
            let yValue = CGFloat(self.dataArr[index])
            let item = PNLineChartDataItem(y: yValue)
            return item
        })
        
        lineChart.chartData = [data]
        lineChart.strokeChart()
        
        // Change the chart you want to present here
        self.view.addSubview(lineChart)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}
