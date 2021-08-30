//
//  UserHeaderViewModel.swift
//  socialApp
//
//  Created by Daryl on 2021/8/16.
//

import UIKit
import Combine

class UserHeaderViewModel: ViewModel<User> {
    let userId: String
    let fullName: String
    let bio: String?
    var profileImageUrl: URL?
    var isFollowing: Bool
    let following: Int
    let followers: Int
    let posts: Int
    var isEditable: Bool = false
    
    @Published var followButtonTitle: String
    @Published var followButtonTitleColour: UIColor
    @Published var followButtonBackgroundColour: UIColor
    @Published var isSubmitAllowed: Bool = true
    
    var subscribers: [AnyCancellable?] = []
    
    required init(model: User, isEditable: Bool) {
        userId = model._id
        fullName = model.fullName
        bio = model.bio
        profileImageUrl = URL(string: model.profileImageUrl ?? "")
        isFollowing = model.isFollowing ?? false
        following = model.following ?? 0
        followers = model.followers ?? 0
        posts = model.posts?.count ?? 0
        self.isEditable = isEditable
        
        if isFollowing == true {
            followButtonTitleColour = .white
            followButtonBackgroundColour = .black
            followButtonTitle = "追蹤中"
        } else {
            followButtonTitleColour = .black
            followButtonBackgroundColour = .white
            followButtonTitle = "追蹤"
        }
        
        super.init(model: model)
    }
    
    func bindFollowEditButtons(followButton: UIButton, editProfileButton: UIButton) {
        subscribers.append($followButtonTitle
                            .receive(on: RunLoop.main)
                            .sink(receiveValue: { followButton.setTitle($0, for: .normal) }))

        subscribers.append($followButtonBackgroundColour
                            .receive(on: RunLoop.main)
                            .map({ return $0 })
                            .assign(to: \.backgroundColor, on: followButton))

        subscribers.append($followButtonTitleColour
                            .receive(on: RunLoop.main)
                            .sink(receiveValue: { followButton.setTitleColor($0, for: .normal)}))
        
        subscribers.append($isSubmitAllowed
                            .assign(to: \.isEnabled, on: followButton))
        
        if isEditable {
            followButton.removeFromSuperview()
        } else {
            editProfileButton.removeFromSuperview()
        }
    }
    
    func didFollowUser() {
        let url = "\(Service.shared.baseUrl)/user/\(isFollowing ? "unfollow" : "follow")/\(userId)"
        
        isSubmitAllowed = false

        Service.shared.followUser(userId: userId, url: url) { result in
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
    
    func editProfile() {
        print("Editting profile...")
    }
    
    required init(model: User) {
        fatalError("init(model:) has not been implemented")
    }
}
