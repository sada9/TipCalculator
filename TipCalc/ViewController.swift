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
    @IBOutlet weak var tipPercentageSegment: UISegmentedControl!

    @IBOutlet weak var tipAmountLbl: UILabel!

    @IBOutlet weak var totalAmtLbl: UILabel!

    let tipPercentages = [15,20,25]
    var tipIndex: Int? = 0
    let defaults = UserDefaults.standard
    var defaultTipPerIndex: Int?

    var theme: Theme? = Theme.white

    override func viewDidLoad() {
        super.viewDidLoad()

        self.prepateForAnimation()
        self.billAmount.delegate = self
        self.setThemeColors()

        billAmount.addTarget(self, action: #selector(billAmountDidChange(_:)), for: .editingChanged)
        tipPercentageSegment.addTarget(self, action: #selector(tipPercentageIndexChanged(_:)), for: UIControlEvents.valueChanged)
        billAmount.becomeFirstResponder()
        let notificationCenter = NotificationCenter.default

        // Add observer:
        notificationCenter.addObserver(self,
                                       selector: #selector(ViewController.applicationWillTerminate),
                                       name:NSNotification.Name.UIApplicationWillTerminate,
                                       object:nil)

        notificationCenter.addObserver(self, selector: #selector(ViewController.applicationDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }




    func billAmountDidChange(_ textField: UITextField? = nil) {

        guard let billAmtString = textField?.text else {
            return
        }

        guard let billAmtDouble = Double(billAmtString) else {
            return
        }
        print(billAmtString)

        guard let tipIndex = tipIndex else {
            return
        }

        calculateTip(billAmtDouble,tipPercentage: Double(self.tipPercentages[tipIndex]))

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
        self.tipIndex = tipPercentageSegment.selectedSegmentIndex
        self.billAmountDidChange(self.billAmount)
    }

    func prepateForAnimation() {
        self.calcView.frame.origin.y = 750
        self.tipPercentageSegment.frame.origin.y = 750
    }

    func applicationWillTerminate() {
        let date = NSDate().timeIntervalSince1970
        defaults.set(date, forKey: "tipcalculator_closingtime")
        defaults.set(self.billAmount.text, forKey: "tipcalculator_billamount")
        defaults.set(self.tipPercentageSegment.selectedSegmentIndex, forKey: "tipcalculator_tipPerIndex")
        defaults.synchronize()
    }

    func applicationDidBecomeActive() {
        let lastClosingTime = defaults.double(forKey: "tipcalculator_closingtime")

        let currentTime = NSDate().timeIntervalSince1970
        let difference = currentTime - lastClosingTime
        if difference <= 600 {
            let billAmount = defaults.value(forKey: "tipcalculator_billamount")
            let tipSelectedIndex = defaults.integer(forKey: "tipcalculator_tipselectedindex")
            if let amount = billAmount as? String {
                self.billAmount.text = amount
                self.tipIndex = tipSelectedIndex
                self.tipPercentageSegment.selectedSegmentIndex = tipSelectedIndex
                billAmountDidChange(self.billAmount)
            }

        }
    }

    func updateSettingsTipValue() {
        let defaults = UserDefaults.standard

        self.defaultTipPerIndex =  defaults.integer(forKey: "tipcalculator_tipPerIndex")
        self.tipPercentageSegment.selectedSegmentIndex = self.defaultTipPerIndex!
        self.tipIndex = self.defaultTipPerIndex
        //change theme
        if defaults.integer(forKey: "tipcalculator_theme") == 0 {
            self.theme = .teal
            //this is weird. needs a proper fix
            defaults.set(0, forKey: "tipcalculator_theme")
        }
        else {
            self.theme = .white
        }

        self.setThemeColors()

        //calc tip
        if !(self.billAmount.text?.isEmpty)! {
            billAmountDidChange(self.billAmount)
        }


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSettingsTipValue()

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
                self.calcView.frame.origin.y = 270
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
}

extension ViewController {

    enum Theme {
        case teal
        case white

        func getMainColor() -> UIColor {
            switch self {
            case .teal:
                return UIColor(red: 98/255.0, green: 203/255.0, blue: 188/255.0,alpha: 1)

            case .white:
                return UIColor(red: 244/255.0, green: 244/255.0, blue: 241/255.0,alpha: 1)
            }
        }

        func getSecColor() -> UIColor {
            switch self {
            case .teal:
                return UIColor(red: 100/255.0, green: 181/255.0, blue: 172/255.0,alpha: 1)

            case .white:
                return UIColor(red: 231/255.0, green: 229/255.0, blue: 226/255.0,alpha: 1)

            }
        }

        func getSegmentColor() -> UIColor {
            switch self {
            case .teal:
                return UIColor(red: 30/255.0, green: 93/255.0, blue: 76/255.0,alpha: 1)

            case .white:
                 return UIColor(red: 77/255.0, green: 179/255.0, blue: 179/255.0,alpha: 1)

            }
        }
    }

    func setThemeColors() {
        self.view.backgroundColor = self.theme?.getMainColor()
        self.navigationController?.navigationBar.barTintColor =  self.theme?.getMainColor()


        self.calcView.backgroundColor = self.theme?.getSecColor()

        self.billAmount.textColor = self.theme?.getSegmentColor()
        self.tipAmount.textColor = self.theme?.getSegmentColor()
        self.totalAmount.textColor = self.theme?.getSegmentColor()
        self.totalAmtLbl.textColor = self.theme?.getSegmentColor()
        self.tipAmountLbl.textColor = self.theme?.getSegmentColor()
        self.tipPercentageSegment.tintColor = self.theme?.getSegmentColor()
    }

}

extension ViewController : UITextFieldDelegate {

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        //self.showUIControls()
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

