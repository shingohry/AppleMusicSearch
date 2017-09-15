//
//  Relationships.swift
//  AppleMusicSearch
//
//  Created by hiraya.shingo on 2017/09/14.
//  Copyright © 2017年 hiraya.shingo. All rights reserved.
//

import Foundation

struct Relationships: Codable {
    
    let tracks: [Resource]?
    
    enum RelationshipsKeys: String, CodingKey {
        case tracks
    }
    
    enum TracksKeys: String, CodingKey {
        case data
    }
    
    init(tracks: [Resource]?) {
        self.tracks = tracks
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: RelationshipsKeys.self)
        let tracks = try values.nestedContainer(keyedBy: TracksKeys.self,
                                                forKey: .tracks)
        let data = try tracks.decode([Resource].self,
                                     forKey: .data)
        self.init(tracks: data)
    }
}
