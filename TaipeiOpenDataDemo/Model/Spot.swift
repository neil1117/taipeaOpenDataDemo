//
//  Spot.swift
//  TaipeiOpenDataDemo
//
//  Created by Neil Wu on 2018/7/22.
//  Copyright © 2018年 Neil Wu. All rights reserved.
//

import Foundation

struct Spot {
    
    var name: String
    var describetion: String
    var photos: [String]
    
    
    init() {
        self.name = "333333"
        self.describetion = ""
        self.photos = []
    }
    
    init(name: String, describetion: String, photos: [String]) {
        self.name = name
        self.describetion = describetion
        self.photos = photos
    }
}
