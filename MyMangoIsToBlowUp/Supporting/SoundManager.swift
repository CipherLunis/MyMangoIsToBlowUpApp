//
//  SoundManager.swift
//  MyMangoIsToBlowUp
//
//  Created by Cipher Lunis on 1/7/24.
//

import Foundation
import AVFoundation

class SoundManager: NSObject, AVAudioPlayerDelegate {
    
    static let sharedInstance = SoundManager()
    
    private override init() {}
    
    var audioPlayers =  [URL:AVAudioPlayer]()
    
    public func playSound(fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: K.FileTypes.mp3) else {
            return
        }
        
        if let player = audioPlayers[url] { // player exists for sound
            if(player.isPlaying == false) {
                player.prepareToPlay()
                player.play()
            }
        } else { // player does not exist for sound
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                audioPlayers[url] = player
                player.prepareToPlay()
                player.play()
            } catch {
                print("Could not play sound!")
            }
        }
    }
}
