//
//  Service.swift
//  socialApp
//
//  Created by Daryl on 2021/7/7.
//

import Alamofire

class Service: NSObject {
    
    static let shared = Service()
    
//    let baseUrl = "https://social-app-daryl.herokuapp.com"
    let baseUrl = "http://localhost:5000"
    
    func login(email: String, password: String, completion: @escaping(Result<Data,AFError>) -> ()) {
        let url = "\(baseUrl)/user/login"
        let params = ["email" : email, "password" : password]
        AF.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .response { dataResp in
                if let err = dataResp.error {
                    completion(.failure(err))
                    return
                }
                
                completion(.success(dataResp.data ?? Data()))
            }
    }
    
    func signUp(params: [String:String], completion: @escaping(Result<Data,Error>) -> ()) {
        let url = "\(baseUrl)/user/signup"
        AF.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .response { dataResp in
                if let err = dataResp.error {
                    completion(.failure(err))
                    return
                }
                
                completion(.success(dataResp.data ?? Data()))
            }
    }
    
    func fetchPosts(completion: @escaping(Result<[PostViewModel], Error>) -> ()) {
        let url = "\(Service.shared.baseUrl)/post"
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .response { dataResp in
                if let err = dataResp.error {
                    completion(.failure(err))
                    return
                }
                
                do {
                    let allPosts = try JSONDecoder().decode([Post].self, from: dataResp.data ?? Data())
                    let postViewModels = allPosts.map({ return PostViewModel(model: $0) })
                    
                    completion(.success(postViewModels))
                } catch let err {
                    completion(.failure(err))
                }
                
                
            }
    }
    
    func fetchUserProfile(userId: String, completion: @escaping(Result<User, Error>) -> ()) {
        var url = "\(Service.shared.baseUrl)/user/profile"
        
        if !userId.isEmpty {
            url = "\(url)/\(userId)"
        }
        
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .response { dataResp in
                
                if let err = dataResp.error {
                    completion(.failure(err))
                    return
                }
                
                do {
                    let user = try JSONDecoder().decode(User.self, from: dataResp.data ?? Data())
                    completion(.success(user))
                } catch let err {
                    completion(.failure(err))
                }
                
            }
    }
    
    func updateProfile(viewModel: UserHeaderViewModel, avatar: UIImage?, completion: @escaping(Result<Int,Error>) ->()) {
        let url = "\(Service.shared.baseUrl)/user/profile"
        
        AF.upload(multipartFormData: { formData in
            formData.append(Data(viewModel.fullName.utf8), withName: "fullName")
            formData.append(Data((viewModel.bio ?? "").utf8), withName: "bio")
            
            if let imagefile = avatar?.jpegData(compressionQuality: 0.5) {
                formData.append(imagefile, withName: "imagefile", fileName: "", mimeType: "image/jpg")
            }
            
        }, to: url)
        .response { dataResp in
            if let err = dataResp.error {
                completion(.failure(err))
                return
            }
            completion(.success(1))
        }
    }
    
    func searchForUsers(completion: @escaping(Result<[UserViewModel], Error>)->()) {
        let url = "\(Service.shared.baseUrl)/user/search"
        
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .response { dataResp in
                if let err = dataResp.error {
                    completion(.failure(err))
                    return
                }
                
                do {
                    let users = try JSONDecoder().decode([User].self, from: dataResp.data ?? Data())
                    let userViewModels = users.map({ return UserViewModel(model: $0) })
                    completion(.success(userViewModels))
                } catch let err {
                    completion(.failure(err))
                }
            }
    }
    
    func deletePost(postId id: String, completion: @escaping(Result<Int, Error>) -> ()) {
        let url = "\(Service.shared.baseUrl)/post/\(id)"
        AF.request(url, method: .delete)
            .validate(statusCode: 200..<300)
            .response { dataResp in
                if let err = dataResp.error {
                    completion(.failure(err))
                    return
                }
                
                completion(.success(1))
            }
    }
    
    func followUser(userId id: String, url: String, completion: @escaping(Result<Int, Error>) -> ()) {
        
        AF.request(url, method: .post)
            .validate(statusCode: 200..<300)
            .response { dataResp in
                if let err = dataResp.error {
                    completion(.failure(err))
                    return
                }
                
                completion(.success(1))
            }
    }
    
    func fetchComments(postId: String, completion: @escaping(Result<[Comment], Error>) -> ()) {
        let url = "\(Service.shared.baseUrl)/comment/\(postId)"
        
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .response { dataResp in
                if let err = dataResp.error {
                    completion(.failure(err))
                    return
                }
                
                do {
                    let comments = try JSONDecoder().decode([Comment].self, from: dataResp.data ?? Data())
                    completion(.success(comments))
                } catch let err {
                    completion(.failure(err))
                }
            }
    }
    
    func submitComment(postId: String, comment: String, completion: @escaping(Result<Int, Error>) -> ()) {
        let url = "\(Service.shared.baseUrl)/comment/\(postId)"
        let params = ["text": comment]
        AF.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .response { dataResp in
                if let err = dataResp.error {
                    completion(.failure(err))
                }
                completion(.success(1))
            }
    }
    
    func likePost(postId: String, hasLiked: Bool, completion: @escaping(Result<Int, Error>) -> ()) {
        let url = "\(Service.shared.baseUrl)/like/\(postId)/\(hasLiked ? "dislike" : "like")"
        AF.request(url, method: .post)
            .validate(statusCode: 200..<300)
            .response { dataResp in
                if let err = dataResp.error {
                    completion(.failure(err))
                    return
                }
                
                completion(.success(1))
            }
    }
    
    func fetchLikes(postId: String, completion: @escaping(Result<[User], Error>) -> ()) {
        let url = "\(Service.shared.baseUrl)/post/likes/\(postId)"
        
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .response { dataResp in
                do {
                    
                    let users = try JSONDecoder().decode([User].self, from: dataResp.data ?? Data())
                    completion(.success(users))
                } catch let err {
                    completion(.failure(err))
                }
            }
    }
    
    func fetchUsersBeingFollowing(completion: @escaping(Result<[User],Error>) -> ()) {
        let url = "\(Service.shared.baseUrl)/user/following"
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .response { dataResp in
                if let err = dataResp.error {
                    completion(.failure(err))
                    return
                }
                
                do {
                    let allFollowing = try JSONDecoder().decode([User].self, from: dataResp.data ?? Data())
                    completion(.success(allFollowing))
                } catch let err {
                    completion(.failure(err))
                }
            }
    }
    
    func reportPost(postId: String, postOnwerId: String, completion: @escaping(Result<Int,Error>) -> ()) {
        let url = "\(Service.shared.baseUrl)/report/\(postId)/\(postOnwerId)"
        AF.request(url, method: .post)
            .validate(statusCode: 200..<300)
            .response { dataResp in
                if let err = dataResp.error {
                    completion(.failure(err))
                    return
                }
                
                completion(.success(1))
            }
    }
}
