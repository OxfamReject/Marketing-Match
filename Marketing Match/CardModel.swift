//
//  CardModel.swift
//  Marketing Match
//
//  Created by Jo Thorpe on 01/05/2018.
//  Copyright © 2018 Oxfam Reject. All rights reserved.
//

import Foundation

class CardModel{
    func getCards()-> [Card] {
        //array to store numbers we have already generated
        var generatedNumbersArray = [Int]()
        
        //Declare an array to store the generated cards
        var generatedCardsArray = [Card]()
        
        //Randomly generate pairs of cars
        while generatedNumbersArray.count < 8 {
            
            //get random number
            let randomNumber = arc4random_uniform(9) + 1
            //makse sure no repeating cards
            if generatedNumbersArray.contains(Int(randomNumber)) == false {
                
                generatedNumbersArray.append(Int(randomNumber))
                //create first card
                let cardOne = Card()
                cardOne.imageName = "card\(randomNumber)"
                generatedCardsArray.append(cardOne)
                print(randomNumber)
                
                //create second card
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"
                generatedCardsArray.append(cardTwo)
                //every card needs to be generated twice to make a pair, so sixteen in total
                
            }
            
            
            
            //TO DO: make it so it's 8 unique cards not repeat (use while loop, video 4 15:44 in)
            for i in 0...generatedCardsArray.count - 1 {
                //find random index to swap with
                let randomNumber = Int(arc4random_uniform(UInt32(generatedCardsArray.count)))
                //swap two cards
                let tempStorage = generatedCardsArray[i]
                generatedCardsArray[i] = generatedCardsArray[randomNumber]
                generatedCardsArray[randomNumber] = tempStorage
            }
           
        }
        //Randomise the array
        
        //Return the array
        return generatedCardsArray
        
        
    }
}
