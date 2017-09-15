//
//  Result.swift
//  AppleMusicSearch
//
//  Created by hiraya.shingo on 2017/09/14.
//  Copyright © 2017年 hiraya.shingo. All rights reserved.
//

import Foundation

struct SearchResult: Codable {
    
	let albums: [Resource]?
    
    enum RootKeys: String, CodingKey {
        case results
    }

    enum ResultsKeys: String, CodingKey {
        case albums
    }

    enum AlbumsKeys: String, CodingKey {
        case data
    }

    init(albums: [Resource]?) {
        self.albums = albums
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: RootKeys.self)
        let results = try values.nestedContainer(keyedBy: ResultsKeys.self,
                                                 forKey: .results)
        let albums = try? results.nestedContainer(keyedBy: AlbumsKeys.self,
                                                  forKey: .albums)
        let data = try albums?.decode([Resource].self,
                                      forKey: .data)
        self.init(albums: data)
    }
}
