//
//  Observable.swift
//  GoTripIOS
//
//  Created by Hlib Sobolevskyi on 10.09.2023.
//

import Foundation

@objc
public protocol ObservingProtocol: AnyObject {
    
}

@objc
public protocol ObservableProtocol: AnyObject {
    @objc optional func addListener(_ listener: ObservingProtocol)
    @objc optional func removeListener(_ listener: ObservingProtocol)
}

@objc
public class Observable: NSObject, ObservableProtocol {
    private var listeners: NSHashTable<AnyObject>
    
    public override init() {
        self.listeners = NSHashTable<AnyObject>.weakObjects()
        super.init()
    }
    
    public func addListener(_ listener: ObservingProtocol) {
        self.listeners.add(listener)
    }
    
    public func removeListener(_ listener: ObservingProtocol) {
        self.listeners.remove(listener)
    }
    
    public func notifyListeners(with selector: Selector) {
        self.listeners.allObjects.forEach { obj in
            if obj.responds(to: selector) {
                let _ = obj.perform(selector, with: self)
            }
        }
    }
}
