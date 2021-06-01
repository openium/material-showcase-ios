//
//  MaterialShowCaseSequence.swift
//  MaterialShowcase
//
//  Created by VB on 16.04.2019.
//  Copyright © 2019 Aromajoin. All rights reserved.
//

import Foundation

public class MaterialShowcaseSequence {
    
    public typealias ShowCaseCompletionHandler = (()-> Void)
    
    var showcaseArray : [(showCase: MaterialShowcase, handler: ShowCaseCompletionHandler?)] = []
    var currentCase : Int = 0
    var key : String?
    var completionHandler: ShowCaseCompletionHandler? = nil
    public var hasShadow: Bool = true

    public init() { }
    
    public func temp(_ showcase: MaterialShowcase, completion handler: ShowCaseCompletionHandler? = nil) -> MaterialShowcaseSequence {
        showcaseArray.append((showcase, handler))
        return self
    }
    
    public func start(completion handler: ShowCaseCompletionHandler? = nil) {
        guard !getUserState(key: self.key) else {
            handler?()
            return
        }
        
        completionHandler = handler
        
        if let showCase = showcaseArray.first?.showCase {
            let handler = showcaseArray.first?.handler
            
            showCase.show(hasShadow: hasShadow, completion: { [weak self] in
                self?.increase()
                handler?()
            })

        }
    }
    func increase() -> Void {
        self.currentCase += 1
    }
    
    /// Set user show retry
    public func setKey(key : String? = nil) -> MaterialShowcaseSequence {
        guard key != nil else {
            return self
        }
        self.key = key
        return self
    }
    
    /// Remove user state
    public func removeUserState(key : String = MaterialKey._default.rawValue) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    /// Remove user state
    func getUserState(key : String?) -> Bool {
        guard key != nil else {
            return false
        }
        return UserDefaults.standard.bool(forKey: key!)
    }
    
    public func showCaseDidDismiss() {
        guard self.showcaseArray.count > currentCase else {
            completionHandler?()
            
            //last index
            guard self.key != nil else {
                return
            }
            UserDefaults.standard.set(true, forKey: key!)
            completionHandler?()
            return
        }
        let showCase = showcaseArray[currentCase].showCase
        let handler = showcaseArray[currentCase].handler
        
        showCase.show(hasShadow: hasShadow, completion: { [weak self] in
            self?.increase()
            handler?()
        })
    }
}
