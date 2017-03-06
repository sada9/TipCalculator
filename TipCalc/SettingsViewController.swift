//
//  SettingsViewController.swift
//  TipCalc
//
//  Created by Pattanashetty, Sadananda on 3/5/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tipPercentageSegment: UISegmentedControl!
    
    var defTipPer: Double?
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tipPercentageSegment.addTarget(self, action: #selector(tipPercentageIndexChanged(_:)), for: UIControlEvents.valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tipPercentageIndexChanged(_ sender : UISegmentedControl){
        let percentageArray: [Double] = [15, 20, 25]
        
        let index = tipPercentageSegment.selectedSegmentIndex
        
        
        defaults.set(index, forKey: "tipcalculator_tipPerIndex")
        defaults.set(percentageArray[index], forKey: "tipcalculator_tipPer")
        defaults.synchronize()
    }
    
    
}
