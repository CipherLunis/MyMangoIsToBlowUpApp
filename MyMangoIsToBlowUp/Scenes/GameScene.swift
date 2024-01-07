//
//  GameScene.swift
//  MyMangoIsToBlowUp
//
//  Created by Cipher Lunis on 1/6/24.
//

import Foundation
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var playerFrames = [SKTexture]()
    
    private var currentPlayerPosition: PlayerPositions = .middle
    
    let player = SKSpriteNode()
    
    var spawnTimer = Timer()
    
    private enum PlayerPositions: Int {
        case bottom = 0
        case middle = 1
        case top = 2
    }
    
    private enum ColliderTypes: UInt32 {
        case playerCategory = 0b100
        case mangoCategory = 0b1000
        case bombCategory = 0b10000
    }
    
    private struct Constants {
        static let BackgroundName = "MangoBG"
        
        static let MovingKey = "Moving"
        
        static let BackgroundScrollSpeed = 50.0
        static let MangoOrBombMoveSpeed = 7.0
        static let SpawnSpeed = 2.0
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
        
        physicsWorld.contactDelegate = self
    }
    
    private func initializeGame() {
        scrollBackground(texture: SKTexture(imageNamed: K.Images.MangoFarmBG), z: 0, size: self.size, duration: Constants.BackgroundScrollSpeed)
        
        player.size = CGSize(width: frame.width/6, height: frame.width/6)
        player.physicsBody = SKPhysicsBody(texture: K.Textures.PlayerTexture, size: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = ColliderTypes.playerCategory.rawValue
        player.physicsBody?.collisionBitMask = 0b11
        player.physicsBody?.contactTestBitMask = ColliderTypes.mangoCategory.rawValue | ColliderTypes.bombCategory.rawValue
        player.texture = K.Textures.PlayerTexture
        player.position = CGPoint(x: size.width/10, y: size.height/2)
        player.run(SKAction.repeatForever(SKAction.animate(with: playerFrames, timePerFrame: 0.5, resize: false, restore: false)), withKey: Constants.MovingKey)
        player.zPosition = 1
        addChild(player)
        
        spawnTimer = .scheduledTimer(timeInterval: Constants.SpawnSpeed, target: self, selector: #selector(spawnMangoOrBomb), userInfo: nil, repeats: true)
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
    
    private func createMango(y: CGFloat) -> SKSpriteNode {
        let mango = SKSpriteNode(texture: K.Textures.MangoTexture)
        mango.size = CGSize(width: frame.width/8, height: frame.width/8)
        mango.position = CGPoint(x: frame.width/8 * 9, y: y)
        mango.zPosition = 2
        mango.physicsBody = SKPhysicsBody(texture: K.Textures.MangoTexture, size: mango.size)
        mango.physicsBody?.affectedByGravity = false
        mango.physicsBody?.categoryBitMask = ColliderTypes.mangoCategory.rawValue
        mango.physicsBody?.collisionBitMask = 0
        mango.physicsBody?.contactTestBitMask = ColliderTypes.playerCategory.rawValue
        return mango
    }
    
    private func createBomb(y: CGFloat) -> SKSpriteNode {
        let bomb = SKSpriteNode(texture: K.Textures.BombTexture)
        bomb.size = CGSize(width: frame.width/8, height: frame.width/8)
        bomb.position = CGPoint(x: frame.width/8 * 9, y: y)
        bomb.zPosition = 2
        bomb.physicsBody = SKPhysicsBody(texture: K.Textures.BombTexture, size: bomb.size)
        bomb.physicsBody?.affectedByGravity = false
        bomb.physicsBody?.categoryBitMask = ColliderTypes.bombCategory.rawValue
        bomb.physicsBody?.collisionBitMask = 0
        bomb.physicsBody?.contactTestBitMask = ColliderTypes.playerCategory.rawValue
        return bomb
    }
    
    @objc private func spawnMangoOrBomb() {
        var yPosition = 0.0
        switch Int.random(in: 1...3) {
        case 1:
            yPosition = frame.height/2 + frame.height/4
        case 2:
            yPosition = frame.height/2
        default:
            yPosition = frame.height/2 - frame.height/4
        }
        let movingObject = Int.random(in: 1...3) == 3 ? createBomb(y: yPosition) : createMango(y: yPosition)
        let moveRightToLeft = SKAction.moveTo(x: -movingObject.size.width, duration: Constants.MangoOrBombMoveSpeed)
        let removeObject = SKAction.removeFromParent()
        let moveAndRemoveSequence = SKAction.sequence([moveRightToLeft, removeObject])
        
        movingObject.run(moveAndRemoveSequence, withKey: Constants.MovingKey)
        addChild(movingObject)
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
