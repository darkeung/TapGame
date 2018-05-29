//
//  Helper.swift
//  Tap Game
//
//  Created by NG CHUN KEUNG on 18/5/18.
//  Copyright © 2018 NG CHUN KEUNG. All rights reserved.
//

import Foundation
import UIKit

struct ColliderType {
    static let CAR_COLLIDER : UInt32 = 0
    
    static let ITEM_COLLIDER : UInt32 = 1
    static let ITEM_COLLIDER_1 : UInt32 = 2
}

class Helper : NSObject {
    
    func randomBetweenTwoNumbers(firstNumber : CGFloat ,  secondNumber : CGFloat) -> CGFloat{
        return CGFloat(arc4random())/CGFloat(UINT32_MAX) * abs(firstNumber - secondNumber) + min(firstNumber, secondNumber)
    }
}

class Settings {
    static let sharedInstance = Settings()
    
    private init(){
        
    }
    
    var highScore = 0
}


