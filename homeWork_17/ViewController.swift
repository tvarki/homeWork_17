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
    
    var a:MyThread?
    var b:MyThread?
    var c:MyThread?
    
    var aa:MyThread?
    var bb:MyThread?
    var cc:MyThread?
    
    var aaa:MyThread?
    var bbb:MyThread?
    var ccc:MyThread?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        create123()
        create231()
        create312()
    }
    
    //MARK:- action for print 123
    
    @IBAction func print123(_ sender: UIButton) {
        sender.isEnabled = false
        print("Print 123")
        DispatchQueue.global().async {
            self.a?.run()
            self.b?.run()
            self.c?.run()
            
            sleep(1)
            //            print("free")
            self.a?.stop()
            self.b?.stop()
            self.c?.stop()
        }
        
    }
    
    //MARK:- action for print 231
    @IBAction func print231(_ sender: UIButton) {
        sender.isEnabled = false
        print("Print 231")
        DispatchQueue.global().async {
            self.aa?.run()
            self.bb?.run()
            self.cc?.run()
            
            sleep(1)
            //            print("free")
            self.aa?.stop()
            self.bb?.stop()
            self.cc?.stop()
        }
    }
    
    //MARK:- action for print 312
    @IBAction func print312(_ sender: UIButton) {
        sender.isEnabled = false
        print("Print 312")
        DispatchQueue.global().async {
            self.aaa?.run()
            self.bbb?.run()
            self.ccc?.run()
            
            sleep(1)
            //            print("free")
            self.aaa?.stop()
            self.bbb?.stop()
            self.ccc?.stop()
        }
    }
    
    //MARK:- action for reload threads
    @IBAction func reload(_ sender: UIButton) {
        
        create123()
        print123Button.isEnabled = true
        
        create231()
        print231Button.isEnabled = true
        
        create312()
        print312Button.isEnabled = true
        
    }
    
    //MARK:- create threads for 123
    func create123(){
        self.a = MyThread(quality: .userInteractive, name: "1")
        self.b = MyThread(quality: .utility, name: "2")
        self.c = MyThread(quality: .background, name: "3")
    }
    
    //MARK:- create threads for 231
    func create231(){
        self.aa = MyThread(quality: .background, name: "1")
        self.bb = MyThread(quality: .userInteractive, name: "2")
        self.cc = MyThread(quality: .utility, name: "3")
    }
    
    //MARK:- create thread for 312
    func create312(){
        self.aaa = MyThread(quality: .utility, name: "1")
        self.bbb = MyThread(quality: .background, name: "2")
        self.ccc = MyThread(quality: .userInteractive, name: "3")
    }
}
    //MARK:- MyThread class
class MyThread{
    private let quality : QualityOfService
    private let thread : Thread
    
    init(quality: QualityOfService, name: String){
        self.quality = quality
        
        thread = Thread {
               print(name)
           }
        thread.name = name
        thread.qualityOfService = quality
    }
    
    func run(){
        thread.start()
    }
    
    func stop(){
        thread.cancel()
        //        print("Name - \(String(describing: thread.name ?? "name")) , isExecuting - \(thread.isExecuting), isCancelled - \(thread.isCancelled), isFinished - \(thread.isFinished)")
    }
    
    
}
