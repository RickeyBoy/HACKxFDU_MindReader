//
//  MainTableViewController.swift
//
// Copyright (c) 21/12/15. Ramotion Inc. (http://ramotion.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import FoldingCell
import FillableLoaders
//import SnapKit

class MainTableViewController: UITableViewController {
  
    let kCloseCellHeight: CGFloat = 179
    let kOpenCellHeight: CGFloat = 488
    let kRowsCount = 10
    var cellHeights: [CGFloat] = []
    
    var personalityLabels: [Double] = []
    var musics: [String] = []
    var books: [String] = []
    var movies: [String] = []
    var valueLabels: [Double] = []
    
    var shoppingItems: [ShoppingItem] = []
    var shoppingListName = ""
    
    var loadingView = LoadingView.init(frame: CGRect(x: 0, y: -25.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+25.0))

    var ID = "" {
        didSet {
            tableView.isScrollEnabled = false
            tableView.addSubview(loadingView)
            loadingView.startLoading()
            DemoAPI.getAllResponse(ID: ID) { [weak self] (response) in
                self?.loadingView.stopLoading()
                self?.tableView.isScrollEnabled = true
                self?.loadingView.removeFromSuperview()
                self?.personalityLabels.removeAll()
//                let xVals = ["EmotionalRange","Openness","Extraversion","Agreeableness","Conscientiousness"]
                guard let response = response else { return }
                self?.personalityLabels.append(response.EmotionalRange ?? 0.0)
                self?.personalityLabels.append(response.Openness ?? 0.0)
                self?.personalityLabels.append(response.Extraversion ?? 0.0)
                self?.personalityLabels.append(response.Agreeableness ?? 0.0)
                self?.personalityLabels.append(response.Conscientiousness ?? 0.0)
                self?.musics = response.Musics ?? []
                self?.books = response.Books ?? []
                self?.movies = response.Movies ?? []
                self?.valueLabels.removeAll()
                self?.valueLabels.append(response.SelfEnhancement ?? 0.0)
                self?.valueLabels.append(response.OpennessToChange ?? 0.0)
                self?.valueLabels.append(response.SelfTranscendence ?? 0.0)
                self?.valueLabels.append(response.Hedonism ?? 0.0)
                self?.valueLabels.append(response.Conservation ?? 0.0)
                self?.shoppingItems = response.Items ?? []
                if let count = self?.shoppingItems.count, count > 4 { self?.shoppingItems.removeLast() }
                self?.shoppingListName = response.shoppingListName ?? "Guess You Like"
                self?.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    @objc fileprivate func pop() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setup() {
        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
//        loadingView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        loadingView.backgroundColor = .white
    }
}

// MARK: - TableView
extension MainTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        view.backgroundColor = .clear
        view.addSubview(button)
        button.addTarget(self, action: #selector(pop), for: .touchUpInside)
        button.snp.remakeConstraints { (make) in
            make.left.equalTo(16)
            make.centerY.equalTo(view.snp.centerY)
        }
        return view
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as DemoCell = cell else {
            return
        }
        cell.UserName = ID
        switch indexPath.row {
        case 0:
            cell.doubleLabels = personalityLabels
        case 1:
            cell.stringLabels = books
        case 2:
            cell.stringLabels = movies
        case 3:
            cell.stringLabels = musics
        case 4:
            cell.doubleLabels = valueLabels
        case 5:
            cell.shoppingItems = shoppingItems
            cell.shoppingListName = shoppingListName
        default:
            break
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.selectedAnimation(false, animated: false, completion:nil)
        } else {
            cell.selectedAnimation(true, animated: false, completion: nil)
        }
        
        cell.number = indexPath.row
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FoldingCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == kCloseCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
        
    }
  
}
