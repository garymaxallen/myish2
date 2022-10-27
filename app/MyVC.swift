//
//  MyVC.swift
//  iSH
//
//  Created by pcl on 10/10/22.
//

import UIKit

class MyVC: UIViewController {
    var terminalView = TerminalView()
    var terminal = Terminal()
    var sessionPid = Int()
    var controlKey = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("com.gg.mysh.log: %@", "viewDidLoad()")
        // Do any additional setup after loading the view.
//        self.view.backgroundColor = UIColor.systemBlue
        setKeyboard()
        boot()
        startSession()
    }
    
    func setKeyboard() {
        let escapeKey = UIButton(type: UIButton.ButtonType.system)
        escapeKey.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        escapeKey.setTitle("ESC", for: UIControl.State.normal)
        escapeKey.setTitleColor(UIColor.black, for: UIControl.State.normal)
        escapeKey.backgroundColor = UIColor.white
        escapeKey.addTarget(self, action: #selector(pressEscape), for: UIControl.Event.touchUpInside)
        
        let tabKey = UIButton(type: UIButton.ButtonType.system)
        tabKey.frame = CGRect(x: 40, y: 0, width: 40, height: 40)
        tabKey.setTitle("TAB", for: UIControl.State.normal)
        tabKey.setTitleColor(UIColor.black, for: UIControl.State.normal)
        tabKey.backgroundColor = UIColor.white
        tabKey.addTarget(self, action: #selector(pressTab), for: UIControl.Event.touchUpInside)
        
        controlKey = UIButton(type: UIButton.ButtonType.system)
        controlKey.frame = CGRect(x: 80, y: 0, width: 40, height: 40)
        controlKey.setTitle("CTRL", for: UIControl.State.normal)
        controlKey.setTitleColor(UIColor.black, for: UIControl.State.normal)
        controlKey.backgroundColor = UIColor.white
        controlKey.addTarget(self, action: #selector(pressControl), for: UIControl.Event.touchUpInside)
        
        let leftButton = UIButton(type: UIButton.ButtonType.system)
        leftButton.frame = CGRect(x: 120, y: 0, width: 40, height: 40)
        leftButton.setTitle("←", for: UIControl.State.normal)
        leftButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        leftButton.backgroundColor = UIColor.white
        leftButton.addTarget(self, action: #selector(pressLeft), for: UIControl.Event.touchUpInside)
        
        let rightButton = UIButton(type: UIButton.ButtonType.system)
        rightButton.frame = CGRect(x: 160, y: 0, width: 40, height: 40)
        rightButton.setTitle("→", for: UIControl.State.normal)
        rightButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        rightButton.backgroundColor = UIColor.white
        rightButton.addTarget(self, action: #selector(pressRight), for: UIControl.Event.touchUpInside)
        
        let upButton = UIButton(type: UIButton.ButtonType.system)
        upButton.frame = CGRect(x: 200, y: 0, width: 40, height: 40)
        upButton.setTitle("↑", for: UIControl.State.normal)
        upButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        upButton.backgroundColor = UIColor.white
        upButton.addTarget(self, action: #selector(pressUp), for: UIControl.Event.touchUpInside)
        
        let downButton = UIButton(type: UIButton.ButtonType.system)
        downButton.frame = CGRect(x: 240, y: 0, width: 40, height: 40)
        downButton.setTitle("↓", for: UIControl.State.normal)
        downButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        downButton.backgroundColor = UIColor.white
        downButton.addTarget(self, action: #selector(pressDown), for: UIControl.Event.touchUpInside)
        
        let pasteButton = UIButton(type: UIButton.ButtonType.system)
        pasteButton.frame = CGRect(x: 280, y: 0, width: 40, height: 40)
        pasteButton.setTitle("P", for: UIControl.State.normal)
        pasteButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        pasteButton.backgroundColor = UIColor.white
        pasteButton.addTarget(self, action: #selector(pressPaste), for: UIControl.Event.touchUpInside)
        
        let hideKeyboardButton = UIButton(type: UIButton.ButtonType.system)
        hideKeyboardButton.frame = CGRect(x: 320, y: 0, width: 40, height: 40)
        hideKeyboardButton.setTitle("⌨", for: UIControl.State.normal)
        hideKeyboardButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        hideKeyboardButton.backgroundColor = UIColor.white
        hideKeyboardButton.addTarget(self, action: #selector(pressHideKeyboard), for: UIControl.Event.touchUpInside)
        
        let kbView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 40))
        kbView.backgroundColor = UIColor.white
        kbView.addSubview(escapeKey)
        kbView.addSubview(tabKey)
        kbView.addSubview(controlKey)
        kbView.addSubview(leftButton)
        kbView.addSubview(rightButton)
        kbView.addSubview(upButton)
        kbView.addSubview(downButton)
        kbView.addSubview(pasteButton)
        kbView.addSubview(hideKeyboardButton)
        
        terminalView = TerminalView(frame: UIScreen.main.bounds)
        terminalView.inputAccessoryView = kbView
        terminalView.canBecomeFirstResponder = true;
        self.view.addSubview(terminalView)
    }
    
    @objc func pressEscape() {
        terminalView.insertText("\u{1b}")
    }
    
    @objc func pressHideKeyboard() {
        terminalView.resignFirstResponder()
    }
    
    
    @objc func pressTab() {
        terminalView.insertText("\u{09}")
    }
    
    @objc func pressControl() {
        controlKey.isSelected = !controlKey.isSelected
        terminalView.isControlSelected = !terminalView.isControlSelected
        terminalView.isControlHighlighted = !terminalView.isControlHighlighted
    }
    
    @objc func pressLeft() {
        terminalView.insertText(terminal.arrow(CChar("D")!))
    }
    
    @objc func pressRight() {
        terminalView.insertText(terminal.arrow(CChar("C")!))
    }
    
    @objc func pressUp() {
        terminalView.insertText(terminal.arrow(CChar("A")!))
    }
    
    @objc func pressDown() {
        terminalView.insertText(terminal.arrow(CChar("B")!))
    }
    
    @objc func pressPaste() {
        let str = UIPasteboard.general.string
        if (str != nil) {
            terminalView.insertText(str!)
        }
    }
    
    func startSession(){
        become_new_init_child()
        
        let tty = UnsafeMutablePointer<UnsafeMutablePointer<tty>?>.allocate(capacity: 1)
        tty.initialize(to: UnsafeMutablePointer<tty>.allocate(capacity: 1))
        
        terminalView.terminal = Terminal.createPseudoTerminal(tty)
        
        let stdioFile = "/dev/pts/\(String(describing: tty.pointee?.pointee.num))"
        
        create_stdio((stdioFile as NSString?)?.fileSystemRepresentation, TTY_PSEUDO_SLAVE_MAJOR, (tty.pointee?.pointee.num)!)
        tty_release(tty.pointee)
        
        do_execve("/bin/login", 3, "/bin/login\0-f\0root\0", "TERM=xterm-256color\0")
        task_start(current)
    }
    
    func boot() {
        NSLog("com.gg.mysh.log: %@", "boot()")
        
        let fakefs_ptr = UnsafeMutablePointer<fs_ops>.allocate(capacity: 1)
        fakefs_ptr.pointee = fakefs
        
//        NSLog("com.gg.mysh.log: Roots.instance().defaultRoot: %@", Roots.instance().defaultRoot)
//        var root = Roots.instance().rootUrl("default")
        var root = MyUtility.get_root()
        mount_root(fakefs_ptr, (root.appendingPathComponent("data") as NSURL).fileSystemRepresentation)
        
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
        dyn_dev_register(&location_dev, DEV_CHAR, DYN_DEV_MAJOR, DEV_LOCATION_MINOR)
        generic_mknodat(fd_ptr, "/dev/location", S_IFCHR|0666, dev_make(DYN_DEV_MAJOR, DEV_LOCATION_MINOR))
        
        let procfs_ptr = UnsafeMutablePointer<fs_ops>.allocate(capacity: 1)
        procfs_ptr.pointee = procfs
        do_mount(procfs_ptr, "proc", "/proc", "", 0)
        let devptsfs_ptr = UnsafeMutablePointer<fs_ops>.allocate(capacity: 1)
        devptsfs_ptr.pointee = devptsfs
        do_mount(devptsfs_ptr, "devpts", "/dev/pts", "", 0);
        
        let tty_driver_ptr = UnsafeMutablePointer<tty_driver>.allocate(capacity: 1)
        tty_driver_ptr.initialize(to: ios_console_driver)
        tty_drivers.4 = tty_driver_ptr
        
        set_console_device(TTY_CONSOLE_MAJOR, 1)
        create_stdio("/dev/console", TTY_CONSOLE_MAJOR, 1)
        do_execve("/bin/login", 3, "/bin/login\0-f\0root\0", "TERM=xterm-256color\0")
        task_start(current)
    }
    
}
