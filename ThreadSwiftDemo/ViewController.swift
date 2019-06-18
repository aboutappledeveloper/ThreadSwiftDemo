//
//  ViewController.swift
//  ThreadSwiftDemo
//
//  Created by 吕建雄 on 2019/6/18.
//  Copyright © 2019 吕建雄. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.mainAsyncTest()
        
//        self.mainSyncTest()
        
//        self.globalAsyncTest()
        
//        self.globalSyncTest();
        
//        self.serialAsyncTest();
        
        self.serialSyncTest()
    }
    
    /*
     添加异步代码块到main队列(不会开辟新线程)
     在主线程添加一个任务，因为是异步，添加后不管任务执行不执行直接返回，main线程继续往下执行
     由于新添加的任务排在队列的末尾，需要等前面的任务执行完，所以需要等start，run，end执行完下能开始执行
     */
    func mainAsyncTest() {
        print("start")
        print(Thread.current)
        DispatchQueue.main.async {
            sleep(2);
            print(Thread.current)
            print("main queue async sleep2")
        }
        print("run")
        DispatchQueue.main.async {
            print(Thread.current)
            print("main queue async")
        }
        sleep(2)
        print("end")
        
        /*
         输出：start
         输出：run
         等待2秒，输出：end
         等待2秒，输出：main queue async sleep2
         输出：main queue async
         */
    }
    
    /*
     原因：添加同步代码块到main队列，引起死锁
     在主线程里面添加一个任务，因为是同步，所以会等添加的任务执行完成后才能继续走下去
     但是新添加的任务排在队列的末尾，需要等前面的任务执行完，因此又回到了start，程序卡死
     */
    func mainSyncTest() {
        print("start")
        
        DispatchQueue.main.sync {
            print("main queue sync")
        }
        print("end")
        /*
         输出：start
         然后Crash
         */
    }
    
    
    /*
     添加异步代码块到全局队列，由于是添加到全局队列，所以会开辟一个新的现场，
     DispatchQueue.global().async 在新的线程中异步添加对应的代码块，不管block中任务是否执行，直接返回
     主线程继续往下
     因为是多线程，所以DispatchQueue.global().async中的代码，将在新开辟线程执行，于main线程没有关系
     */
    func globalAsyncTest(){
        print("start")
        print(Thread.current)
        DispatchQueue.global().async {
            sleep(2)
            print("global queue async sleep2")
        }
        print("run")
        DispatchQueue.global().async {
            print("global queue async")
        }
        sleep(2);
        print("end")
        
        /*
         输出：start
         输出：run
         输出：global queue async
         等待2秒，输出：end
         输出：global queue async sleep2
         */
    }
    
    
    
    /*
     添加同步代码块到全局队列,不会开辟新线程
     在全局队列添加一个任务，因为同步异步，添加后需要等block中的任务执行完才返回，所以是顺序执行
     */
    func globalSyncTest() {
        print("start")
        print(Thread.current)
        DispatchQueue.global().sync {
            print(Thread.current)
            sleep(2)
            print("global queue sync sleep2")
        }
        print("run")
        DispatchQueue.global().sync {
            print(Thread.current)
            print("global queue sync");
        }
        sleep(2);
        print("end")
        /*
         输出：start
         等待2秒，输出：global queue sync sleep2
         输出：run
         输出：global queue sync
         等待2秒，输出：end
         
        
         */
    }
    
    /*
     串行队列与全局队列的区别是，串行队列的任务只会在一个线程中执行（结果与main一致）
     */
    func serialAsyncTest() {
        print("start")
        print(Thread.current)
        let serial = DispatchQueue(label: "serialQueue1")
        serial.async {
            sleep(2);
            print(Thread.current)
            print("serial queue async sleep2")
        }
        print("run")
        serial.async {
            print(Thread.current)
            print("serial queue async")
        }
        sleep(2)
        print("end")
        
        /*
         输出：start
         输出：run
         等待2秒，输出：end
         等待2秒，输出：serial queue async sleep2
         输出：serial queue async
         */
    }
    
    /*
     串行队列与全局队列的区别是，串行队列的任务只会在一个线程中执行（结果与globalSyncTest一致）
     */
    func serialSyncTest() {
        print("start")
        let serial = DispatchQueue(label: "serialQueue1")
        serial.sync {
            sleep(2);
            print("serial queue sync sleep2")
        }
        print("run")
        serial.sync {
            print("serial queue sync")
        }
        sleep(2)
        print("end")
        
        /*
         输出：start
         等待2秒，输出：serial queue sync sleep2
         输出：run
         输出：serial queue sync
         等待2秒，输出：end
         */
    }
}

