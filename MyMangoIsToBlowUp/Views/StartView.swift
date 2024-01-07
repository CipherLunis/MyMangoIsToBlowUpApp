//
//  StartView.swift
//  MyMangoIsToBlowUp
//
//  Created by Cipher Lunis on 1/6/24.
//

import SwiftUI

struct StartView: View {
    let isIPad = UIDevice.current.userInterfaceIdiom == .pad
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                Image("MangoFarmBG")
                    .resizable()
                    .ignoresSafeArea()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width)
                VStack {
                    Spacer()
                    HStack {
                        Image("Chomp1")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geo.size.width/4)
                            .rotationEffect(Angle(degrees: -25))
                        Spacer()
                        Image("Chomp1")
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
                        // START GAME
                    }
                    .padding(.bottom)
                }
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
