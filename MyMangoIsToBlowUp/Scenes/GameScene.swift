//
//  GameScene.swift
//  MyMangoIsToBlowUp
//
//  Created by Cipher Lunis on 1/6/24.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
    
    private var playerFrames = [SKTexture]()
    
    private var currentPlayerPosition: PlayerPositions = .middle
    
    let player = SKSpriteNode()
    
    private enum PlayerPositions: Int {
        case bottom = 0
        case middle = 1
        case top = 2
    }
    
    private struct Constants {
        static let BackgroundName = "MangoBG"
        
        static let MovingKey = "Moving"
        
        static let BackgroundScrollSpeed = 50.0
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        self.size = size
        
        let playerTextureAtlas = SKTextureAtlas(named: K.AnimationTextureAtlas)
        playerFrames.append(playerTextureAtlas.textureNamed(K.Images.Chomp1))
        playerFrames.append(playerTextureAtlas.textureNamed(K.Images.Chomp2))
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
        
        player.size = CGSize(width: frame.width/6, height: frame.width/6)
        player.texture = SKTexture(imageNamed: K.Images.Chomp1)
        player.position = CGPoint(x: size.width/10, y: size.height/2)
        player.run(SKAction.repeatForever(SKAction.animate(with: playerFrames, timePerFrame: 0.5, resize: false, restore: false)), withKey: Constants.MovingKey)
        player.zPosition = 1
        addChild(player)
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
            let wrap = SKAction.moveBy(x: backgroundNode.size.width, y: 0, duration: 0)
            let backgroundHorizScrollSequence = SKAction.sequence([moveRightToLeft, wrap])
            let infiniteHorizBGScroll = SKAction.repeatForever(backgroundHorizScrollSequence)
            backgroundNode.run(infiniteHorizBGScroll, withKey: Constants.MovingKey)
            
            addChild(backgroundNode)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let tapLocation = touch.location(in: view)
        // if tap top half of screen, move player up otherwise if tap bottom half, move player down
        if tapLocation.y < frame.height/2 {
            if currentPlayerPosition.rawValue < PlayerPositions.top.rawValue {
                currentPlayerPosition = PlayerPositions(rawValue: currentPlayerPosition.rawValue + 1)!
                player.position.y += frame.height/4
            }
        } else {
            if currentPlayerPosition.rawValue > PlayerPositions.bottom.rawValue {
                currentPlayerPosition = PlayerPositions(rawValue: currentPlayerPosition.rawValue - 1)!
                player.position.y -= frame.height/4
            }
        }
    }
}
