//
//  SoundManager.swift
//  Marketing Match
//
//  Created by Jo Thorpe on 03/05/2018.
//  Copyright © 2018 Oxfam Reject. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    var audioPlayer:AVAudioPlayer?
    
    //specify one of 4 values
    enum SoundEffect {
        
        case flip
        case shuffle
        case match
        case nomatch
        
    }
    
    func playSound(_ effect:SoundEffect){
        
        var soundFilename = ""
        
        switch effect {
        case .flip:
            soundFilename = "cardflip"
        case .shuffle:
            soundFilename = "shuffle"
        case .match:
            soundFilename = "dingcorrect"
        case .nomatch:
            soundFilename = "dingwrong"
       // default:
           // soundFilename = " "
        }
        
        //get path to sound file
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: "wav")
        
        guard bundlePath != nil else {
            print("couldn't find \(soundFilename)")
            return
        }
        
        //create a url objejct from this string path
        let soundURL = URL(fileURLWithPath: bundlePath!)
        
        //create audio player object
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
            
        } catch {
            //couldn't create audio player object
            print("Couldn't create audio player object for \(soundFilename) ")
        }
    }
}
