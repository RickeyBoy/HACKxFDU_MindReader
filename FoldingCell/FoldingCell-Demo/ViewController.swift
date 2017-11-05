//
//  ViewController.swift
//  FoldingCell-Demo
//
//  Created by Ruiji Wang on 04/11/2017.
//  Copyright © 2017 Alex K. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var input: UITextField!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTableView"{
            if let nextViewController = segue.destination as? MainTableViewController {
                var id = input.text ?? "realDonaldTrump"
                if id == "" { id = "realDonaldTrump" }
                nextViewController.ID = id
            }
        }
    }

}
