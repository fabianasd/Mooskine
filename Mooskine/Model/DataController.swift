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
     
    // propriedade para o contexto em 2 plano. Vamos desencapsular implicitamente
    let backgroundContext:NSManagedObjectContext!
    
    //inicializador que o configure
    init(modelName:String) {
        persistentContainer =  NSPersistentContainer(name: modelName)//instanciar o recipiente persistente = e passar o nome do modelo para o seu inicializador

        //... 1: é um método padrao newBackgroundContext. Que cria um novo contexto em segundo plano.
        backgroundContext = persistentContainer.newBackgroundContext()
    }
    
    //instanciar para trabalhar os dois contextos
    func configureContexts() {
       // backgroundContext = persistentContainer.newBackgroundContext()// criar o contexto associado com uma fila privada
        
        //fusão de mudanças automaticamente
        viewContext.automaticallyMergesChangesFromParent = true //frontal
        backgroundContext.automaticallyMergesChangesFromParent = true //2 plano
        
        //politicas para o app não travar
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump //2 plano
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump //se houver conflito preferira os valores de propriedade
    }
    
    //carregar o repositorio persistente.
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription) //pare a execução e registre o problema
            }
            self.autoSaveViewContext()
            self.configureContexts()
            completion?()
        }
    }
}

extension DataController {
    //salva e chama recursivamente com frequencia
    func autoSaveViewContext(interval:TimeInterval = 30) {
        print("autosaving ")
        
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
