//
//  GameScene.swift
//  MyMangoIsToBlowUp
//
//  Created by Cipher Lunis on 1/6/24.
//

import Foundation
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate, ObservableObject {
    
    private var playerFrames = [SKTexture]()
    
    private var currentPlayerPosition: PlayerPositions = .middle
    
    private let player = SKSpriteNode()
    private let pointsLabel = SKLabelNode()
    private var hearts = [SKSpriteNode]()
    
    private var spawnTimer = Timer()
    
    private var lives = 3
    
    @Published var points = 0
    @Published var isGameOver = false
    
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
        static let ChompAnimationSpeed = 0.2
        static let MangoOrBombMoveSpeed = 6.0
        static let SpawnSpeed = 1.0
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
    
    func initializeGame() {
        cleanUpGame()
        SoundManager.sharedInstance.playSound(fileName: K.Sounds.FullQuote)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [self] in
            points = 0
            pointsLabel.applyStrokedAttributes(text: "\(points)", strokeWidth: -2, strokeColor: .black, fillColor: .white, fontName: "TimesNewRomanPS-BoldMT", fontSize: 100)
        }
        lives = 3
        isGameOver = false
        currentPlayerPosition = .middle
        hearts = []
        
        scrollBackground(texture: SKTexture(imageNamed: K.Images.MangoFarmBG), size: self.size, duration: Constants.BackgroundScrollSpeed)
        
        pointsLabel.position = CGPoint(x: frame.width/8 * 7, y: frame.height/1.3)
        pointsLabel.zPosition = 3
        pointsLabel.applyStrokedAttributes(text: "\(points)", strokeWidth: -2, strokeColor: .black, fillColor: .white, fontName: "TimesNewRomanPS-BoldMT", fontSize: 100)
        self.addChild(pointsLabel)
        
        player.size = CGSize(width: frame.width/6, height: frame.width/6)
        player.physicsBody = SKPhysicsBody(texture: K.Textures.PlayerTexture, size: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = ColliderTypes.playerCategory.rawValue
        player.physicsBody?.collisionBitMask = 0b11
        player.physicsBody?.contactTestBitMask = ColliderTypes.mangoCategory.rawValue | ColliderTypes.bombCategory.rawValue
        player.texture = K.Textures.PlayerTexture
        player.position = CGPoint(x: size.width/10, y: size.height/2)
        player.run(SKAction.repeatForever(SKAction.animate(with: playerFrames, timePerFrame: Constants.ChompAnimationSpeed, resize: false, restore: false)), withKey: Constants.MovingKey)
        player.zPosition = 1
        addChild(player)
        
        for i in 0..<3 {
            let heartSize = CGSize(width: frame.width/16, height: frame.width/16)
            let heartXInitialPos = frame.width/4*3
            let heartWidthOffset = CGFloat(i)*frame.width/16.0
            let additionalOffset = frame.width/18
            let heartX: CGFloat = heartXInitialPos + heartWidthOffset + additionalOffset
            let heart = createHeart(x: heartX, size: heartSize)
            addChild(heart)
            
            hearts.append(heart)
        }
        
        spawnTimer = .scheduledTimer(timeInterval: Constants.SpawnSpeed, target: self, selector: #selector(spawnMangoOrBomb), userInfo: nil, repeats: true)
    }
    
    private func cleanUpGame() {
        self.removeAllActions()
        self.removeAllChildren()
    }
    
    private func scrollBackground(texture: SKTexture, size: CGSize, duration: Double) {
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
        mango.size = CGSize(width: frame.width/10, height: frame.width/10)
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
        bomb.size = CGSize(width: frame.width/10, height: frame.width/10)
        bomb.position = CGPoint(x: frame.width/8 * 9, y: y)
        bomb.zPosition = 2
        bomb.physicsBody = SKPhysicsBody(texture: K.Textures.BombTexture, size: bomb.size)
        bomb.physicsBody?.affectedByGravity = false
        bomb.physicsBody?.categoryBitMask = ColliderTypes.bombCategory.rawValue
        bomb.physicsBody?.collisionBitMask = 0
        bomb.physicsBody?.contactTestBitMask = ColliderTypes.playerCategory.rawValue
        return bomb
    }
    
    private func createHeart(x: CGFloat, size: CGSize) -> SKSpriteNode {
        let heart = SKSpriteNode(texture: K.Textures.HeartTexture)
        heart.size = size
        heart.position = CGPoint(x: x, y: frame.height/12)
        heart.zPosition = 3
        return heart
    }
    
    @objc private func spawnMangoOrBomb() {
        var yPosition = 0.0
        switch Int.random(in: 1...3) {
        case 1:
            yPosition = frame.height/2 + frame.height/3.5
        case 2:
            yPosition = frame.height/2
        default:
            yPosition = frame.height/2 - frame.height/3.5
        }
        let movingObject = Int.random(in: 1...3) == 3 ? createBomb(y: yPosition) : createMango(y: yPosition)
        let moveRightToLeft = SKAction.moveTo(x: -movingObject.size.width, duration: Constants.MangoOrBombMoveSpeed)
        let removeObject = SKAction.removeFromParent()
        let moveAndRemoveSequence = SKAction.sequence([moveRightToLeft, removeObject])
        
        movingObject.run(moveAndRemoveSequence, withKey: Constants.MovingKey)
        addChild(movingObject)
    }
    
    private func gameOver() {
        isGameOver = true
        
        self.enumerateChildNodes(withName: "*", using: { node, _ in
            if let action = node.action(forKey: Constants.MovingKey) {
                action.speed = 0
            }
        })
        
        spawnTimer.invalidate()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let tapLocation = touch.location(in: view)
        // if tap top half of screen, move player up otherwise if tap bottom half, move player down
        if tapLocation.y < frame.height/2 {
            if currentPlayerPosition.rawValue < PlayerPositions.top.rawValue {
                currentPlayerPosition = PlayerPositions(rawValue: currentPlayerPosition.rawValue + 1)!
                player.position.y += frame.height/3.5
            }
        } else {
            if currentPlayerPosition.rawValue > PlayerPositions.bottom.rawValue {
                currentPlayerPosition = PlayerPositions(rawValue: currentPlayerPosition.rawValue - 1)!
                player.position.y -= frame.height/3.5
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player || nodeB == player {
            if nodeA.physicsBody?.categoryBitMask == ColliderTypes.mangoCategory.rawValue {
                if Int.random(in: 0...1) == 0 {
                    SoundManager.sharedInstance.playSound(fileName: K.Sounds.MyMango)
                } else {
                    SoundManager.sharedInstance.playSound(fileName: K.Sounds.Laugh)
                }
                points += 1
                pointsLabel.applyStrokedAttributes(text: "\(points)", strokeWidth: -2, strokeColor: .black, fillColor: .white, fontName: "ArialRoundedMTBold", fontSize: 100)
                nodeA.removeFromParent()
            } else if nodeB.physicsBody?.categoryBitMask == ColliderTypes.mangoCategory.rawValue {
                
                if Int.random(in: 0...1) == 0 {
                    SoundManager.sharedInstance.playSound(fileName: K.Sounds.MyMango)
                } else {
                    SoundManager.sharedInstance.playSound(fileName: K.Sounds.Laugh)
                }
                points += 1
                pointsLabel.applyStrokedAttributes(text: "\(points)", strokeWidth: -2, strokeColor: .black, fillColor: .white, fontName: "ArialRoundedMTBold", fontSize: 100)
                nodeB.removeFromParent()
            }
            
            if nodeA.physicsBody?.categoryBitMask == ColliderTypes.bombCategory.rawValue || nodeB.physicsBody?.categoryBitMask == ColliderTypes.bombCategory.rawValue {
                if nodeA.physicsBody?.categoryBitMask == ColliderTypes.bombCategory.rawValue {
                    lives -= 1
                    SoundManager.sharedInstance.playSound(fileName: K.Sounds.BlowUp)
                    
                    let removedHeart = hearts.popLast()
                    removedHeart?.removeFromParent()
                    
                    let explosionParticles = SKEmitterNode(fileNamed: "SmokeParticle.sks")!
                    explosionParticles.position = CGPoint(x: nodeB.position.x, y: nodeB.position.y - nodeB.frame.height/2)
                    explosionParticles.zPosition = 4
                    explosionParticles.particlePositionRange.dx = nodeB.frame.width/1.3
                    
                    let waitAction = SKAction.wait(forDuration: 0.2)
                    let removeExplosion = SKAction.removeFromParent()
                    let explosionSequence = SKAction.sequence([waitAction, removeExplosion])
                    addChild(explosionParticles)
                    explosionParticles.run(explosionSequence)
                    nodeA.removeFromParent()
                } else if nodeB.physicsBody?.categoryBitMask == ColliderTypes.bombCategory.rawValue {
                    lives -= 1
                    SoundManager.sharedInstance.playSound(fileName: K.Sounds.BlowUp)
                    
                    let removedHeart = hearts.popLast()
                    removedHeart?.removeFromParent()
                    
                    let explosionParticles = SKEmitterNode(fileNamed: "SmokeParticle.sks")!
                    explosionParticles.position = CGPoint(x: nodeA.position.x, y: nodeA.position.y - nodeA.frame.height/2)
                    explosionParticles.zPosition = 4
                    explosionParticles.particlePositionRange.dx = nodeA.frame.width/1.3
                    
                    let waitAction = SKAction.wait(forDuration: 0.2)
                    let removeExplosion = SKAction.removeFromParent()
                    let explosionSequence = SKAction.sequence([waitAction, removeExplosion])
                    addChild(explosionParticles)
                    explosionParticles.run(explosionSequence)
                    nodeB.removeFromParent()
                }
                if(lives == 0) {
                    gameOver()
                }
            }
        }
    }
}
