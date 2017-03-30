//
//  ViewController.swift
//  Calculator
//
//  Created by Eric Chown on 9/5/16.
//  Copyright © 2016 edu.bowdoin.cs2505.chown. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var userIsInTheMiddleOfTypingANumber = false
    
    private var brain = CalculatorBrain()
    
    private var displayValue : Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = "\(newValue)"
        }
    }

    @IBOutlet private weak var display: UILabel!

    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        let textCurrentlyInDisplay = display.text!
        if userIsInTheMiddleOfTypingANumber {
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    var savedProgram: CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        savedProgram = brain.program
    }
    
    
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            userIsInTheMiddleOfTypingANumber = false
            brain.setOperand(displayValue)
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result
        print("\(brain.description)")
    }
    
}

