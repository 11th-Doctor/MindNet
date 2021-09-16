//
//  UserViewModel.swift
//  socialApp
//
//  Created by Daryl on 2021/8/8.
//

import UIKit
import Combine

class UserViewModel: ViewModel<User> {
    
    let userIdToFollow: String
    let fullName: String
    let profileImageUrl: String
    var isFollowing: Bool
    @Published var followButtonTitle: String = ""
    @Published var followButtonTitleColour: UIColor = .black
    @Published var followButtonBackgroundColour: UIColor = .white
    @Published var isSubmitAllowed: Bool = true
    @Published var isCurrentUser: Bool = true
    
    
    var followButtonTitleSubscriber: AnyCancellable?
    var followButtonTitleColourSubscriber: AnyCancellable?
    var followButtonBackgroundColourSubscriber: AnyCancellable?
    var isSubmitAllowedSubsriber: AnyCancellable?
    var isCurrentUserSubscriber: AnyCancellable?
    
    required init(model: User) {
        userIdToFollow = model._id
        fullName = model.fullName
        profileImageUrl = model.profileImageUrl ?? ""
        isFollowing = model.isFollowing ?? false
        isCurrentUser = model.isCurrentUser ?? false
        
        super.init(model: model)
        
        if isFollowing == true {
            followButtonTitleColour = .white
            followButtonBackgroundColour = .black
            followButtonTitle = "追蹤中"
        } else {
            followButtonTitleColour = .black
            followButtonBackgroundColour = .white
            followButtonTitle = "追蹤"
        }
        
    }
    
    func didFollowUser() {
        let url = "\(Service.shared.baseUrl)/user/\(isFollowing ? "unfollow" : "follow")/\(userIdToFollow)"
        
        isSubmitAllowed = false

        Service.shared.followUser(userId: userIdToFollow, url: url) { result in
            switch result {
            case .failure(let err):
                print("Failed to folow the user: ", err)
                break
            case.success(_):

                self.isFollowing = !self.isFollowing

                if self.isFollowing == true {
                    self.followButtonTitleColour = .white
                    self.followButtonBackgroundColour = .black
                    self.followButtonTitle = "追蹤中"
                } else {
                    self.followButtonTitleColour = .black
                    self.followButtonBackgroundColour = .white
                    self.followButtonTitle = "追蹤"
                }
                break
            }
            self.isSubmitAllowed = true
        }
    }
}
