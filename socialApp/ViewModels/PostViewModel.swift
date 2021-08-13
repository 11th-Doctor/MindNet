//
//  PostViewModel.swift
//  socialApp
//
//  Created by Daryl on 2021/8/8.
//

import Foundation

class PostViewModel: ViewModel<Post> {
    
    let id: String
    let profileImageUrl: String
    let fullName: String
    let fromNow: String
    let text: String
    let imageUrl: String
    
    init(post: Post) {
        id = post._id
        profileImageUrl = post.user.profileImageUrl ?? ""
        fullName = post.user.fullName
        fromNow = post.fromNow
        text = post.text
        imageUrl = post.imageUrl
    }
}
