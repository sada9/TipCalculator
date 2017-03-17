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

    @IBOutlet weak var themeSegment: UISegmentedControl!
    
    let defaults = UserDefaults.standard
    var defTipPerIndex: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tipPercentageSegment.selectedSegmentIndex =  defaults.integer(forKey: "tipcalculator_tipPerIndex")
        themeSegment.selectedSegmentIndex = defaults.integer(forKey: "tipcalculator_theme")
    }

    @IBAction func themeChanged(_ sender: UISegmentedControl) {
        defaults.set(themeSegment.selectedSegmentIndex, forKey: "tipcalculator_theme")
        defaults.synchronize()
    }
    @IBAction func tipPercentageChanged(_ sender: UISegmentedControl) {
        defaults.set(tipPercentageSegment.selectedSegmentIndex, forKey: "tipcalculator_tipPerIndex")
        defaults.synchronize()
    }

    
}
