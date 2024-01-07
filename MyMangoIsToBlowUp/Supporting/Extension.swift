//
//  Extension.swift
//  MyMangoIsToBlowUp
//
//  Created by Cipher Lunis on 1/6/24.
//

import Foundation
import SpriteKit

extension SKSpriteNode {
    func aspectFillToSize(fillSize: CGSize) {
        if texture != nil {
            self.size = texture!.size()
            
            let verticalRatio = fillSize.height / self.texture!.size().height
            let horizontalRatio = fillSize.width / self.texture!.size().width
            
            let scaleRatio = horizontalRatio > verticalRatio ? horizontalRatio : verticalRatio
            
            self.setScale(scaleRatio)
        }
    }
}

extension SKLabelNode {
    func applyStrokedAttributes(text: String, strokeWidth: CGFloat, strokeColor: UIColor, fillColor: UIColor, fontName: String, fontSize: CGFloat) {
        let attributedStringParagraphStyle = NSMutableParagraphStyle()
        attributedStringParagraphStyle.alignment = .center
        attributedStringParagraphStyle.lineSpacing = 10
        
        let attributedString = NSAttributedString(
        string: text,
        attributes: [
            NSAttributedString.Key.paragraphStyle : attributedStringParagraphStyle,
            NSAttributedString.Key.strokeWidth : strokeWidth,
            NSAttributedString.Key.strokeColor : strokeColor,
            NSAttributedString.Key.foregroundColor : fillColor,
            NSAttributedString.Key.font : UIFont(name: fontName, size: fontSize)!
        ])
        
        self.attributedText = attributedString
    }
}
