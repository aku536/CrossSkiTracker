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
    trainingObject.setValue(training.date, forKeyPath: "date")

    try! managedContext.save()
  }

  func loadTrainings() -> [TrainingModel] {
    let trainings = fetchTrainings()

    return trainings.map {
      TrainingModel(
        trainingTime: $0.value(forKey: "duration") as! Int,
        distance: $0.value(forKey: "distance") as! Double,
        elevation: $0.value(forKey: "elevation") as! Double,
        maxSpeed: $0.value(forKey: "maxSpeed") as! Double,
        id: $0.value(forKey: "id") as! UUID,
        date: ($0.value(forKey: "date") as? Date) ?? Date(timeIntervalSince1970: 0)
      )
    }
  }

  func deleteTraining(with id: UUID) {
    fetchTrainings().forEach {
      if ($0.value(forKey: "id") as! UUID) == id {
        managedContext.delete($0)
      }
    }

  }

  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Training")
    container.loadPersistentStores { description, error in
      if let error { fatalError("Unable to load persistent stores: \(error)") }
    }
    return container
  }()
}

// MARK: - Private

private extension StorageService {
  var managedContext: NSManagedObjectContext {
    persistentContainer.viewContext
  }

  func fetchTrainings() -> [NSManagedObject] {
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Training")
    return try! managedContext.fetch(fetchRequest)
  }
}
