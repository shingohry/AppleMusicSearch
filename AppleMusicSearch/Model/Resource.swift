//
//  Resource.swift
//  AppleMusicSearch
//
//  Created by hiraya.shingo on 2017/09/12.
//  Copyright © 2017年 hiraya.shingo. All rights reserved.
//

import Foundation

struct Resource: Codable {
    
    /// Persistent identifier of the resource. This member is required.
    let id: String?
    
    /// The type of resource. This member is required.
    let type: String?
    
    /// Attributes belonging to the resource (can be a subset of the attributes). The members are the names of the attributes defined in the object model.
    let attributes: Attributes?
    
    /// A URL subpath that fetches the resource as the primary object. This member is only present in responses.
    let href: String?
    
    /// The URL for the next page.
    let next: String?
    
    /// Relationships belonging to the resource.
    let relationships: Relationships?
}
