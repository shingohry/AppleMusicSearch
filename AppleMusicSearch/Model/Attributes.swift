//
//  Attributes.swift
//  AppleMusicSearch
//
//  Created by hiraya.shingo on 2017/09/12.
//  Copyright © 2017年 hiraya.shingo. All rights reserved.
//

import Foundation

struct Attributes: Codable {
    
    // MARK: - common
    
    /// artwork.
    let artwork: Artwork?
    
    /// The localized name.
    let name: String?
    
    /// The URL for sharing a resource in the iTunes Store.
    let url: String?
    
    /// (Optional) The notes about the resource that appear in the iTunes Store.
    let editorialNotes: EditorialNotes?
    
    /// (Optional) The parameters to use to playback.
    let playParams: PlayParameters?
    
    /// The artist’s name.
    let artistName: String?
    
    /// The names of the genres associated with.
    let genreNames: [String]?
    
    /// The release date in YYYY-MM-DD format.
    let releaseDate: String?
    
    /// (Optional) The RIAA rating of the content. The possible values for this rating are clean and explicit. No value means no rating.
    let contentRating: String?
    
    // MARK: - for album
    
    /// Indicates whether the album is complete. If true, the album is complete; otherwise, it is not. An album is complete if it contains all its tracks and songs.
    let isComplete: Bool?
    
    /// Indicates whether the album contains a single song.
    let isSingle: Bool?
    
    /// The number of tracks.
    let trackCount: Int?
    
    /// The copyright text.
    let copyright: String?
    
    // MARK: - for song
    
    /// The disc number the song appears on.
    let discNumber: Int?
    
    /// The number of the song in the album’s track list.
    let trackNumber: Int?
    
    /// (Optional) The song’s composer.
    let composerName: String?
    
    /// (Optional) The duration of the song in milliseconds.
    let durationInMillis: Int?
    
    /// (Optional, classical music only) The movement count of this song.
    let movementCount: Int?
    
    /// (Optional, classical music only) The movement name of this song.
    let movementName: String?
    
    /// (Optional, classical music only) The movement number of this song.
    let movementNumber: Int?
    
    /// (Optional, classical music only) The name of the associated work.
    let workName: String?
}
