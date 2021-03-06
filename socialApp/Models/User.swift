//
//  User.swift
//  socialApp
//
//  Created by Daryl on 2021/7/17.
//

import Foundation

struct User: Decodable {
    let _id: String
    let fullName: String
    let bio: String?
    let emailAddress: String
    let profileImageUrl: String?
    var posts: [Post]?
    var isFollowing: Bool?
    var isCurrentUser: Bool?
    var following: Int?
    var followers: Int?
}
