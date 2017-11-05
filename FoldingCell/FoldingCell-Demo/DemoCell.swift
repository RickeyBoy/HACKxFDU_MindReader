//
//  DemoCell.swift
//  FoldingCell
//
//  Created by Alex K. on 25/12/15.
//  Copyright © 2015 Alex K. All rights reserved.
//

import UIKit
import FoldingCell
import Charts
import SnapKit

class DemoCell: FoldingCell, ChartViewDelegate {
    
    let functionName = ["Personality","Books","Movies","Musics","Value","Guess You Like","Todo","Todo","Todo","Todo"]
    
    @IBOutlet weak var closeNumberLabel: UILabel!
    @IBOutlet weak var closeUserName: UILabel!
    @IBOutlet weak var closeDescription: RotatedView!
    @IBOutlet weak var closedDescriptionLabel: UILabel!
    @IBOutlet weak var closedDate: UILabel!
    
    @IBOutlet weak var openContainerName: UILabel!
    @IBOutlet weak var openChartView: UIView!
    @IBOutlet weak var openBackgroundImage: UIImageView!
    
    @IBOutlet weak var openeLeftView: UIView!
    @IBOutlet weak var closedTopView: UIView!
    
    let radarChart = RadarChartView()
    var doubleLabels: [Double] = []
    var stringLabels: [String] = []
    var shoppingItems: [ShoppingItem] = []
    
    var shoppingListName = ""
    var UserName = ""
    
    var number: Int = 0 {
        didSet {
            openeLeftView.backgroundColor = getColor(num: number)
            var name = functionName[number]
            closedDescriptionLabel.text = "\(UserName)'s \(functionName[number])?\nClick Here! \nMind Reader can help you"
            if number == 5 {
                name = shoppingListName
                closedDescriptionLabel.text = "\(UserName)'s Concerns?\nClick Here! \nMind Reader can help you"
            }
            closeNumberLabel.text = String(number)
            closeUserName.text = functionName[number]
            closedDate.text = getTime()
            openContainerName.text = name
            openBackgroundImage.image = UIImage(named: functionName[number])
        }
    }
    fileprivate func getColor(num: Int) -> UIColor {
        switch num {
        case 0:
            return UIColor.init(red: 148/255, green: 0, blue: 211/255, alpha: 1)
        case 1:
            return UIColor.init(red: 153/255, green: 50/255, blue: 204/255, alpha: 1)
        case 2:
            return UIColor.init(red: 186/255, green: 85/255, blue: 211/255, alpha: 1)
        case 3:
            return UIColor.init(red: 147/255, green: 112/255, blue: 219/255, alpha: 1)
        case 4:
            return UIColor.init(red: 128/255, green: 0, blue: 128/255, alpha: 1)
        case 5:
            return UIColor.init(red: 216/255, green: 191/255, blue: 216/255, alpha: 1)
        case 6:
            return UIColor.init(red: 221/255, green: 160/255, blue: 221/255, alpha: 1)
        case 7:
            return UIColor.init(red: 238/255, green: 130/255, blue: 238/255, alpha: 1)
        case 8:
            return UIColor.init(red: 218/255, green: 112/255, blue: 214/255, alpha: 1)
        case 9:
            return UIColor.init(red: 199/255, green: 21/133, blue: 133/255, alpha: 1)
        default:
            return UIColor.purple
        }
    }
    fileprivate func getTime() -> String {
        let now = Date()
        let dformatter = DateFormatter()
        dformatter.dateFormat = "HH:mm"
        return dformatter.string(from: now)
    }
    func setupAll(styleNum: Int) {
        switch styleNum {
        case 0,4:
            setupChart(styleNum: styleNum)
        case 1,2,3:
            setupStringLabels(Labels: stringLabels)
        case 5:
            setupShoppingList(shoppingItems: shoppingItems)
        default:
            break
        }
    }
    fileprivate func setupShoppingList(shoppingItems: [ShoppingItem]) {
        for (index,item) in shoppingItems.enumerated() {
            let imageView = UIImageView(image: downloadURL(urlString: item.imageURL))
            let label = UILabel()
            label.text = item.description ?? "A Gift"
            openChartView.addSubview(imageView)
            openChartView.addSubview(label)
            imageView.snp.remakeConstraints({ (make) in
                make.left.equalTo(16)
                make.top.equalTo(56*index+16)
                make.height.width.equalTo(40)
            })
            label.snp.remakeConstraints({ (make) in
                make.left.equalTo(16+40+16)
                make.right.equalTo(-16)
                make.top.equalTo(56*index+16)
                make.height.equalTo(40)
            })
        }
    }
    fileprivate func downloadURL(urlString: String?) -> UIImage {
        guard let urlString = urlString else { return #imageLiteral(resourceName: "non-fiction") }
        let url = URL.init(string: urlString)
        // 从url上获取内容
        // 获取内容结束才进行下一步
        let data = try? Data(contentsOf: url!)
        
        if data != nil {
            let image = UIImage(data: data!)
            return image ?? #imageLiteral(resourceName: "non-fiction")
        }
        return #imageLiteral(resourceName: "non-fiction")
    }
    fileprivate func setupChart(styleNum: Int) {
        guard [0,4].contains(styleNum) else { return }
        
        radarChart.delegate = self
        radarChart.chartDescription?.text = functionName[number]
        radarChart.rotationEnabled = true
        radarChart.highlightPerTapEnabled = true

        //雷达图线条样式
        radarChart.webLineWidth = 2 //主干线线宽
        radarChart.webColor = .lightGray
        radarChart.innerWebLineWidth = 1 //边线宽度
        radarChart.innerWebColor = .lightGray //边线颜色
        radarChart.webAlpha = 1 //透明度

        //设置 xAxi
        var xVals:[String] = []
        let xAxis = radarChart.xAxis
        switch styleNum {
        case 0:
            xVals = ["Em.","Op.","Ex.","Ag.","Co."]
        default:
            xVals = ["Se.","Oc.","St.","He.","Co."]
        }
        xAxis.labelFont = UIFont.systemFont(ofSize: 15.0)
//        xAxis.labelTextColor = .gray
//        let xVals = ["EmotionalRange","Openness","Extraversion","Agreeableness","Conscientiousness"]
        xAxis.valueFormatter = IndexAxisValueFormatter(values:xVals)
//        barChartView.xAxis.granularity = 1

        //设置 yAxis
        let yAxis = radarChart.yAxis
        yAxis.axisMinimum = 0.0 //最小值
        yAxis.axisMaximum = 1.0 //最大值
        yAxis.drawLabelsEnabled = false //是否显示 label
        yAxis.labelCount = 5 // label 个数
        yAxis.labelFont = UIFont.systemFont(ofSize: 6.0)
        yAxis.labelTextColor = .black // label 颜色

        //为雷达图提供数据
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<doubleLabels.count {
            let dataEntry = ChartDataEntry(x: doubleLabels[i], y: doubleLabels[i] )
            dataEntries.append(dataEntry)
        }
        let dataSet = RadarChartDataSet.init(values: dataEntries, label: UserName)
        dataSet.drawValuesEnabled = false
//        dataSet.colors = ChartColorTemplates.joyful()
        radarChart.rotationEnabled = false
        dataSet.drawFilledEnabled = true
        switch styleNum {
        case 0:
            dataSet.fillColor = .blue
        default:
            dataSet.fillColor = .purple
        }
        radarChart.data = RadarChartData.init(dataSets: [dataSet])

        //设置动画
        radarChart.animate(yAxisDuration: 0.5, easingOption: .easeOutBounce)
        
        self.openChartView.addSubview(radarChart)
        radarChart.snp.remakeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(300)
            make.top.equalTo(openChartView.snp.top).offset(16)
//            make.bottom.equalTo(openChartView.snp.bottom).offset(-16)
        }
        
    }
    fileprivate func setupStringLabels(Labels: [String]) {
        for (index,str) in Labels.enumerated() {
            let imageView = UIImageView(image: UIImage.init(named: str))
            let label = UILabel()
            label.text = str
            openChartView.addSubview(imageView)
            openChartView.addSubview(label)
            imageView.snp.remakeConstraints({ (make) in
                make.left.equalTo(16)
                make.top.equalTo(56*index+16)
                make.height.width.equalTo(40)
            })
            label.snp.remakeConstraints({ (make) in
                make.left.equalTo(16+40+16)
                make.right.equalTo(-16)
                make.top.equalTo(56*index+16)
                make.height.equalTo(40)
            })
        }
    }
    
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
    
    override func unfold(_ value: Bool, animated: Bool, completion: (() -> Void)?) {
        if value == false {
            super.unfold(value, animated: animated, completion: { self.removeAllSubviews(view: self.openChartView) })
        } else {
            super.unfold(value, animated: animated, completion: { self.setupAll(styleNum: self.number) })
        }
    }
    fileprivate func removeAllSubviews(view: UIView) {
        for sub in view.subviews {
            sub.removeFromSuperview()
        }
    }
}

// MARK: - Actions ⚡️
extension DemoCell {
    
    @IBAction func buttonHandler(_ sender: AnyObject) {
        print("tap")
        
    }
    
}

