//
//  StartView.swift
//  MyMangoIsToBlowUp
//
//  Created by Cipher Lunis on 1/6/24.
//

import SwiftUI

struct StartView: View {
    let isIPad = UIDevice.current.userInterfaceIdiom == .pad
    
    @State var didStartGame = false
    
    var body: some View {
        ZStack {
            if !didStartGame {
                GeometryReader { geo in
                    Image(K.Images.MangoFarmBG)
                        .resizable()
                        .ignoresSafeArea()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: geo.size.width, maxHeight: geo.size.height, alignment: .topLeading)
                    VStack {
                        Spacer()
                        HStack {
                            Image(K.Images.Chomp1)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geo.size.width/4)
                                .rotationEffect(Angle(degrees: -25))
                            Spacer()
                            Image(K.Images.Chomp1)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geo.size.width/4)
                                .rotationEffect(Angle(degrees: 25))
                        }
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        HStack {
                            Text("My Mango Is To Blow Up!")
                                .font(.system(size: isIPad ? 80 : 60))
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: geo.size.width/2)
                                .background(.green)
                                .cornerRadius(20)
                            
                        }
                        Spacer()
                    }
                    .padding(.top, 20)
                    VStack {
                        Spacer()
                        StartScreenButton(text: "Start!", width: geo.size.width/3.5, height: geo.size.height/6, isIPad: isIPad) {
                            didStartGame = true
                        }
                        .padding(.bottom)
                    }
                }
            } else {
                GameView()
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.35)))
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
