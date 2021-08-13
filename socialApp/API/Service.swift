//
//  Service.swift
//  socialApp
//
//  Created by Daryl on 2021/7/7.
//

import Alamofire

class Service: NSObject {
    
    static let shared = Service()
    
    let baseUrl = "http://localhost:3000"
    
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
                    let postViewModels = allPosts.map({ return PostViewModel(post: $0) })
                    completion(.success(postViewModels))
                } catch let err {
                    completion(.failure(err))
                }
                
                
            }
    }
    
    func fetchUserProfile(completion: @escaping(Result<User, Error>) -> ()) {
        let url = "\(Service.shared.baseUrl)/user/profile"
        
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
    
    func updateProfile(user: User, avatar: UIImage?, completion: @escaping(Result<Int,Error>) ->()) {
        let url = "\(Service.shared.baseUrl)/user/profile"
        
        AF.upload(multipartFormData: { formData in
            formData.append(Data(user.fullName.utf8), withName: "fullName")
            
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
                    let userViewModels = users.map({ return UserViewModel(user: $0) })
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
}
