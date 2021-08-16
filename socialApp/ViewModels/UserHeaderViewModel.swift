//
//  UserHeaderViewModel.swift
//  socialApp
//
//  Created by Daryl on 2021/8/16.
//

import Foundation

class UserHeaderViewModel: ViewModel<User> {
    let userId: String
    let fullName: String
    var profileImageUrl: URL?
    var isFollowing: Bool
    var isPublic: Bool = false
    let following: Int
    
    required init(model: User) {
        userId = model._id
        fullName = model.fullName
        profileImageUrl = URL(string: model.profileImageUrl ?? "")
        isFollowing = model.isFollowing ?? false
        following = model.following ?? 0
        
        super.init(model: model)
    }
}
