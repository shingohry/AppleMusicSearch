//
//  AlbumViewController.swift
//  AppleMusicSearch
//
//  Created by hiraya.shingo on 2017/09/14.
//  Copyright © 2017年 hiraya.shingo. All rights reserved.
//

import UIKit
import StoreKit
import MediaPlayer

class AlbumViewController: UITableViewController {
    
    let apiClient = APIClient()
    let cloudServiceController = SKCloudServiceController()
    let musicPlayer = MPMusicPlayerController.systemMusicPlayer
    
    var albumID: String!
    var album: Resource?
    
    var canMusicCatalogPlayback = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepare()
    }
}

extension AlbumViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard album != nil else { return 0 }
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let album = album else { return 0 }
        if section == 0 {
            return 1
        } else {
            return album.relationships!.tracks!.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumHeaderCell", for: indexPath) as! AlbumHeaderCell
            cell.nameLabel.text = album!.attributes?.name
            cell.artistLabel.text = album!.attributes?.artistName
            cell.yearLabel.text = album!.attributes?.releaseDate
            if let url = album!.attributes?.artwork?.imageURL(width: 220, height: 220) {
                apiClient.image(url: url) { image in
                    cell.thumbnailView.image = image
                }
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let track = album?.relationships!.tracks![indexPath.row]
        cell.textLabel?.text = track?.attributes?.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard canMusicCatalogPlayback else { return }
        guard indexPath.section == 1 else { return }
        
        let tracks = album!.relationships!.tracks!
        let trackIDs = tracks.map { $0.id! }
        let startTrackID = tracks[indexPath.row].id!
        let descriptor = MPMusicPlayerStoreQueueDescriptor(storeIDs: trackIDs)
        descriptor.startItemID = startTrackID
        musicPlayer.setQueue(with: descriptor)
        musicPlayer.play()
    }
}

extension AlbumViewController {
    
    func prepare() {
        apiClient.album(id: albumID) { [unowned self] album in
            DispatchQueue.main.async {
                self.album = album
                self.tableView.reloadData()
            }
        }
        
        self.cloudServiceController.requestCapabilities { capabilities, error in
            guard capabilities.contains(.musicCatalogPlayback) else { return }
            self.canMusicCatalogPlayback = true
        }
    }
}

class AlbumHeaderCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
}
