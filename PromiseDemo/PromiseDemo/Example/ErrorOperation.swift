//
//  ErrorOperation.swift
//  PromiseDemo
//
//  Created by ByteDance on 2023/6/4.
//

import Foundation
import PromiseKit

extension ViewController {
    
    enum MyError: Error {
        case someError
    }
    
    func errorOperation() {
        
        let promise = Promise<String> { seal in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                seal.reject(MyError.someError)
            }
        }
        
        promise.recover { error in
            return Promise.value("Recovered Result")
        }.done { result in
            print(result)
        }.catch { error in
            print(error)
        }
    }
    
}
