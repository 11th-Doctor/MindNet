//
//  PostViewModel.swift
//  socialApp
//
//  Created by Daryl on 2021/8/8.
//

import Foundation

class ViewModel<T: Decodable>: ObservableObject {
    var model: T!
    
    required init(model: T) {
        self.model = model
    }
}
