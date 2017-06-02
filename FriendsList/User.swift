//
//  User.swift
//  FriendsList
//
//  Created by Madhuri on 31/5/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var id: Int
    var firstName: String?
    var lastName: String?
    var profilePicUrl: String?
    var profileImage: UIImage?
    var phoneNumber: String?
    var street: String?
    var city: String?
    var state: String?
    var zipCode: String?
    var bio: String?
    var currentStatus: String?
    var photoUrls: [String?]?
    var statuses: [String?]?
    var isAvailable: Bool = false
    
    init(id: Int) {
        self.id = id
    }
}
