//
//  Event.swift
//  UntilApp
//
//  Created by Spencer Paciello on 8/7/20.
//

import Foundation

class Event: NSObject, NSCoding {
    //MARK: Properties
    var eventName: String
    var eventTime: Date
    var id: UUID
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("events")
    //MARK: Types
    struct EventStruct {
        static let id = "UUIDString"
        static let eventName = "eventName"
        static let eventTime = "eventTime"
    }
    
    //MARK: Initialization
    init(eventName: String, eventTime: Date, id: UUID) {
        self.eventName = eventName
        self.eventTime = eventTime
        self.id = id
        
    }
    func encode(with coder: NSCoder) {
        coder.encode(eventName, forKey: EventStruct.eventName)
        coder.encode(eventTime, forKey: EventStruct.eventTime)
        coder.encode(id, forKey: EventStruct.id)
    }
    
    required convenience init?(coder: NSCoder) {
        
        let eventName = coder.decodeObject(forKey: EventStruct.eventName) as! String
        let eventTime = coder.decodeObject(forKey: EventStruct.eventTime) as! Date
        let uuid = coder.decodeObject(forKey: EventStruct.id) as? UUID ?? UUID()
        self.init(eventName: eventName, eventTime: eventTime, id: uuid)
    }
    
    
}
