//
//  APIClient.swift
//  AppleMusicSearch
//
//  Created by hiraya.shingo on 2017/09/12.
//  Copyright © 2017年 hiraya.shingo. All rights reserved.
//

import UIKit

enum ResponseError: Error {
    case invalidResponse(URLResponse?)
    case unacceptableStatusCode(Int)
}

class APIClient {
    
    static let imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.name = "APIClientImage"
        cache.countLimit = 20
        cache.totalCostLimit = 10 * 1024 * 1024
        return cache
    }()
    
    static let developerToken = "Enter Developer Token"
    static let countryCode = "jp"
    
    func search(term: String, completion: @escaping (SearchResult?) -> Swift.Void) {
        let completionOnMain: (SearchResult?) -> Void = { searchResult in
            DispatchQueue.main.async {
                completion(searchResult)
            }
        }
        
        guard var components = URLComponents(string: "https://api.music.apple.com/v1/catalog/\(APIClient.countryCode)/search") else { return }
        let expectedTerms = term.replacingOccurrences(of: " ", with: "+")
        let urlParameters = ["term": expectedTerms,
                             "limit": "10",
                             "types": "albums"]
        var queryItems = [URLQueryItem]()
        for (key, value) in urlParameters {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        components.queryItems = queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.addValue("Bearer \(APIClient.developerToken)",
            forHTTPHeaderField: "Authorization")
        
        data(with: request) { data, error -> Void in
            guard error == nil else {
                print(#function, "URL Session Task Failed", error!)
                completionOnMain(nil)
                return
            }
            
            guard let searchResult = try? JSONDecoder().decode(SearchResult.self, from: data!) else {
                print(#function, "JSON Decode Failed");
                completionOnMain(nil)
                return
            }
            completionOnMain(searchResult)
        }
    }
    
    func album(id: String, completion: @escaping (Resource?) -> Swift.Void) {
        let completionOnMain: (Resource?) -> Void = { resource in
            DispatchQueue.main.async {
                completion(resource)
            }
        }
        
        guard let url = URL(string: "https://api.music.apple.com/v1/catalog/\(APIClient.countryCode)/albums/\(id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(APIClient.developerToken)",
            forHTTPHeaderField: "Authorization")
        
        data(with: request) { data, error -> Void in
            guard error == nil else {
                print(#function, "URL Session Task Failed", error!)
                completionOnMain(nil)
                return
            }
            
            guard let jsonData = try? JSONSerialization.jsonObject(with: data!),
                let dictionary = jsonData as? [String: Any],
                let dataArray = dictionary["data"] as? [[String: Any]],
                let albumDictionary = dataArray.first,
                let albumData = try? JSONSerialization.data(withJSONObject: albumDictionary),
                let album = try? JSONDecoder().decode(Resource.self, from: albumData) else {
                    print(#function, "JSON Decode Failed");
                    completionOnMain(nil)
                    return
            }
            completionOnMain(album)
        }
    }
    
    func image(url: URL, completion: @escaping ((UIImage?) -> Void)) {
        let completionOnMain: (UIImage?) -> Void = { image in
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        if let image = APIClient.imageCache.object(forKey: url.absoluteString as NSString) {
            print(#function, "image is Cacheed");
            completion(image)
            return
        }
        
        data(with: URLRequest(url: url)) { data, error -> Void in
            guard error == nil else {
                print(#function, "URL Session Task Failed", error!)
                completionOnMain(nil)
                return
            }
            
            if let image = UIImage(data: data!) {
                APIClient.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                completionOnMain(image)
            } else {
                print(#function, "image convert Failed");
                completionOnMain(nil)
            }
        }
    }
}

extension APIClient {
    func data(with request: URLRequest, completion: @escaping (Data?, Error?) -> Swift.Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error -> Void in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, ResponseError.invalidResponse(response))
                return
            }
            
            guard (200..<300).contains(httpResponse.statusCode) else {
                completion(nil, ResponseError.unacceptableStatusCode(httpResponse.statusCode))
                return
            }
            
            completion(data, nil)
        }
        task.resume()
    }
}
