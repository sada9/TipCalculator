//
//  ViewController.swift
//  TipCalc
//
//  Created by Pattanashetty, Sadananda on 3/5/17.
//  Copyright © 2017 Pattanashetty, Sadananda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var billAmount: UITextField!
    @IBOutlet weak var tipAmount: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var calcView: UIView!
    var tipPer: Double?
    @IBOutlet weak var tipPercentageSegment: UISegmentedControl!
    
    let defaults = UserDefaults.standard
    var defaultTipPer: Double?
    var defaultTipPerIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepateForAnimation()
        self.billAmount.delegate = self
        
        billAmount.addTarget(self, action: #selector(billAmountDidChange(_:)), for: .editingChanged)
        tipPercentageSegment.addTarget(self, action: #selector(tipPercentageIndexChanged(_:)), for: UIControlEvents.valueChanged)
    }
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func showUIControls() {
        
        UIView.animate(withDuration: 0.30, delay: 0, options: .transitionCrossDissolve, animations: {
            self.billAmount.frame.origin.y = 100
        }, completion: { (success:Bool) in
        })
        
        UIView.animate(withDuration: 0.30, delay: 0, options: .transitionCrossDissolve, animations: {
            self.tipPercentageSegment.frame.origin.y = 230
        }, completion: { (success:Bool) in
            
            
            UIView.animate(withDuration: 0.30, delay: 0, options: .transitionCrossDissolve, animations: {
                self.calcView.frame.origin.y = 310
            }, completion: { (success:Bool) in
                
            })
            
        })
        
    }
    
    func hideUIControls() {
        
        UIView.animate(withDuration: 0.30, delay: 0, options: .transitionCrossDissolve, animations: {
            self.calcView.frame.origin.y = 750
        }, completion: { (success:Bool) in
            
            UIView.animate(withDuration: 0.30, delay: 0, options: .transitionCrossDissolve, animations: {
                self.tipPercentageSegment.frame.origin.y = 750
            }, completion: { (success:Bool) in
                
                UIView.animate(withDuration: 0.30, delay: 0, options: .transitionCrossDissolve, animations: {
                    self.billAmount.frame.origin.y = 279
                }, completion: { (success:Bool) in
                })
                
            })
            
        })
        
        
        
        
        
        
    }
    
    func billAmountDidChange(_ textField: UITextField) {
    
        guard let billAmtString = textField.text else {
            return
        }
        
        guard let billAmtDouble = Double(billAmtString) else {
            return
        }
        print(billAmtString)
        guard let tipPer = tipPer else {
            return
        }
        
        calculateTip(billAmtDouble,tipPercentage: tipPer)
        
    }
    
    
    func calculateTip(_ billAmtDouble: Double, tipPercentage: Double) {
        let tipAmount = billAmtDouble * (tipPercentage/100)
        let totalAmt = billAmtDouble + tipAmount
        
        updateAmounts(tipAmount, totalAmt: totalAmt)
    }
    
    func updateAmounts(_ tipAmt: Double, totalAmt: Double) {
        self.tipAmount.text = "$" + String(tipAmt)
        self.totalAmount.text = "$" + String(totalAmt)
    }
    
   func tipPercentageIndexChanged(_ sender : UISegmentedControl){
        let percentageArray: [Double] = [15, 20, 25]
        let index = tipPercentageSegment.selectedSegmentIndex
        
        guard let billAmtString = self.billAmount.text else {
            return
        }
        
        guard let billAmtDouble = Double(billAmtString) else {
            return
        }
        
        self.calculateTip(billAmtDouble, tipPercentage: percentageArray[index])
     }
    
    func prepateForAnimation() {
        self.calcView.frame.origin.y = 750
        self.tipPercentageSegment.frame.origin.y = 750
    }
    
    func applicationWillTerminateNotification() {
        let date = NSDate().timeIntervalSince1970
        defaults.set(date, forKey: "tipcalculator_closingtime")
        defaults.set(self.billAmount.text, forKey: "tipcalculator_billamount")
        defaults.set(self.tipPer!, forKey: "tipcalculator_tipPer")
        defaults.set(0, forKey: "tipcalculator_tipPerIndex")
        
        defaults.synchronize()
    }
    
    func applicationDidBecomeActive() {
        let lastClosingTime = defaults.double(forKey: "tipcalculator_closingtime")
        
//        let currentTime = NSDate().timeIntervalSince1970
//        let difference = currentTime - lastClosingTime
//        if difference <= 600 {
//            let billAmount = defaults.valueForKey("tipcalculator_billamount")
//            let tipSelectedIndex = defaults.integerForKey("tipcalculator_tipselectedindex")
//            if let b = billAmount as? String {
//                billField.text = b
//                tipControl.selectedSegmentIndex = tipSelectedIndex
//                calculateTotalAmount()
//            }
//            
//        }
    }
    
    func updateSettingsTipValue() {
        let defaults = UserDefaults.standard
        self.defaultTipPer = defaults.double(forKey: "tipcalculator_tipPer")
        self.defaultTipPerIndex =  defaults.integer(forKey: "tipcalculator_tipPerIndex")
        self.tipPercentageSegment.selectedSegmentIndex = self.defaultTipPerIndex!
        self.tipPer = self.defaultTipPer
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSettingsTipValue()
    }
}

extension ViewController : UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
      self.showUIControls()
    }
    
   
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (range.length==1 && string.isEmpty && self.billAmount.text?.characters.count == 1) {
            self.hideUIControls()
                
        }
        
        if (range.length==0 && !string.isEmpty && self.billAmount.text?.characters.count == 0) {
            self.showUIControls()
            
        }
        return true
    }
}

