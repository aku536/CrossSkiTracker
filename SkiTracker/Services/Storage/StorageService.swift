//
//  StorageService.swift
//  SkiTracker
//
//  Created by AFONIN Kirill on 01.06.2023.
//

import CoreData
import Foundation

final class StorageService {

  func save(_ training: TrainingModel) {
    let trainingEntity = NSEntityDescription.entity(forEntityName: "Training", in: managedContext)!
    let trainingObject = NSManagedObject(entity: trainingEntity, insertInto: managedContext)

    trainingObject.setValue(training.id, forKeyPath: "id")
    trainingObject.setValue(training.trainingTime, forKeyPath: "duration")
    trainingObject.setValue(training.distance, forKeyPath: "distance")
    trainingObject.setValue(training.elevation, forKeyPath: "elevation")
    trainingObject.setValue(training.maxSpeed, forKeyPath: "maxSpeed")

    try! managedContext.save()
  }

  func loadTrainings() -> [TrainingModel] {
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Training")
    let trainings = try! managedContext.fetch(fetchRequest)

    return trainings.map {
      TrainingModel(
        trainingTime: $0.value(forKey: "duration") as! Double,
        distance: $0.value(forKey: "distance") as! Double,
        elevation: $0.value(forKey: "elevation") as! Double,
        maxSpeed: $0.value(forKey: "maxSpeed") as! Double,
        id: $0.value(forKey: "id") as! UUID
      )
    }
  }

  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Training")
    container.loadPersistentStores { description, error in
      if let error { fatalError("Unable to load persistent stores: \(error)") }
    }
    return container
  }()

  private var managedContext: NSManagedObjectContext {
    persistentContainer.viewContext
  }
}
