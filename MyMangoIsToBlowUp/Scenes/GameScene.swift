//
//  GameScene.swift
//  MyMangoIsToBlowUp
//
//  Created by Cipher Lunis on 1/6/24.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
    
    private struct Constants {
        static let BackgroundName = "MangoBG"
        
        static let MovingKey = "Moving"
        
        static let BackgroundScrollSpeed = 50.0
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        self.size = size
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        scene?.scaleMode = .fill
        anchorPoint = .zero
        
        initializeGame()
    }
    
    private func initializeGame() {
        scrollBackground(texture: SKTexture(imageNamed: K.Images.MangoFarmBG), z: 0, size: self.size, duration: Constants.BackgroundScrollSpeed)
    }
    
    private func scrollBackground(texture: SKTexture, z: CGFloat, size: CGSize, duration: Double) {
        for i in 0...1 {
            let backgroundNode = SKSpriteNode()
            backgroundNode.anchorPoint = .zero
            backgroundNode.texture = texture
            backgroundNode.aspectFillToSize(fillSize: size)
            backgroundNode.name = Constants.BackgroundName
            backgroundNode.position = CGPoint(x: backgroundNode.size.width * CGFloat(i), y: 0)
            
            let moveRightToLeft = SKAction.moveBy(x: -backgroundNode.size.width, y: 0, duration: duration)
            let wrap = SKAction.moveBy(x: backgroundNode.size.width, y: 0, duration: duration)
            let backgroundHorizScrollSequence = SKAction.sequence([moveRightToLeft, wrap])
            let infiniteHorizBGScroll = SKAction.repeatForever(backgroundHorizScrollSequence)
            backgroundNode.run(infiniteHorizBGScroll, withKey: Constants.MovingKey)
            
            addChild(backgroundNode)
        }
    }
}
