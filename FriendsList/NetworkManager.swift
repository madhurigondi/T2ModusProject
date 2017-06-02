//
//  NetworkManager.swift
//  FriendsList
//
//  Created by Madhuri on 31/5/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {
    
    class func fetchAllFriends(completion: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        
        let apiUrl: String = "https://private-c1b9f-t2mobile.apiary-mock.com/friends"
        guard let url = URL(string: apiUrl) else {
            completion(nil, NSError(domain: "Error url", code: 400, userInfo: ["error_message": "Url is not valid"]))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            guard let _ = error, data != nil else {
                
                do {
                    
                    if let usersDictArray = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? Array<NSDictionary> {
                        
                        var users = [User]()

                        for userDictionary in usersDictArray {
                            
                            if let id = userDictionary.object(forKey: "id") as? Int {
                                let user = User(id: id)
                                user.firstName = userDictionary.object(forKey: "first_name") as? String
                                user.lastName = userDictionary.object(forKey: "last_name") as? String
                                user.currentStatus = userDictionary.object(forKey: "status") as? String
                                user.profilePicUrl = userDictionary.object(forKey: "img") as? String
                                if let isAvailable = userDictionary.object(forKey: "available") as? Bool {
                                    user.isAvailable = isAvailable
                                }
                                
                                users.append(user)
                            }
                        }
                        
                        completion(users, nil)
                    }
                    
                } catch {
                    completion(nil, error)
                }
                
                return
            }
            completion(nil, error)
        })
        task.resume()
    }
    
    class func fetchUserDetails(user: User, completion: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        
        let apiUrl: String = "https://private-c1b9f-t2mobile.apiary-mock.com/friends/\(user.id)"
        guard let url = URL(string: apiUrl) else {
            completion(nil, NSError(domain: "Error url", code: 400, userInfo: ["error_message": "Url is not valid"]))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            guard let _ = error, data != nil else {
                
                do {
                    if let userDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary {
                        
                        user.firstName = userDictionary.object(forKey: "first_name") as? String
                        user.lastName = userDictionary.object(forKey: "last_name") as? String
                        user.street = userDictionary.object(forKey: "address_1") as? String
                        user.city = userDictionary.object(forKey: "city") as? String
                        user.state = userDictionary.object(forKey: "state") as? String
                        user.zipCode = userDictionary.object(forKey: "zipcode") as? String
                        user.phoneNumber = userDictionary.object(forKey: "phone") as? String
                        user.bio = userDictionary.object(forKey: "bio") as? String
                        if let isAvailable = userDictionary.object(forKey: "available") as? Bool {
                            user.isAvailable = isAvailable
                        }
                        if let photosArray = userDictionary.object(forKey: "photos") as? [String] {
                            user.photoUrls = photosArray
                        }
                        if let statusArray = userDictionary.object(forKey: "statuses") as? [String] {
                            user.statuses = statusArray
                        }
                        
                        completion(user, nil)
                    }
                    
                } catch {
                    completion(nil, error)
                }
                
                return
            }
            completion(nil, error)
        })
        task.resume()
    }
    
    class func downloadedImageForURL(url: URL, completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200, let data = data, error == nil, let image = UIImage(data: data)
                else { return }
            completion(image, error)
            }.resume()
    }
}
