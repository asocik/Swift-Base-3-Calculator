//
//  ViewController.swift
//  Base 3 Calculator
//
//  Created by Adam Socik on 4/28/15.
//

// An operator that allows you to take the power of two numbers: 2^3 = 2^^3 in this code
infix operator ^^ { }
func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    
    var result = String()
    var currentNumber = String()
    var currentOperation = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentOperation = "="
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func buttonNumberInput(sender: UIButton) {
        
        // Make sure that only numbers of maximum 10 digits are used
        // This also implies that the max calculations can only be 11 digits
        if count(currentNumber) < 10 {
            currentNumber = "\(currentNumber)\(sender.titleLabel!.text!)"
            self.resultLabel.text = currentNumber
        }
    }

    @IBAction func buttonOperation(sender: UIButton) {
        
        switch currentOperation {
        case "=":
            result = currentNumber
        case "+":
            result = addCurrentNumberAndResult()
        case "-":
            result = subtractCurrentNumberAndResult()
        default:
            println("Operation error")
        }
        
        currentNumber = ""
    
        resultLabel.text = "\(result)"
        
        if (sender.titleLabel!.text == "=") {
            result = ""
        }
        
        currentOperation = sender.titleLabel!.text! as String!
    }
    
    @IBAction func makeCurrentNumberNegative(sender: UIButton) {
        
        // If there is a "-" then make currentNumber positive
        if currentNumber.rangeOfString("-") != nil {
            currentNumber = dropFirst(currentNumber)
        }
        // Make the number negative
        else {
            currentNumber = "-\(currentNumber)"
        }
        
        resultLabel.text = "\(currentNumber)"
    }

    @IBAction func buttonClear(sender: UIButton) {
        
        result = ""
        currentNumber = ""
        currentOperation = "="
        resultLabel.text = "\(result)"
    }
    
    func addCurrentNumberAndResult() -> String {
    
        var sum = convertBase3StringToBase10Int(result) + convertBase3StringToBase10Int(currentNumber)
        return convertBase10IntToBase3String(sum)
    }
    
    func subtractCurrentNumberAndResult() -> String {
        
        var difference = convertBase3StringToBase10Int(result) - convertBase3StringToBase10Int(currentNumber)
        return convertBase10IntToBase3String(difference)
    }
    
    func convertBase3StringToBase10Int(string: String) -> Int {
        
        var exponent = 0
        var base10Int = 0
        var base3String = string
        var isNegative = false
        
        // If there is a "-" then remove it
        if base3String.rangeOfString("-") != nil {
            base3String = dropFirst(base3String)
            isNegative = true
        }
        
        var reverseBase3String = reverseString(base3String)
        
        for number in reverseBase3String {
            base10Int = base10Int + (String(number).toInt()! * (3 ^^ exponent))
            exponent++
        }
        
        if isNegative {
            base10Int = base10Int * -1
        }
        
        return base10Int
    }
    
    func convertBase10IntToBase3String(var base10Int : Int) -> String {
        
        if base10Int == 0 {
            return "0"
        }
        
        var isNegative = false;
        if base10Int < 0 {
            isNegative = true;
            base10Int = base10Int * -1
        }
        
        var base3String = ""
        
        // Convert to base 3
        while base10Int > 0 {
            base3String = "\(base3String)\(base10Int%3)"
            base10Int = base10Int / 3
        }
        
        if isNegative {
            return "-\(reverseString(base3String))"
        }
        
        return reverseString(base3String)
    }
    
    func reverseString(string : String) -> String {
        
        var reverse = ""
        for character in string {
            reverse = "\(character)\(reverse)"
        }
        
        return reverse
    }
}
