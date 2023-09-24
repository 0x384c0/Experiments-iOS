//
// Created on: 24/9/23

import CoreData

/**
 Core Data abstracts the details of mapping your objects to a store
 */
class CoreDataExample { // DAO
    lazy var persistentContainer: NSPersistentContainer =  {
        let bundle = Bundle.module
        let mom = NSManagedObjectModel.mergedModel(from: [bundle])!
        let container = NSPersistentContainer(name: "Model",managedObjectModel: mom)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType // NSBinaryStoreType, NSSQLiteStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()

    var entities: [ExampleEntity]?{
        try? persistentContainer.viewContext.fetch(ExampleEntity.fetchRequest())
    }

    func entity(by valueInt: Int) -> ExampleEntity? {
        let request = ExampleEntity.fetchRequest()
        request.predicate = NSPredicate(format: "valueInt == %i", valueInt)
        request.fetchLimit = 1
        return try? persistentContainer.viewContext.fetch(request).first
    }

    func delete(by valueInt: Int) {
        if let object = entity(by: valueInt) {
            persistentContainer.viewContext.delete(object)
        }
    }

    func addEntity(valueInt:Int, valueString: String) {
        let context = persistentContainer.viewContext

        // write
        let exampleEntity = ExampleEntity(context: context)
        exampleEntity.valueInt = Int32(valueInt)
        exampleEntity.valueString = valueString
        try! context.save()
    }
}
