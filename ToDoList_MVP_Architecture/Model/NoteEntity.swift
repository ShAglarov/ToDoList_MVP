//
//  NoteEntity.swift
//  ToDoList_MVP_Architecture
//
//  Created by Shamil Aglarov on 15.06.2023.
//

import Foundation
import CoreData

// MARK: - NoteEntity
// Класс, представляющий сущность заметки в CoreData.
@objc(NoteEntity)
public class NoteEntity: NSManagedObject {

    // MARK: - Свойства
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var isComplete: Bool
    @NSManaged public var dueDate: Date?
    @NSManaged public var notes: String?

    // MARK: - Инициализация
    // Создает новый экземпляр сущности заметки на основе предоставленной заметки.
    convenience init(from note: Note, context: NSManagedObjectContext) {
        // Вызывает инициализатор базового класса NSManagedObject
        self.init(context: context)
        
        // Копирует значения из заметки в сущность заметки
        self.id = note.id
        self.title = note.title
        self.isComplete = note.isComplete
        self.dueDate = note.dueDate
        self.notes = note.notes
    }
}





