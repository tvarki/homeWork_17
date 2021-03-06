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
    
    private var state : State = .Default
    
    init(){
        create123()
        create231()
        create312()
    }
    //MARK:- Global Print

    func print123(){
        print("---------------------------")
        /*
        DispatchQueue.global().async {
            self.b?.run()
        }
        DispatchQueue.global().async {
            self.a?.run()
        }
        DispatchQueue.global().async {
            self.c?.run()
        }
        */
        
        
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.print123_1()
        }
        DispatchQueue.global(qos: .utility).async {
            self.print123_2()
        }
        DispatchQueue.global(qos: .background).async {
            self.print123_3()
        }
        
    }
    
    func print231(){
        print("---------------------------")
        /*
        DispatchQueue.global().async {
            self.bb?.run()
        }
        DispatchQueue.global().async {
            self.aa?.run()
        }
        DispatchQueue.global().async {
            self.cc?.run()
        }
 */
        
        DispatchQueue.global(qos: .background).async() {
            self.print231_1()
        }
        DispatchQueue.global(qos: .userInteractive).async() {
            self.print231_2()
        }
        DispatchQueue.global(qos: .utility).async() {
            self.print231_3()
        }
        
    }
    
    func print312(){
        print("---------------------------")
        /*
        DispatchQueue.global().async {
            self.bbb?.run()
        }
        DispatchQueue.global().async {
            self.aaa?.run()
        }
        DispatchQueue.global().async {
            self.ccc?.run()
        }
 */
        DispatchQueue.global(qos: .utility).async {
            self.print312_1()
        }
        DispatchQueue.global(qos: .background).async() {
            self.print312_2()
        }
        DispatchQueue.global(qos: .userInteractive).async() {
            self.print312_3()
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
    
//    
//    private func universalPrint(value: Int, prevState: State, nextState: State ){
//        
//        print("Try to print \(value)")
//
//        switch prevState {
//        case .Default:
//            while(state == .Printed1 || state == .Printed2 || state == .Printed3) {
//                condition.wait()
//            }
//        case .Printed1:
//            while(state == .Printed2 || state == .Default || state == .Printed3) {
//                condition.wait()
//            }
//        case .Printed2:
//            while(state == .Printed1 || state == .Default || state == .Printed3) {
//                condition.wait()
//            }
//        case .Printed3:
//            while(state == .Printed1 || state == .Default || state == .Printed2) {
//                condition.wait()
//            }
//        }
//        
//        condition.lock()
//        print(value)
//        state = .Default
//        condition.signal()
//        condition.unlock()
//    }
//    
    
    
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
        self.cc = MyThread(quality: .utility, name: "3",clousure: print231_3)
    }
    
    //MARK:- create thread for 312
    func create312(){
        self.aaa = MyThread(quality: .utility, name: "1", clousure: print312_1)
        self.bbb = MyThread(quality: .background, name: "2", clousure: print312_2)
        self.ccc = MyThread(quality: .userInteractive, name: "3", clousure: print312_3)
    }
    
    func create_2_123(){
        self.a = MyThread(quality: .userInteractive, name: "1", clousure: print123_1)
        self.b = MyThread(quality: .utility, name: "2", clousure: print123_2)
        self.c = MyThread(quality: .background, name: "3", clousure: print123_3)
    }
}




//MARK:- MyThread class
class MyThread2{
    
    private static var mutex = NSLock()
    private let quality : QualityOfService
    private let thread : Thread
    
    init(quality: QualityOfService, name: String, clousure: @escaping (Int, State, State)->(Void)){
        self.quality = quality
        thread = Thread() {
            clousure(1, .Default, .Printed3)
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


enum State : String{
    case Default
    case Printed1
    case Printed2
    case Printed3
}
