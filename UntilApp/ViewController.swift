//
//  ViewController.swift
//  UntilApp
//
//  Created by Spencer Paciello on 8/1/20.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableOfEvents: UITableView!
    var events = [Event]()
    let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .month, .year])
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as? EventTableViewCell else {
            fatalError("ugh")
        }
        let currentEvent = events[indexPath.row]
        cell.eventTime = currentEvent.eventTime
        cell.eventName.text = currentEvent.eventName
        return cell;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableOfEvents.separatorStyle = .none
        tableOfEvents.delegate = self
        tableOfEvents.dataSource = self
        if let savedEvents = loadEvents() {
            events += savedEvents
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            
            events = [Event(eventName: "hello", eventTime: formatter.date(from: "08-08-2020")!, id: UUID())]
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name("addAnEvent"), object: nil, queue: nil, using: addEvent)
        NotificationCenter.default.addObserver(forName: NSNotification.Name("changeAnEvent"), object: nil, queue: nil, using: editEvent)
        
        // Do any additional setup after loading the view.
    }

    private func loadEvents() -> [Event]? {
        do {
            let rawData = try Data(contentsOf: Event.ArchiveURL)
            return try (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(rawData) as? [Event])
        } catch {
            return nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier) {
        case "ShowItem":
            guard let eventDetailViewController = segue.destination as? EventDetailViewController else {
                fatalError("UGUHGUHGHGHUG")
            }
            guard let selectedEventCell = sender as? EventTableViewCell else {
                fatalError("efuhguhfguhud")
            }
            guard let indexPath = tableOfEvents.indexPath(for: selectedEventCell) else {
                fatalError("The selected cell not being dispplayed")
                
            }
            
            let selectedEvent = events[indexPath.row]
            eventDetailViewController.event = selectedEvent
        case .none:
            break
        case .some(_):
            break
        }
        
    }
    //used to add an event
    @objc func addEvent(notification: Notification) -> Void {
        let recievedEventName: String = notification.userInfo!["eventName"] as! String
        let recievedEventTime: Date = notification.userInfo!["eventTime"] as! Date
        let UUIDString: UUID = notification.userInfo!["uuid"] as! UUID
        let newIndexPath = IndexPath(row: events.count, section: 0)
        let eventToAdd = Event(eventName: recievedEventName, eventTime: recievedEventTime, id: UUIDString)
        events.append(eventToAdd)
        tableOfEvents.insertRows(at: [newIndexPath], with: .automatic)
        saveEvents()
 
    }
    
    @objc func editEvent(notification: Notification) -> Void {
        let recievedEventName: String = notification.userInfo!["eventName"] as! String
        let recievedEventTime: Date = notification.userInfo!["eventTime"] as! Date
        let UUIDString: UUID = notification.userInfo!["uuid"] as! UUID
        events.filter({$0.id == UUIDString}).forEach({
            $0.eventName = recievedEventName
            $0.eventTime = recievedEventTime
        })
        self.tableOfEvents.reloadData()
        saveEvents()
 
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // delete your item here and reload table view
                events.remove(at: indexPath.row)
                tableOfEvents.deleteRows(at: [indexPath], with: .fade)
                saveEvents()
            }
    }
    
    func saveEvents() {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: events, requiringSecureCoding: false)
            try data.write(to: Event.ArchiveURL)
        } catch {
            print("Could not save event")
        }
    }
    
}

