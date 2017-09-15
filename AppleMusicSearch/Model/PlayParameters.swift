//
//  PlayParameters.swift
//  AppleMusicSearch
//
//  Created by hiraya.shingo on 2017/09/12.
//  Copyright © 2017年 hiraya.shingo. All rights reserved.
//

import Foundation

/// An object that represents play parameters for resources.
struct PlayParameters: Codable {
    
    // https://developer.apple.com/library/content/documentation/NetworkingInternetWeb/Conceptual/AppleMusicWebServicesReference/PlayParameters.html#//apple_ref/doc/uid/TP40017625-CH88-SW1
    
    /// The ID of the content to use for playback.
    let id: String?
    
    /// The kind of the content to use for playback.
    let kind: String?
}
