//
//  GameOverView.swift
//  MyMangoIsToBlowUp
//
//  Created by Cipher Lunis on 1/7/24.
//

import SwiftUI

struct GameOverView: View {
    let isIPad = UIDevice.current.userInterfaceIdiom == .pad
    
    var score: Int
    var playAgain: () -> Void
    var backToStart: () -> Void
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    Text("Game Over!")
                        .foregroundColor(.black)
                        .font(.system(size: isIPad ? 80 : 60))
                        .fontWeight(.bold)
                        .frame(width: geo.size.width/2)
                    Spacer()
                    Text("Score: \(score)")
                        .foregroundColor(.black)
                        .font(.system(size: isIPad ? 50 : 30))
                        .fontWeight(.semibold)
                    Spacer()
                    HStack {
                        Button {
                            playAgain()
                        } label: {
                            Text("Play Again")
                                .foregroundColor(.black)
                                .font(.system(size: isIPad ? 50 : 30))
                        }
                        .frame(width: geo.size.width/5, height: geo.size.height/6)
                        .background(.green)
                        .cornerRadius(20.0)
                        .shadow(radius: 5.0)
                        Button {
                            backToStart()
                        } label: {
                            Text("Home")
                                .foregroundColor(.black)
                                .font(.system(size: isIPad ? 50 : 30))
                        }
                        .frame(width: geo.size.width/5, height: geo.size.height/6)
                        .background(.green)
                        .cornerRadius(20.0)
                        .shadow(radius: 5.0)
                    }
                }
                .frame(width: geo.size.width/2, height: geo.size.height/1.7)
                .padding(.bottom, 20)
                .background {
                    RoundedRectangle(cornerRadius: 20.0)
                        .fill(Color(#colorLiteral(red: 244/255, green: 228/255, blue: 140/255, alpha: 1.0)))
                        .shadow(radius: 20.0)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .ignoresSafeArea()
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView(score: 0, playAgain: {}, backToStart: {})
    }
}
