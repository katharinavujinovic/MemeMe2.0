//
//  FontProperties.swift
//  MemeMe
//
//  Created by Katharina Müllek on 11.11.20.
//

import Foundation
import UIKit

class FontProperties: NSObject, UITextFieldDelegate {
    
    let textAttributes : [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -5
    ]
    
}
