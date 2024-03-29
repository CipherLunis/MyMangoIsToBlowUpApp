//
//  Constants.swift
//  MyMangoIsToBlowUp
//
//  Created by Cipher Lunis on 1/6/24.
//

import Foundation
import SpriteKit

struct K {
    static let AnimationTextureAtlas = "ChompAnimation"
    
    struct FileTypes {
        static let mp3 = "mp3"
    }
    
    struct Images {
        static let Bomb = "Bomb"
        static let Chomp1 = "Chomp1"
        static let Chomp2 = "Chomp2"
        static let Heart = "Heart"
        static let Mango = "Mango"
        static let MangoFarmBG = "MangoFarmBG"
    }
    
    struct Sounds {
        static let BlowUp = "Blow Up"
        static let FullQuote = "My Mango is to Blow Up and Then Act Like I Don't Know Nobody"
        static let Laugh = "HEHEHE"
        static let MyMango = "My Mango"
    }
    
    struct Textures {
        static let BombTexture = SKTexture(imageNamed: K.Images.Bomb)
        static let HeartTexture = SKTexture(imageNamed: K.Images.Heart)
        static let MangoTexture = SKTexture(imageNamed: K.Images.Mango)
        static let PlayerTexture = SKTexture(imageNamed: K.Images.Chomp1)
    }
}
