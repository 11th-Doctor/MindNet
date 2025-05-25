//
//  socialAppTests.swift
//  socialAppTests
//
//  Created by Daryl on 2021/7/4.
//

import XCTest
@testable import socialApp

class socialAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPostViewModel() {
        let user = User(_id: "_id", fullName: "full Name", bio: nil, emailAddress: "dummy@gmail.com", profileImageUrl: nil, posts: nil, isFollowing: false, isCurrentUser: true
                        , following: 0, followers: 0)
        
        let post = Post(_id: "_id", text: "the text of the post", createdAt: "2021-08-19T14:26:02.297+00:00", updatedAt: "2021-08-19T14:26:02.297+00:00", imageUrl: "https://social-app-11th-dr.s3.us-west-1.amazonaws.com/f8b19c2f-3502-46fd-ad5a-d3b8e78f38ec", hasLiked: false, numLikes: 0, numComments: 0, user: user, fromNow: "2天前", canDelete: true)
        
        let postViewModel = PostViewModel(model: post)
        
        XCTAssertEqual(postViewModel.likeButtonImage, #imageLiteral(resourceName: "like-outline"))
        XCTAssertEqual(postViewModel.canDelete, postViewModel.model.user.isCurrentUser)
        XCTAssertGreaterThanOrEqual(postViewModel.numLikes, 0)
        XCTAssertEqual(postViewModel.fromNow, postViewModel.model.fromNow)
    }
    
    func testPostViewModelPostLiked() {
        let user = User(_id: "_id", fullName: "full Name", bio: nil, emailAddress: "dummy@gmail.com", profileImageUrl: nil, posts: nil, isFollowing: false, isCurrentUser: false
                        , following: 0, followers: 0)
        
        let post = Post(_id: "_id", text: "the text of the post", createdAt: "2021-08-19T14:26:02.297+00:00", updatedAt: "2021-08-19T14:26:02.297+00:00", imageUrl: "https://social-app-11th-dr.s3.us-west-1.amazonaws.com/f8b19c2f-3502-46fd-ad5a-d3b8e78f38ec", hasLiked: true, numLikes: 0, numComments: 0, user: user, fromNow: "2天前", canDelete: false)
        
        let postViewModel = PostViewModel(model: post)
        
        XCTAssertEqual(postViewModel.likeButtonImage, #imageLiteral(resourceName: "like-filled"))
        XCTAssertEqual(postViewModel.canDelete, postViewModel.model.user.isCurrentUser)
        XCTAssertGreaterThanOrEqual(postViewModel.numLikes, 0)
        XCTAssertEqual(postViewModel.fromNow, postViewModel.model.fromNow)
    }

    func testUserViewModel() {
        let user = User(_id: "_id", fullName: "full Name", bio: nil, emailAddress: "dummy@gmail.com", profileImageUrl: nil, posts: nil, isFollowing: false, isCurrentUser: false
                        , following: 1, followers: 0)
        let userViewModel = UserViewModel(model: user)
        
        XCTAssertEqual(userViewModel.isFollowing, false)
        XCTAssertEqual(userViewModel.followButtonTitleColour, .black)
        XCTAssertEqual(userViewModel.followButtonBackgroundColour, .white)
        XCTAssertEqual(userViewModel.followButtonTitle, "追蹤")
    }
    
    func testUserViewModelFollowing() {
        let user = User(_id: "_id", fullName: "full Name", bio: nil, emailAddress: "dummy@gmail.com", profileImageUrl: nil, posts: nil, isFollowing: true, isCurrentUser: false
                        , following: 1, followers: 0)
        let userViewModel = UserViewModel(model: user)
        
        XCTAssertEqual(userViewModel.isFollowing, true)
        XCTAssertEqual(userViewModel.followButtonTitleColour, .white)
        XCTAssertEqual(userViewModel.followButtonBackgroundColour, .black)
        XCTAssertEqual(userViewModel.followButtonTitle, "追蹤中")
    }
    
    func testUserHeaderViewModel() {
        let user = User(_id: "_id", fullName: "full Name", bio: nil, emailAddress: "dummy@gmail.com", profileImageUrl: nil, posts: nil, isFollowing: false, isCurrentUser: true
                        , following: 1, followers: 0)
        
        let userHeaderViewModel = UserHeaderViewModel(model: user, isEditable: true)
        
        XCTAssertEqual(userHeaderViewModel.model.isCurrentUser, userHeaderViewModel.isEditable)
        XCTAssertTrue(userHeaderViewModel.isEditable)
        XCTAssertFalse(userHeaderViewModel.isFollowing)
        XCTAssertTrue((userHeaderViewModel.model.isCurrentUser != nil))
    }
    
    func testUserHeaderViewModelFollow() {
        let user = User(_id: "_id", fullName: "full Name", bio: nil, emailAddress: "dummy@gmail.com", profileImageUrl: nil, posts: nil, isFollowing: false, isCurrentUser: false
                        , following: 1, followers: 0)
        
        let userHeaderViewModel = UserHeaderViewModel(model: user, isEditable: false)
        
        XCTAssertEqual(userHeaderViewModel.model.isCurrentUser, userHeaderViewModel.isEditable)
        XCTAssertFalse(userHeaderViewModel.isEditable)
        XCTAssertFalse(userHeaderViewModel.isFollowing)
        XCTAssertFalse((userHeaderViewModel.model.isCurrentUser ?? false))
        XCTAssertEqual(userHeaderViewModel.followButtonTitleColour, .black)
        XCTAssertEqual(userHeaderViewModel.followButtonBackgroundColour, .white)
        XCTAssertEqual(userHeaderViewModel.followButtonTitle, "追蹤")
    }
    
    func testUserHeaderViewModelFollowing() {
        let user = User(_id: "_id", fullName: "full Name", bio: nil, emailAddress: "dummy@gmail.com", profileImageUrl: nil, posts: nil, isFollowing: true, isCurrentUser: false
                        , following: 1, followers: 0)
        
        let userHeaderViewModel = UserHeaderViewModel(model: user, isEditable: false)
        
        XCTAssertEqual(userHeaderViewModel.model.isCurrentUser, userHeaderViewModel.isEditable)
        XCTAssertFalse(userHeaderViewModel.isEditable)
        XCTAssertTrue(userHeaderViewModel.isFollowing)
        XCTAssertFalse((userHeaderViewModel.model.isCurrentUser ?? false))
        XCTAssertEqual(userHeaderViewModel.followButtonTitleColour, .white)
        XCTAssertEqual(userHeaderViewModel.followButtonBackgroundColour, .black)
        XCTAssertEqual(userHeaderViewModel.followButtonTitle, "追蹤中")
    }
}
