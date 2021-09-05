//
//  FollowingViewModel.swift
//  socialApp
//
//  Created by Daryl on 2021/8/31.
//

import RxSwift
import RxCocoa

struct FollowingViewModel {
    var items = PublishSubject<[User]>()
    
    func fetchFollowing() {
        Service.shared.fetchUsersBeingFollowing { result in
            switch result {
            case .failure(let err):
                print("Failed to fetch following", err)
                break
            case.success(let allFollowing):
                items.onNext(allFollowing)
//                items.onCompleted()
                break
            }
        }
    }
}
