//
//  MySwift.swift
//  iSH
//
//  Created by pcl on 10/26/22.
//

import Foundation

@objc class MySwift: NSObject {
    
    @objc static func boot1() {
        //        print("Print line System")
        NSLog("com.gg.mysh.log: %@", "printSome()")
        
        let fakefs_ptr = UnsafeMutablePointer<fs_ops>.allocate(capacity: 1)
        fakefs_ptr.pointee = fakefs
        
        var root = Roots.instance().rootUrl(Roots.instance().defaultRoot)
        
        mount_root(fakefs_ptr, (root.appendingPathComponent("data") as NSURL).fileSystemRepresentation);
        
        become_first_process()
        
        let fd_ptr = UnsafeMutablePointer<fd>.allocate(capacity: 1)
        generic_mknodat(fd_ptr, "/dev/tty1", S_IFCHR|0666, dev_make(TTY_CONSOLE_MAJOR, 1))
        generic_mknodat(fd_ptr, "/dev/tty2", S_IFCHR|0666, dev_make(TTY_CONSOLE_MAJOR, 2))
        generic_mknodat(fd_ptr, "/dev/tty3", S_IFCHR|0666, dev_make(TTY_CONSOLE_MAJOR, 3))
        generic_mknodat(fd_ptr, "/dev/tty4", S_IFCHR|0666, dev_make(TTY_CONSOLE_MAJOR, 4))
        generic_mknodat(fd_ptr, "/dev/tty5", S_IFCHR|0666, dev_make(TTY_CONSOLE_MAJOR, 5))
        generic_mknodat(fd_ptr, "/dev/tty6", S_IFCHR|0666, dev_make(TTY_CONSOLE_MAJOR, 6))
        generic_mknodat(fd_ptr, "/dev/tty7", S_IFCHR|0666, dev_make(TTY_CONSOLE_MAJOR, 7))
        generic_mknodat(fd_ptr, "/dev/tty", S_IFCHR|0666, dev_make(TTY_ALTERNATE_MAJOR, DEV_TTY_MINOR))
        generic_mknodat(fd_ptr, "/dev/console", S_IFCHR|0666, dev_make(TTY_ALTERNATE_MAJOR, DEV_CONSOLE_MINOR))
        generic_mknodat(fd_ptr, "/dev/ptmx", S_IFCHR|0666, dev_make(TTY_ALTERNATE_MAJOR, DEV_PTMX_MINOR))
        generic_mknodat(fd_ptr, "/dev/null", S_IFCHR|0666, dev_make(MEM_MAJOR, DEV_NULL_MINOR))
        generic_mknodat(fd_ptr, "/dev/zero", S_IFCHR|0666, dev_make(MEM_MAJOR, DEV_ZERO_MINOR))
        generic_mknodat(fd_ptr, "/dev/full", S_IFCHR|0666, dev_make(MEM_MAJOR, DEV_FULL_MINOR))
        generic_mknodat(fd_ptr, "/dev/random", S_IFCHR|0666, dev_make(MEM_MAJOR, DEV_RANDOM_MINOR))
        generic_mknodat(fd_ptr, "/dev/urandom", S_IFCHR|0666, dev_make(MEM_MAJOR, DEV_URANDOM_MINOR))
        generic_mkdirat(fd_ptr, "/dev/pts", 0755);
        
        // Permissions on / have been broken for a while, let's fix them
        generic_setattrat(fd_ptr, "/", attr(type: attr_mode, attr.__Unnamed_union___Anonymous_field1(mode: 0755)), false)
        dyn_dev_register(&location_dev, DEV_CHAR, DYN_DEV_MAJOR, DEV_LOCATION_MINOR);
        generic_mknodat(fd_ptr, "/dev/location", S_IFCHR|0666, dev_make(DYN_DEV_MAJOR, DEV_LOCATION_MINOR));
        
        let procfs_ptr = UnsafeMutablePointer<fs_ops>.allocate(capacity: 1)
        procfs_ptr.pointee = procfs
        do_mount(procfs_ptr, "proc", "/proc", "", 0);
        let devptsfs_ptr = UnsafeMutablePointer<fs_ops>.allocate(capacity: 1)
        devptsfs_ptr.pointee = devptsfs
        do_mount(devptsfs_ptr, "devpts", "/dev/pts", "", 0);
        
        //        let ptr = UnsafeMutablePointer<tty_driver>.allocate(capacity: 1)
        //        ptr.initialize(to: ios_console_driver)
        //        tty_drivers.4 = ptr
    }
    
    @objc static func boot2() {
        let tty_driver_ptr = UnsafeMutablePointer<tty_driver>.allocate(capacity: 1)
        tty_driver_ptr.initialize(to: ios_console_driver)
        tty_drivers.4 = tty_driver_ptr
        
        set_console_device(TTY_CONSOLE_MAJOR, 1)
        create_stdio("/dev/console", TTY_CONSOLE_MAJOR, 1)
        do_execve("/bin/login", 3, "/bin/login\0-f\0root\0", "TERM=xterm-256color\0")
        task_start(current)
    }
    
    @objc static func get_root() -> UnsafePointer<CChar>{
        var root = Roots.instance().rootUrl(Roots.instance().defaultRoot)
        return (root.appendingPathComponent("data") as NSURL).fileSystemRepresentation
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
