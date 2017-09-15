//
//  Artwork.swift
//  AppleMusicSearch
//
//  Created by hiraya.shingo on 2017/09/12.
//  Copyright © 2017年 hiraya.shingo. All rights reserved.
//

import Foundation

/// An object that represents an artwork.
struct Artwork: Codable {
    
    // https://developer.apple.com/library/content/documentation/NetworkingInternetWeb/Conceptual/AppleMusicWebServicesReference/Artwork.html#//apple_ref/doc/uid/TP40017625-CH26-SW1
    
    /// The maximum width available for the image.
    let width: Int?
    
    /// The maximum height available for the image.
    let height: Int?
    
    /// The URL to request the image asset. The image file name must be preceded by {w}x{h}, as placeholders for the width and height values described above (for example, {w}x{h}bb.jpg).
    /// for example, /600x600bb.jpg
    let url: String?
    
    /// The average background color of the image.
    let bgColor: String?
    
    /// The primary text color that may be used if the background color is displayed.
    let textColor1: String?
    
    /// The secondary text color that may be used if the background color is displayed.
    let textColor2: String?
    
    /// The tertiary text color that may be used if the background color is displayed.
    let textColor3: String?
    
    /// The final post-tertiary text color that maybe be used if the background color is displayed.
    let textColor4: String?
}

extension Artwork {
    
    func imageURL(width: Int, height: Int) -> URL? {
        guard let url = url else { return nil }
        print("Artwork URL:", url)
        let replaced = url.replacingOccurrences(of: "{w}", with: "\(width)").replacingOccurrences(of: "{h}", with: "\(height)")
        print("replaced:", replaced)
        return URL(string: replaced)
    }
}
