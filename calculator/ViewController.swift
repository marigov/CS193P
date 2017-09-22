//
//  ViewController.swift
//  test
//
//  Created by Miquel Àngel Rigo Vidal on 14/09/2017.
//  Copyright © 2017 Miquel Àngel Rigo Vidal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var userIsInTheMiddleOfTyping = false
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var sequenceDisplay: UILabel!
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            
            if(!(textCurrentlyInDisplay.contains(".") && digit == ".")){
                display.text = textCurrentlyInDisplay + digit
            }
        }
        else {
            if digit == "." {
                display.text = "0" + digit
            } else {
                display.text = digit
            }
            userIsInTheMiddleOfTyping = true
        }
        sequenceDisplay.text = brain.sequence
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    
    @IBAction func backSpace(_ sender: UIButton) {
        var newNumber = display.text!
        newNumber = newNumber.substring(to: newNumber.index(before: newNumber.endIndex))
        if !brain.sequence.contains("=") {
            if (newNumber != ""){
                display.text = newNumber
                userIsInTheMiddleOfTyping = true
            } else {
                display.text = "0"
                userIsInTheMiddleOfTyping = false
            }
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
            
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
        sequenceDisplay.text = brain.sequence
        
    }
}

