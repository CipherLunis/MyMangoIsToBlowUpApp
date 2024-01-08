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
    
    var body: some View {
        ZStack {
            SpriteView(scene: gameScene)
                .ignoresSafeArea()
            Rectangle()
                .fill(.black)
                .ignoresSafeArea()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .opacity(gameScene.isGameOver ? 0.5 : 0.0)
            if gameScene.isGameOver {
                GameOverView(score: gameScene.points)
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
