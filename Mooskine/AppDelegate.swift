//
//  AppDelegate.swift
//  Mooskine
//
//  Created by Fabiana Petrovick on 19/05/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let dataController = DataController(modelName: "Mooskine")
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        dataController.load()//sera chamdo quando o repositorio persistente for carregado
        
        let navigationController = window?.rootViewController as! UINavigationController
        let notebooksListViewController = navigationController.topViewController as! NotebooksListViewController
        notebooksListViewController.dataController = dataController
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        saveViewContext()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        saveViewContext()
    }
    
    //metodo auxiliar, que chama save no viewContext do DataController
    func saveViewContext(){
        try? dataController.viewContext.save()
    }
    
}

