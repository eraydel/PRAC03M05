//
//  AppDelegate.swift
//  erickayalapractica3
//
//  Created by Erick Ayala Delgadillo on 26/03/22.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Validamos con una llave en userdefaults si la información de las bebidas ya se cargó desde el archivo PLIST
        let ud = UserDefaults.standard
        let flag = (ud.value(forKey: "downloadedData") as? Bool) ?? false
        if !flag {
            getData()
        }
        //print( flag )
        return true
    }
    
    // 1. Obtener información del Plist
    /*
     Method: getData
     Created by: Erick Ayala
     Created at: 06/04/2022
     */
    func getData(){
        if let filePath = Bundle.main.url(forResource: "Drinks", withExtension: "plist"){
            do{
                let bytes = try Data(contentsOf: filePath)
                let tmp   = try PropertyListSerialization.propertyList(from: bytes, options: .mutableContainers, format: nil) as! [[String:String]]
                //llenar la base de datos con las bebidas
                fillDB( tmp )
                // setear la userdefault key
                let ud = UserDefaults.standard
                ud.set(true,forKey: "downloadedData")
                ud.synchronize()
            }
            catch{
                print("No se pudo obtener la información desde el archivo plist \(error.localizedDescription) ")
            }
        }
    }
    
    // 2. Llenar la base de datos con información de Plist
    /*
     Method: fillDB
     Created by: Erick Ayala
     Created at: 06/04/2022
     */
    func fillDB(_ drinks: [[String:String]]) {
        // Paso 0. Requerimos la definición de la entidad
        guard let entidad = NSEntityDescription.entity(forEntityName: "Drink", in: persistentContainer.viewContext)
        else {
            return
        }
        // Preparamos los objetos de todas las bebidas
        for drink in drinks {
            // Paso 1: Crear objeto drink
            let drinkObject = NSManagedObject(entity: entidad, insertInto: persistentContainer.viewContext) as! Drink
            // Paso 2. Setear las propiedades del objeto
            drinkObject.initializeObject(drink)
            // Paso 3. SAlvar el objeto
            saveContext()
            
        }
    }
    
    // 3. Obtener todas las bebidas
    /*
     Method: detAllDrinks
     Created by: Erick Ayala
     Created at: 06/04/2022
     */
    func getAllDrinks() -> [Drink]{
        var resulSet = [Drink]()
        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: "Drink")
        do {
            let tmp = try persistentContainer.viewContext.fetch(request)
            resulSet = tmp as! [Drink]
        }
        catch {
            print("Falló el request \(error.localizedDescription)")
        }
        return resulSet
    }
    
    // 4. Insertar Bebida nueva
    /*
     Method: addDrink
     Created by: Erick Ayala
     Created at: 06/04/2022
     */
    func addDrink(_ drink: [String:String]){
        // Paso 0. Requerimos la definición de la entidad
        guard let entidad = NSEntityDescription.entity(forEntityName: "Drink", in: persistentContainer.viewContext)
        else {
            return
        }
        
        print(drink)
        // Paso 1: Crear objeto drink
        let drinkObject = NSManagedObject(entity: entidad, insertInto: persistentContainer.viewContext) as! Drink
        // Paso 2. Setear las propiedades del objeto
        drinkObject.initializeObject(drink)
        // Paso 3. SAlvar el objeto
        saveContext()
        
    }
    
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "erickayalapractica3")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }



}

