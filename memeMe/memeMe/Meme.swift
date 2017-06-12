//
//  Meme.swift
//  memeMe
//
//  Created by Qichao Wang on 2017/6/12.
//  Copyright © 2017年 Qichao Wang. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var topText: String!
    var botText: String!
    var originalImage: UIImage!
    var memedImage: UIImage!
    
    init(top: String, bot: String, original: UIImage, memed: UIImage) {
        
        topText = top
        botText = bot
        originalImage = original
        memedImage = memed
    }
}

