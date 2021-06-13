//
//  DataController.swift
//  Mooskine
//
//  Created by Fabiana Petrovick on 23/05/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    //recipiente persistente, ele nao deve mudar durante a vida do controlador de dados
    let persistentContainer:NSPersistentContainer
    
    var viewContext:NSManagedObjectContext { //propriedade de convenienca para acessar o contexto.
        return persistentContainer.viewContext //O container (DataController: cria uma fila principal chamada viewContext. Ele tambem fornece duas formas de  criar contextos em segundo plano...    //... 2 metodo para criar um contexto temporario, para realizar uma unica tarefa
    }
        
    let backgroundContext:NSManagedObjectContext!
    
    //inicializador que o configure
    init(modelName:String) {
        persistentContainer =  NSPersistentContainer(name: modelName)//instanciar o recipiente persistente = e passar o nome do modelo para o seu inicializador

        //... 1: é um método padrao newBackgroundContext. Que cria um novo contexto em segundo plano.
        backgroundContext = persistentContainer.newBackgroundContext()
    }
    
    func configureContexts() {
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true
        
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    //carregar o repositorio persistente.
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription) //pare a execução e registre o problema
            }
            self.autoSaveViewContext()
            completion?()
        }
    }
}

extension DataController {
    //salva e chama recursivamente com frequencia
    func autoSaveViewContext(interval:TimeInterval = 30) {
        print("aquiiii no autoSaveViewContext ")
        guard interval > 0 else {
            print("cannot set negative autosave internal")
            return
        }
        if viewContext.hasChanges {
            try? viewContext.save() // o metodo save pode roda, mas descartamos o erro utilizando "try"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }//chama novamente o save
    }
}
