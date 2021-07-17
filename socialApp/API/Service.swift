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
    
    func fetchPosts(completion: @escaping(Result<[Post], Error>) -> ()) {
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
                    completion(.success(allPosts))
                } catch let err {
                    completion(.failure(err))
                }
                
                
            }
    }
}
