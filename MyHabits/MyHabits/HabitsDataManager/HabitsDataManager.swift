//
//  HabitsDataManager.swift
//  MyHabits
//
//  Created by Sokolov on 03.07.2023.
//

import Foundation
import CoreData
import UIKit

class HabitsDataManager {
    
    static let shared = HabitsDataManager()
    
    init() {
        reloadHabits()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
         let container = NSPersistentContainer(name: "HabitsDataManager")
         container.loadPersistentStores(completionHandler: { (storeDescription, error) in
             print("storeDescription = \(storeDescription)")
             if let error = error as NSError? {
                 fatalError("Unresolved error \(error), \(error.userInfo)")
             }
         })
         return container
     } ()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    var habits = [Habit]()
    
    func reloadHabits() {
        let request = Habit.fetchRequest()
        
        let habits = (try? persistentContainer.viewContext.fetch(request)) ?? []
        
        self.habits = habits
    }
    
    func createHabit(id: String, name: String, time: String, completed: Bool, sum: Int, color: UIColor, completion: @escaping() -> Void) {
        persistentContainer.performBackgroundTask { contextBackground in
            let habit = Habit(context: contextBackground)
            habit.id = id
            habit.name = name
            habit.time = time
            habit.completed = completed
            habit.sum = Int32(sum)
            habit.color = color
            
            do {
                try contextBackground.save()
            } catch {
                print(error)
            }
            
            self.reloadHabits()
            completion()
        }
    }
    
    func deleteHabit(habit: Habit) {
        persistentContainer.viewContext.delete(habit)
        reloadHabits()
    }
    
}
