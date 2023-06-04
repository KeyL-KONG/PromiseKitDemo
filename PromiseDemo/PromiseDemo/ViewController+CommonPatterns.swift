//
//  ViewController+CommonPatterns.swift
//  PromiseDemo
//
//  Created by KeyL on 2023/1/31.
//

import Foundation
import PromiseKit

struct User {
    let imageUrl: URL
    init(dict: [String: Any]) {
        self.imageUrl = URL(string: dict["imageurl"] as? String ?? "")!
    }
}

struct Foo {
    
}

struct Bar {
    
}

class MyRestAPI {
    func user() -> Promise<User> {
        return firstly {
            URLSession.shared.dataTask(.promise, with: URL(string: "")!)
        }.compactMap {
            try JSONSerialization.jsonObject(with: $0.data) as? [String: Any]
        }.map { dict in
            User(dict: dict)
        }
    }
    
    func avatar() -> Promise<UIImage> {
        return user().then { user in
            URLSession.shared.dataTask(.promise, with: user.imageUrl)
        }.compactMap {
            UIImage(data: $0.data)
        }
    }
    
    func avatar2() -> Promise<UIImage> {
        let bgq = DispatchQueue.global(qos: .userInitiated)
        return firstly {
            user()
        }.then(on: bgq) { user in
            URLSession.shared.dataTask(.promise, with: user.imageUrl)
        }.compactMap {
            UIImage(data: $0.data)
        }
    }
    
    func foo() -> Promise<Foo> {
        return Promise { resolver in
            resolver.resolve(.fulfilled(Foo()))
            //resolver.fulfill(Foo())
        }
    }
    
    func bar(_ baz: Foo) -> Promise<Bar> {
        return Promise { resolver in
            resolver.fulfill(Bar())
        }
    }
    
    func doOtherThings() throws {
        
    }
    
    func failingChains() {
        firstly {
            foo()
        }.then { baz in
            self.bar(baz)
        }.then { result in
            try doOtherThings()
        }.catch { error in
            // if doOtherThing() throws, we end up here
        }
    }
}

extension ViewController {
    
    func chainingSequences() {
        var fade = Guarantee<Bool>()
        for cell in self.view.subviews {
            fade = fade.then ({
                UIView.animate(.promise, duration: 0.1) {
                    cell.alpha = 0
                }
            })
        }
        fade.done {
            //finish
        }
    }
    
    func chainingSequences2() {
        var foo = Promise<Void>()
        let arrayOfClosureThatReturnPromises: [() -> Promise<Void>] = []
        for nextPromise in arrayOfClosureThatReturnPromises {
            foo = foo.then(nextPromise)
        }
        foo.done {
            // finish
        }
    }
    
    func makeFetches() -> [Promise<Bool>] {
        return []
    }
    
    func timeout() {
        let fetches: [Promise<Bool>] = makeFetches()
        let timeout = after(seconds: 4)
        race(when(fulfilled: fetches).asVoid(), timeout).then {
            
        }
    }
    
    func foo() -> (Promise<Void>, cancel: () -> Void) {
        let task = Task {
            
        }
        var cancelme = false
        
        let promise = Promise<Void> { seal in
            
        }
        let cancel = {
            cancelme = true
            task.cancel()
        }
        return (promise, cancel)
    }
    
    func attempt<T>(maximumRetryCount: Int = 3, delayBeforeRetry: DispatchTimeInterval = .seconds(2), _ body: @escaping () -> Promise<T>) -> Promise<T> {
        var attempts = 0
        func attempt() -> Promise<T> {
            attempts += 1
            return body().recover { error -> Promise<T> in
                guard attempts < maximumRetryCount else { throw error }
                return after(delayBeforeRetry).then(attempt)
            }
        }
        return attempt()
    }
    
    func makeFoo() -> Promise<Foo> {
        return Promise { resolver in
            resolver.resolve(.fulfilled(Foo()))
        }
    }
    
    func attemptExample() {
        attempt(maximumRetryCount: 3) {
            self.makeFoo()
        }.then({ foo in
            
        }).catch { error in
            // we attempted three times but still failed
        }
    }
    
    func delegateExample() {
        CLLocationManager.promise().then { locations in
            
        }.catch { error in
            
        }
    }
    
    func saveExample() {
        login().then { creds in
            self.fetch(avatar: creds.user).done { image in
                
            }
        }.done {
            
        }
        
        login().then { creds in
            fetch(avatar: creds.user).map { ($0, creds) }
        }.then { image, creds in
            
        }
    }
    
    func whenExample() {
        when(resolved: login()).done { result in
            
        }
    }
}

extension CLLocationManager {
    static func promise() -> Promise<[CLLocation]> {
        return PMKCLLocationManagerProxy().promise
    }
}

class PMKCLLocationManagerProxy: NSObject, CLLocationManagerDelegate {
    
    let (promise, seal) = Promise<[CLLocation]>.pending()
    private var retainCycle: PMKCLLocationManagerProxy?
    private let manager = CLLocationManager()
    
    override init() {
        super.init()
        retainCycle = self
        manager.delegate = self
        
        _ = promise.ensure {
            self.retainCycle = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        seal.fulfill(locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        seal.reject(error)
    }
}
