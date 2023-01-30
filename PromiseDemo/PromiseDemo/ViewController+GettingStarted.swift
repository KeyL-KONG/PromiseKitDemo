//
//  ViewController+GettingStarted.swift
//  PromiseDemo
//
//  Created by KeyL on 2023/1/30.
//  https://github.com/mxcl/PromiseKit/blob/v6/Documentation/GettingStarted.md

import Foundation
import PromiseKit

struct Creds {
    let user: String
}

extension ViewController {
    
    func login(completion: (Creds?, Error?) -> Void) {
        
    }
    
    func fetch(avatar: String, completion: (UIImage?, Error?) -> Void) {
        
    }
    
    func login() -> Promise<Creds> {
        return Promise { resolver in
            resolver.fulfill(Creds(user: "https://lc-AosRamJS.cn-n1.lcfile.com/2a8MKW0O4uvk33n8lL8oRkf7XGbLqMPA/0bcbea56f6794765b571d18b3b3f2fd4"))
        }
    }
    
    func fetch(avatar: String) -> Promise<UIImage> {
        return URLSession.shared.dataTask(.promise, with: URL(string: avatar)!).compactMap { UIImage(data: $0.data)}
//        return Promise { resolver in
//             } {
//                resolver.fulfill(image)
//            } else {
//                resolver.reject(NSError.init(domain: "can't find image", code: -1))
//            }
//        }
    }
    
    func updateImage() {
        login { creds, error in
            if let creds = creds {
                fetch(avatar: creds.user) { [weak self] image, error in
                    if let image = image {
                        self?.imageView.image = image
                    }
                }
            }
        }
    }
    
    func updateImage2() {
        firstly {
            login()
        }.then { creds in
            self.fetch(avatar: creds.user)
        }.done { image in
            self.imageView.image = image
        }.ensure {
            print("call ensure")
        }
        .done {
            print("call done")
        }
        .catch { error in
            print(error)
        }.finally {
            print("call finally")
        }
    }

}

//MARK: when
extension ViewController {
    
    func operation1(completion: (String) -> Void) {
        
    }
    
    func operation2(completion: (String) -> Void) {
        
    }
    
    func operation1() -> Promise<String> {
        return Promise { resolver in
            resolver.fulfill("operation1")
        }
    }
    
    func operation2() -> Promise<String> {
        return Promise { resolver in
            resolver.fulfill("operation2")
        }
    }
    
    func makeOperation() {
        var result1: String!
        var result2: String!
        let group = DispatchGroup()
        group.enter()
        operation1 { result in
            result1 = result
            group.leave()
        }
        group.enter()
        operation2 { result in
            result2 = result
            group.leave()
        }
        
        group.notify(queue: .main) {
            let result = result1 + result2
            print(result)
        }
    }
    
    func makeOperation2() {
        firstly {
            when(fulfilled: self.operation1(), self.operation2())
        }.done { result1, result2 in
            let result = result1 + result2
            print(result)
        }
    }
    
}

//MAKR: Guarantee
extension ViewController {
    
    func fetch2(completion: (String) -> Void) {
        
    }
    
    func fetch2() -> Guarantee<String> {
        return Guarantee { seal in
            fetch2 { result in
                seal(result)
            }
        }
    }
    
    func doGuarantee() {
        firstly {
            after(seconds: 0.1)
        }.done {
            
        }
    }
    
    func doGuarantee2() {
        firstly {
            fetch2()
        }.done { result in
            print(result)
        } // no catch
    }
    
}

//MARK: map
extension ViewController {
    
    func doMap() {
        firstly {
            URLSession.shared.dataTask(.promise, with: URL(string: "")!)
        }.map {
            try JSONSerialization.jsonObject(with: $0.data) as? [String]
        }.done { arrayofString in
            if let arrayofString = arrayofString { // return optional value
                
            }
        }.catch { error in
            
        }
    }
    
    func doCompactMap() {
        firstly {
            URLSession.shared.dataTask(.promise, with: URL(string: "")!)
        }.compactMap {
            try JSONSerialization.jsonObject(with: $0.data) as? [String]
        }.done { arrayOfStrings in 
            
        }.catch { error in
            
        }
    }
    
}
