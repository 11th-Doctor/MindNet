//
//  LikeViewModel.swift
//  socialApp
//
//  Created by Daryl on 2021/8/24.
//

import Foundation

class LikeViewModel: ViewModel<User> {
    
    var profileImageUrl: URL?
    let fullName: String
    
    required init(model: User) {
        profileImageUrl = URL(string: model.profileImageUrl ?? "")
        fullName = model.fullName
        super.init(model: model)
    }
}
