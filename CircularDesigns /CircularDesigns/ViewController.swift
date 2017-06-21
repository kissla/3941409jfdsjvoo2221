//
//  ViewController.swift
//  CircularDesigns
//
//  Created by Kiranbabu Rajanala on 10/28/16.
//  Copyright © 2016 Kiranbabu Rajanala. All rights reserved.
//

import UIKit
var SelectedColor:UIColor = UIColor.gray
class ViewController: UIViewController {

    @IBOutlet weak var DrawAnyView: drawLine!
    override func viewDidLoad() {
        super.viewDidLoad()
        DrawAnyView.layer.cornerRadius = 20
        DrawAnyView.layer.borderWidth = 2
        DrawAnyView.layer.borderColor  = UIColor.black.cgColor
        DrawAnyView.layer.masksToBounds = true
    }
    
  
    @IBAction func greencolor(_ sender: AnyObject) {
        SelectedColor = UIColor.green
    }
    @IBAction func bluecolor(_ sender: AnyObject) {
        SelectedColor = UIColor.blue
    }
    @IBAction func redcolor(_ sender: AnyObject) {
        SelectedColor = UIColor.red
    }

    @IBAction func blackcolor(_ sender: AnyObject) {
        SelectedColor = UIColor.black
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

