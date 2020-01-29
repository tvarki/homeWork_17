//
//  ViewController.swift
//  homeWork_17
//
//  Created by Дмитрий Яковлев on 27.01.2020.
//  Copyright © 2020 Дмитрий Яковлев. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var print231Button: UIButton!
    @IBOutlet weak var print123Button: UIButton!
    @IBOutlet weak var print312Button: UIButton!
    
    //MARK:- MyThreads for print info
    
    var main = MainClass()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK:- action for print 123
    
    @IBAction func print123(_ sender: UIButton) {
        sender.isEnabled = false
        print("Print 123")
        self.main.print123()
        
    }
    
    //MARK:- action for print 231
    @IBAction func print231(_ sender: UIButton) {
        sender.isEnabled = false
        print("Print 231")
        self.main.print231()
    }
    
    //MARK:- action for print 312
    @IBAction func print312(_ sender: UIButton) {
        sender.isEnabled = false
        print("Print 312")
        self.main.print312()
    }
    
    //MARK:- action for reload threads
    @IBAction func reload(_ sender: UIButton) {
        
        main.finishAllThread()
        
        main.create123()
        main.create231()
        main.create312()
        
        print123Button.isEnabled = true
        print231Button.isEnabled = true
        print312Button.isEnabled = true
        
    }
    
    
}


//MARK:- MyThread class
class MyThread{
    
    private static var mutex = NSLock()
    private let quality : QualityOfService
    private let thread : Thread
    
    init(quality: QualityOfService, name: String, clousure: @escaping ()->(Void)){
        self.quality = quality
        thread = Thread() {
            clousure()
        }
        thread.name = name
        thread.qualityOfService = quality
    }
    
    func run(){
        thread.start()
    }
    
    func stop(){
        thread.cancel()
    }
}



class MainClass{
    private var a:MyThread?
    private var b:MyThread?
    private var c:MyThread?
    
    private var aa:MyThread?
    private var bb:MyThread?
    private var cc:MyThread?
    
    private var aaa:MyThread?
    private var bbb:MyThread?
    private var ccc:MyThread?
    
    private let condition = NSCondition()
    private var check1: Bool = false
    private var check2: Bool = false
    
    private var state : State = .Default
    
    init(){
        create123()
        create231()
        create312()
    }
    //MARK:- Global Print

    func print123(){
        print("---------------------------")
        DispatchQueue.global().async {
            self.b?.run()
            self.a?.run()
            self.c?.run()

        }
    }
    
    func print231(){
        print("---------------------------")
        DispatchQueue.global().async {
            self.bb?.run()
            self.aa?.run()
            self.cc?.run()
        }
    }
    
    func print312(){
        print("---------------------------")
        DispatchQueue.global().async {
            self.bbb?.run()
            self.aaa?.run()
            self.ccc?.run()
        }
    }
    
    func finishAllThread(){
        self.a?.stop()
        self.aa?.stop()
        self.aaa?.stop()
        self.b?.stop()
        self.bb?.stop()
        self.bbb?.stop()
        self.c?.stop()
        self.cc?.stop()
        self.ccc?.stop()
    }
    
    //MARK:- Print character functions for all thread

    private func print123_1(){
        print("Try to print 1")
        condition.lock()
        while(state == .Printed1 || state == .Printed2 || state == .Printed3) {
            condition.wait()
        }
        print(1)
        state = .Printed1
        condition.signal()
        condition.unlock()
        
        
    }
    
    private func print123_2(){
        print("Try to print 2")
        condition.lock()
        while(state == .Default || state == .Printed2 || state == .Printed3) {
            condition.wait()
        }
        print(2)
        state = .Printed2
        condition.signal()
        condition.unlock()
        
    }
    
    private func print123_3(){
        print("Try to print 3")
        condition.lock()
        while(state == .Printed1 || state == .Default || state == .Printed3) {
            condition.wait()
        }
        print(3)
        state = .Default
        condition.signal()
        condition.unlock()
    }
    
    
    
    private func print231_1(){
        print("Try to print 1")
        condition.lock()
        while(state == .Printed1 || state == .Default || state == .Printed2) {
            condition.wait()
        }
        print(1)
        state = .Default
        condition.signal()
        condition.unlock()
    }
    
   private func print231_2(){
        print("Try to print 2")
        condition.lock()
        while(state == .Printed1 || state == .Printed2 || state == .Printed3) {
            condition.wait()
        }
        print(2)
        state = .Printed2
        condition.signal()
        condition.unlock()
    }
    
    private func print231_3(){
        print("Try to print 3")
        condition.lock()
        while(state == .Default || state == .Printed1 || state == .Printed3) {
            condition.wait()
        }
        print(3)
        state = .Printed3
        condition.signal()
        condition.unlock()
    }
    
    private func print312_1(){
        print("Try to print 1")

        condition.lock()
        while(state == .Printed1 || state == .Default || state == .Printed2) {
            condition.wait()
        }
        print(1)
        state = .Printed1
        condition.signal()
        condition.unlock()
    }
    
    private func print312_2(){
        print("Try to print 2")
        condition.lock()
        while(state == .Default || state == .Printed2 || state == .Printed3) {
            condition.wait()
        }
        print(2)
        state = .Default
        condition.signal()
        condition.unlock()
    }
    
    private func print312_3(){
        print("Try to print 3")
        condition.lock()
        while(state == .Printed2 || state == .Printed1 || state == .Printed3) {
            condition.wait()
        }
        print(3)
        state = .Printed3
        condition.signal()
        condition.unlock()
    }
    
    
    //MARK:- create threads for 123
    func create123(){
        self.a = MyThread(quality: .userInteractive, name: "1", clousure: print123_1)
        self.b = MyThread(quality: .utility, name: "2", clousure: print123_2)
        self.c = MyThread(quality: .background, name: "3", clousure: print123_3)
    }
    
    //MARK:- create threads for 231
    func create231(){
        self.aa = MyThread(quality: .background, name: "1",clousure: print231_1)
        self.bb = MyThread(quality: .userInteractive, name: "2", clousure: print231_2)
        self.cc = MyThread(quality: .utility, name: "3", clousure: print231_3)
    }
    
    //MARK:- create thread for 312
    func create312(){
        self.aaa = MyThread(quality: .utility, name: "1", clousure: print312_1)
        self.bbb = MyThread(quality: .background, name: "2", clousure: print312_2)
        self.ccc = MyThread(quality: .userInteractive, name: "3", clousure: print312_3)
    }
    
}


enum State : String{
    case Default
    case Printed1
    case Printed2
    case Printed3
}
