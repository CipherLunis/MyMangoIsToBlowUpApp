//
//  GameView.swift
//  MyMangoIsToBlowUp
//
//  Created by Cipher Lunis on 1/6/24.
//

import SpriteKit
import SwiftUI

struct GameView: View {
    
    @StateObject var gameScene = GameScene(size: UIScreen.main.bounds.size)
    @Binding var didStartGame: Bool
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                SpriteView(scene: gameScene)
                    .ignoresSafeArea()
                // shadow opacity
                Rectangle()
                    .fill(.black)
                    .ignoresSafeArea()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .opacity(gameScene.isGameOver ? 0.5 : 0.0)
                GameOverView(score: gameScene.points,
                             playAgain: {
                                gameScene.initializeGame()
                            }, backToStart: {
                                didStartGame = false
                            })
                    .offset(y: gameScene.isGameOver ? 0.0 : geo.size.height)
                    .animation(.interpolatingSpring(mass: 0.01, stiffness: 1, damping: 0.5, initialVelocity: 5.0), value: gameScene.isGameOver)
            }
        }
    }
}


struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(didStartGame: .constant(true))
    }
}
