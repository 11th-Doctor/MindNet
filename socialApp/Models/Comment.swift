//
//  Comment.swift
//  socialApp
//
//  Created by Daryl on 2021/8/21.
//

import Foundation

struct Comment: Decodable {
    var text: String?
    var user: User?
    var fromNow: String?
}
