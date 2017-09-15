//
//  EditorialNotes.swift
//  AppleMusicSearch
//
//  Created by hiraya.shingo on 2017/09/12.
//  Copyright © 2017年 hiraya.shingo. All rights reserved.
//

import Foundation

/// An object that represents notes.
struct EditorialNotes: Codable {
    
    // https://developer.apple.com/library/content/documentation/NetworkingInternetWeb/Conceptual/AppleMusicWebServicesReference/EditorialNotes.html#//apple_ref/doc/uid/TP40017625-CH28-SW1
    
    /// Notes shown when the content is being prominently displayed.
    let standard: String?
    
    /// Abbreviated notes shown in-line or when the content is shown alongside other content.
    let short: String?
}
