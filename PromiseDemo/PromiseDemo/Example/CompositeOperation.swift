//
//  CompositeOperation.swift
//  PromiseDemo
//
//  Created by keyl on 2023/6/4.
//

import Foundation
import PromiseKit

extension ViewController {
    
    func compositeOperation() {
        
        whenOperation()
        raceOperation()
    }
    
}

private extension ViewController {
    
    func whenOperation() {
        let promise1 = Promise { seal in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                seal.fulfill("Result 1")
            }
        }
        
        let promise2 = Promise { seal in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                seal.fulfill("Result 2")
            }
        }
        
        let promise3 = Promise { seal in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                seal.fulfill("Result 3")
            }
        }
        
        when(fulfilled: [promise1, promise2, promise3]).done { results in
            print(results)
        }.catch { error in
            print(error)
        }
        
    }
    
    func raceOperation() {
        let promise1 = Promise { seal in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                seal.fulfill("Result 1")
            }
        }
        
        let promise2 = Promise { seal in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                seal.fulfill("Result 2")
            }
        }
        
        let promise3 = Promise { seal in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                seal.fulfill("Result 3")
            }
        }
        
        race(promise1, promise2, promise3).done { result in
            print(result)
        }.catch { error in
            print(error)
        }
    }
    
}
