//
//  CommentViewModel.swift
//  socialApp
//
//  Created by Daryl on 2021/8/21.
//

import Foundation

class CommentViewModel: ViewModel<Comment> {
    
    let profileImageUrl: URL?
    let fullName: String
    let fromNow: String
    let text: String
    
    required init(model: Comment) {
        profileImageUrl = URL(string: model.user?.profileImageUrl ?? "")
        fullName = model.user?.fullName ?? ""
        fromNow = model.fromNow ?? ""
        text = model.text ?? ""
        super.init(model: model)
    }
}
