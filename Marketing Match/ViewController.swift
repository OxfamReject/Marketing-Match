//
//  ViewController.swift
//  Marketing Match
//
//  Created by Jo Thorpe on 30/04/2018.
//  Copyright © 2018 Oxfam Reject. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var model = CardModel()
    var cardArray = [Card]()
    var firstFlippedCardIndex:IndexPath?
    var secondFlippedCardIndex:IndexPath?
    var timer:Timer?
    var milliseconds:Float = 0 //10 * 1000 //30 seconds 3 * 1000
    var soundManager = SoundManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //call getcards
        cardArray = model.getCards()
        
        //create timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        
        RunLoop.main.add(timer!,forMode:.commonModes)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //super.viewDidAppear(true)
        soundManager.playSound(.shuffle)
        //SoundManager.playSound(.shuffle) alternative with statics in class
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //timer
    @objc func timerElapsed(){
        
        //decreases time every milisecond
        milliseconds += 1
        
        //convert to seconds
        let seconds = String(format: "%.2f", milliseconds/1000)
        
        //set label
        timerLabel.text = "Time taken: \(seconds)"
        
        //when it hits 0 stop timer
        //if milliseconds <= 0 {
           // timer?.invalidate()
           // timerLabel.textColor = UIColor.red
            
            //check is any cards are unmatched
            checkGameEnded()
      // }
    }
    
    // MARK: - UICollectionView Protocol Methods
    
    //number of items that will get displayed
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    //INDEX PATH KEEPS TRACK OF FIRST CARD FLIPPED
    //which cell the collection view is asking for
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //get a cardcollectionviewcell object
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        //get the card that the collection view is trying to display
        let card = cardArray[indexPath.row]
        //set that card for the cell
        cell.setCard(card)
        return cell
    }
    
    //part of delegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        //check if any time left, stops users clicking cards after game has finished
        if milliseconds <= 0 {
            return
        }
        
        //get cell user collected
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        //get card user selected
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false && card.isMatched == false {
            cell.flip()
            //play flip sound
            soundManager.playSound(.flip)
            
            card.isFlipped = true
            //determine if it's the first card flipped
            if firstFlippedCardIndex == nil {
                firstFlippedCardIndex = indexPath
            } else {
                //second card is being flipped
                //TODO: perform matching logic
                checkForMatches(indexPath)
            }
        } //end did select item methos
    }
    func checkForMatches(_ secondFlippedCardIndex:IndexPath){
        //get cells for two revelaed cards
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        //get cards for two revealed cards
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        //compare the two cards
        if cardOne.imageName == cardTwo.imageName {
            
            //its a match
            
            //play sound
            soundManager.playSound(.match)
            //set statsues
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            //remove cards from grid
            //question mark tries if not nil, otherwise woudl crash if nil
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            //check if any cards are left unmatched
            
            
        } else {
            //its not a match
            
            //play sound
            soundManager.playSound(.nomatch)
            
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            //set statuses of cards
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
            
            //flip cards back
        }
        
        //te;; the collection view to reload cell of first card if it is nil
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        //reset the first card  flipped checker
        firstFlippedCardIndex = nil
        
        
    }
    
    func checkGameEnded(){
        
        //determine if there are any cards unmatched
        var isWon = true
        for card in cardArray{
        if card.isMatched == false {
            isWon = false
            break
        }
        }
        
        //message variables
        var title = ""
        var message = ""
        //if not user has wom, stop timer
        if isWon == true {
            if milliseconds > 0 {
                timer?.invalidate()
                timerLabel.textColor = UIColor.green
            }
           
            let wintime = String(format: "%.2f", milliseconds/1000)
            title = "Congratulations"
            message = "Your time was \(wintime)"
        }else {
        //if unmatched cards, check if any time left
            if milliseconds > 0 {
                return
            }
            title = "Game Over"
            message = "You've lost"
        }
        //show won or lost
       showAlert(title, message)
    }
   
    func showAlert(_ title:String,_ message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Reset", style: .default){ _ in self.resetGame()
            
        }
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func resetGame(){
        
        //card model is called so get new cards in array
         model = CardModel()
         cardArray = [Card]()
         firstFlippedCardIndex = nil
         secondFlippedCardIndex = nil
         timer = nil
         milliseconds = 0 //10 * 1000 //30 seconds 3 * 1000
       
        viewDidLoad()
        
        for card in cardArray{
            if card.isMatched == false {
                card.isFlipped = false
                card.isMatched = false
            }
        }
        timerLabel.textColor = UIColor.black
        self.view.setNeedsDisplay()
        
        //now its NOT checking to see if they are matched
        
        //make status of all cards back to is not matched is not flipped
      /*  for card in cardArray {
            card.isMatched = false
            card.isFlipped = false
        } */
        
        //show back of all cards again
        //reset all stauses back to not flipped
        //reset matches to none
        
    }
    
} // end view controller




