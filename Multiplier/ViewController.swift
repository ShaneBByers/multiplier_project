//
//  ViewController.swift
//  Multiplier
//
//  Created by Shane Byers on 8/31/16.
//  Copyright © 2016 Shane Byers. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var exerciseTitleLabel: UILabel!
    
    @IBOutlet weak var firstNumberLabel: UILabel!
    @IBOutlet weak var secondNumberLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var signLabel: UILabel!
    
    @IBOutlet weak var guessButtons: UISegmentedControl!
    
    @IBOutlet weak var questionCounterLabel: UILabel!
    @IBOutlet weak var correctLabel: UILabel!
    
    @IBOutlet weak var exerciseChoiceButtons: UISegmentedControl!
    
    @IBOutlet weak var numberOfQuestionsLabel: UILabel!
    @IBOutlet weak var numberOfQuestionsButtons: UISegmentedControl!
    
    @IBOutlet weak var nextButton: UIButton!
    
    let maxValue = 10
    let maxGuessDistance = 5
    
    var totalNumberOfQuestions = 0
    var correctNumberOfQuestions = 0
    var currentNumberOfQuestions = 0
    var correctAnswer = 0
    
    var userHasStarted = false
    var userHasEnded = false
    
    
    enum arithmeticChoice: String {
        case Adder = "Adder"
        case Subtracter = "Subtracter"
        case Multiplier = "Multiplier"
        case Combo = "Combo"
    }
    
    var exerciseChoice = arithmeticChoice(rawValue: "Combo")!
    
    /* Populates the guessButtons Segmented Control values to include
       the correct answer in a random position and incorrect answers
       in the other positions. */
    func populateGuesses() {
        
        var guesses = [Int]()
        var tempRand = 0
        
        for _ in 1...guessButtons.numberOfSegments - 1 {
            tempRand = Int(arc4random_uniform(UInt32(maxGuessDistance * 2))) - 5
            
            while guesses.index(of: correctAnswer + tempRand) != nil ||
                    tempRand == 0 ||
                    (exerciseChoice != .Subtracter
                            && correctAnswer + tempRand < 0) {
                                
                tempRand = Int(arc4random_uniform(UInt32(maxGuessDistance)))
            }
            
            guesses.append(correctAnswer + tempRand)
        }
        
        let correctAnswerPosition = Int(arc4random_uniform(UInt32(guessButtons.numberOfSegments)))
        
        for i in 0...guessButtons.numberOfSegments - 1 {
            
            if i == correctAnswerPosition {
                guessButtons.setTitle(String(correctAnswer), forSegmentAt: i)
            } else {
                guessButtons.setTitle(String(guesses.popLast()!), forSegmentAt: i)
            }
            
        }
    }
    
    func setSignLabel() {
        switch exerciseChoice {
        case .Adder:
            signLabel.text = "+"
        case .Multiplier:
            signLabel.text = "x"
        case .Subtracter:
            signLabel.text = "-"
        case .Combo:
            signLabel.text = "?"
        }
    }
    
    
    
    @IBAction func exerciseChoiceButtonPressed(_ sender: UISegmentedControl) {
        
        let _arithmeticChoice = sender.titleForSegment(at: sender.selectedSegmentIndex)!
        
        exerciseChoice = arithmeticChoice(rawValue: _arithmeticChoice)!
        
        exerciseTitleLabel.text = _arithmeticChoice + " Exercises"
        
        setSignLabel()
        
    }
    
    @IBAction func guessButtonPressed(_ sender: UISegmentedControl) {
        
        nextButton.isHidden = false
        
        if sender.titleForSegment(at: sender.selectedSegmentIndex)! == String(correctAnswer) {
            correctLabel.isHidden = false
            correctLabel.text = "Correct!"
            correctNumberOfQuestions += 1
        } else {
            correctLabel.isHidden = false
            correctLabel.text = "Incorrect!"
        }
        
        currentNumberOfQuestions += 1
        
        guessButtons.isEnabled = false
        
        answerLabel.text = String(correctAnswer)
        questionCounterLabel.text = String(correctNumberOfQuestions) + "/" + String(currentNumberOfQuestions) + " Questions Correct"
        
        if currentNumberOfQuestions == totalNumberOfQuestions {
            nextButton.setTitle("Reset", for: UIControlState())
            userHasEnded = true
        }
        
    }
    

    @IBAction func nextButtonPressed(_ sender: AnyObject) {
        
        if !userHasStarted || !userHasEnded {
            
            nextButton.setTitle("Next", for: UIControlState())
            userHasStarted = true
            guessButtons.isHidden = false
            let firstNumber = Int(arc4random_uniform(UInt32(maxValue)))
            let secondNumber = Int(arc4random_uniform(UInt32(maxValue)))
            firstNumberLabel.text = String(firstNumber)
            secondNumberLabel.text = String(secondNumber)
            
            exerciseChoice = arithmeticChoice(rawValue: exerciseChoiceButtons.titleForSegment(at: exerciseChoiceButtons.selectedSegmentIndex)!)!
            
            if exerciseChoice == .Combo {
                // Assumes "Combo" is the last choice
                let randomArithmetic = Int(arc4random_uniform(UInt32(exerciseChoiceButtons.numberOfSegments-1)))
                exerciseChoice = arithmeticChoice(rawValue: exerciseChoiceButtons.titleForSegment(at: randomArithmetic)!)!
            }
            
            switch exerciseChoice {
                case .Adder:
                    correctAnswer = firstNumber + secondNumber
                case .Multiplier:
                    correctAnswer = firstNumber * secondNumber
                case .Subtracter:
                    correctAnswer = firstNumber - secondNumber
                case .Combo:
                    // Handled in above if statement
                    break
            }
            
            totalNumberOfQuestions = Int(numberOfQuestionsButtons.titleForSegment(at: numberOfQuestionsButtons.selectedSegmentIndex)!)!
            
            populateGuesses()
            
            setSignLabel()
            
            guessButtons.selectedSegmentIndex = -1
            guessButtons.isEnabled = true
            
            answerLabel.text = ""
            correctLabel.text = ""
            exerciseChoiceButtons.isHidden = true
            numberOfQuestionsLabel.isHidden = true
            numberOfQuestionsButtons.isHidden = true
            questionCounterLabel.isHidden = false
            
            userHasEnded = false
            nextButton.isHidden = true
            
        } else if userHasEnded {
            
            firstNumberLabel.text = ""
            secondNumberLabel.text = ""
            answerLabel.text = ""
            correctLabel.text = ""
            
            exerciseChoice = arithmeticChoice(rawValue: exerciseChoiceButtons.titleForSegment(at: exerciseChoiceButtons.selectedSegmentIndex)!)!
            
            setSignLabel()
            
            guessButtons.isHidden = true
            
            
            questionCounterLabel.text = "0/0 Questions Correct"
            questionCounterLabel.isHidden = true
            
            exerciseChoiceButtons.isHidden = false
            numberOfQuestionsLabel.isHidden = false
            numberOfQuestionsButtons.isHidden = false
            
            nextButton.setTitle("Start", for: UIControlState())
            
            correctNumberOfQuestions = 0
            currentNumberOfQuestions = 0
            userHasStarted = false
        }
    }
}

