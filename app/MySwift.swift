//
//  MySwift.swift
//  iSH
//
//  Created by pcl on 10/26/22.
//

import Foundation

@objc class MySwift: NSObject {

    @objc static func printSome() {
//        print("Print line System")
        NSLog("com.gg.mysh.log: %@", "printSome()")
        
        var root = Roots.instance().rootUrl(Roots.instance().defaultRoot)
        
        var gg = fakefs
        mount_root(&gg, (root.appendingPathComponent("data") as NSURL).fileSystemRepresentation)

//        become_first_process()
        
//        let ptr = UnsafeMutablePointer<tty_driver>.allocate(capacity: 1)
//        ptr.initialize(to: ios_console_driver)
//        tty_drivers.4 = ptr
    }
    
    @objc static func get_root() -> UnsafePointer<CChar>{
        var root = Roots.instance().rootUrl(Roots.instance().defaultRoot)
        return (root.appendingPathComponent("data") as NSURL).fileSystemRepresentation
    }
    
}
