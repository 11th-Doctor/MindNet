//
//  Post.swift
//  socialApp
//
//  Created by Daryl on 2021/7/11.
//

import Foundation

struct Post: Codable {
    let _id: String
    let text: String
    let createdAt: String
    let updatedAt: String
    let imageUrl: String
    let numLikes: Int
    let user: User
}
