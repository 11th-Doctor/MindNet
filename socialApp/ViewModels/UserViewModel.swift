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
    @Published var followButtonTitle: String
    @Published var followButtonTitleColour: UIColor
    @Published var followButtonBackgroundColour: UIColor
    @Published var isSubmitAllowed: Bool = true
    
    private var subscribers: [AnyCancellable?] = []
    
    required init(model: User) {
        userIdToFollow = model._id
        fullName = model.fullName
        profileImageUrl = model.profileImageUrl ?? ""
        isFollowing = model.isFollowing ?? false
        
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
    
    func bindFollowButton(followButton: UIButton) {
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
    }
    
    func didFollowUser() {
        let url = "\(Service.shared.baseUrl)/user/\(isFollowing ? "unfollow" : "follow")/\(userIdToFollow)"
        
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
        }
    }
}
