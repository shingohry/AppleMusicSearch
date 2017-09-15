//
//  TopViewController.swift
//  AppleMusicSearch
//
//  Created by hiraya.shingo on 2017/09/14.
//  Copyright © 2017年 hiraya.shingo. All rights reserved.
//

import UIKit
import StoreKit

class TopViewController: UITableViewController {

    let apiClient = APIClient()
    
    var albums: [Resource]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepare()
    }
}

extension TopViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text,
            text.count > 0 {
            apiClient.search(term: text) { [unowned self] searchResult in
                DispatchQueue.main.async {
                    self.albums = searchResult?.albums
                    self.tableView.reloadData()
                }
            }
        } else {
            self.albums = nil
            tableView.reloadData()
        }
    }
}

extension TopViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let albums = albums else { return 0 }
        return albums.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let album = albums![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = album.attributes?.name
        cell.detailTextLabel?.text = album.attributes?.artistName
        cell.imageView?.image = nil
        
        if let url = album.attributes?.artwork?.imageURL(width: 100, height: 100) {
            apiClient.image(url: url) { image in
                cell.imageView?.image = image
                cell.setNeedsLayout()
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let album = albums![indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "AlbumViewController") as! AlbumViewController
        vc.albumID = album.id
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension TopViewController {
    
    func prepare() {
        title = "Search"
        tableView.tableFooterView = UIView()
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.dimsBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        
        SKCloudServiceController.requestAuthorization { status in
            guard status == .authorized else { return }
            print("Authorization status is authorized")
        }
    }
}
