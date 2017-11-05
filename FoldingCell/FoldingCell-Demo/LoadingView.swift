//
//  LoadingView.swift
//  FoldingCell-Demo
//
//  Created by Ruiji Wang on 05/11/2017.
//  Copyright © 2017 Alex K. All rights reserved.
//

import UIKit
//import SnapKit

class LoadingView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.addSubview(loader)
        for _ in 0..<3 {
            let temp = UILabel()
            self.addSubview(temp)
            temp.textAlignment = .center
            temp.font = UIFont.systemFont(ofSize: 14.0)
            temp.textColor = .gray
            temp.alpha = 0
            temp.numberOfLines = 0
            temp.snp.remakeConstraints({ (make) in
                make.center.equalTo(self.snp.center)
                make.width.equalTo(300)
                make.height.equalTo(100)
            })
            Labels.append(temp)
        }
        Labels[0].text = "A light heart lives long.\n - William Shakespeare \n 1563 --- 1616, English dramatist"
        Labels[1].text = "A person is literally what they think, \n their character being the complete sum of all their thoughts.\n – James Allen, Author"
        Labels[2].text = "Parents can only give good advice, \n but the final forming of a person’s character lies in their own hands.\n — Anne Frank, Writer"
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
//    private var loader = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    private var Labels: [UILabel] = []
    
    var timer:Timer!
    var helpIndex = 0
    open func startLoading() {
//        loader.startAnimating()
        timer = Timer.scheduledTimer(timeInterval: 6.0, target:self, selector:#selector(LoadingView.tickDown), userInfo:nil, repeats:true)
    }
    @objc fileprivate func tickDown() {
        helpIndex = (helpIndex+1)%3
        let index = helpIndex
        UIView.animate(withDuration: 1.0, animations: { [weak self] ()->Void in
            self?.Labels[index].alpha = 1.0
        }) { (finished:Bool)->Void in
            UIView.animate(withDuration: 1.0, delay: 4.0, options: UIViewAnimationOptions.curveLinear, animations: { [weak self] ()->Void in
                self?.Labels[index].alpha = 0.0
            }, completion: nil)
        }
    }
    open func stopLoading() {
//        loader.stopAnimating()
        timer.invalidate()
        for l in Labels {
            l.alpha = 0.0
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
