//
//  MySwift.swift
//  iSH
//
//  Created by pcl on 10/26/22.
//

import Foundation

@objc class MySwift: NSObject {
    
    @objc static func boot2() {
        let tty_driver_ptr = UnsafeMutablePointer<tty_driver>.allocate(capacity: 1)
        tty_driver_ptr.initialize(to: ios_console_driver)
        tty_drivers.4 = tty_driver_ptr
        
        set_console_device(TTY_CONSOLE_MAJOR, 1)
        create_stdio("/dev/console", TTY_CONSOLE_MAJOR, 1)
        do_execve("/bin/login", 3, "/bin/login\0-f\0root\0", "TERM=xterm-256color\0")
        task_start(current)
    }
        
    @objc static func get_fd() -> UnsafeMutablePointer<fd> {
        return UnsafeMutablePointer<fd>.allocate(capacity: 1)
    }
    
    @objc static func get_fakefs() -> UnsafeMutablePointer<fs_ops> {
        let fakefs_ptr = UnsafeMutablePointer<fs_ops>.allocate(capacity: 1)
        fakefs_ptr.pointee = fakefs
        return fakefs_ptr
    }
}
