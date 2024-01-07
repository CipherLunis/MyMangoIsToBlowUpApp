//
//  GameView.swift
//  MyMangoIsToBlowUp
//
//  Created by Cipher Lunis on 1/6/24.
//

import SpriteKit
import SwiftUI

struct GameView: View {
    var body: some View {
        SpriteView(scene: GameScene(size: UIScreen.main.bounds.size))
            .ignoresSafeArea()
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
