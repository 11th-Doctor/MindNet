//
//  Post.swift
//  socialApp
//
//  Created by Daryl on 2021/7/11.
//

import Foundation

struct Post: Decodable {
    let _id: String
    let text: String
    let createdAt: String
    let updatedAt: String
    let imageUrl: String
    var hasLiked: Bool?
    var isSensitive: Bool?
    let numLikes: Int
    let user: User
    let fromNow: String
    var canDelete:Bool
}
