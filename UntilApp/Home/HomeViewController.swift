//
//  HomeCollectionViewController.swift
//  UntilApp
//
//  Created by Spencer Paciello on 8/11/20.
//

import UIKit

private let reuseIdentifier = "EventCell"


class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate {
    var events = [Event]()
    
    @IBOutlet weak var eventsCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // used for testing purposes if there are no events inside
        if let savedEvents = loadEvents() {
            events += savedEvents
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            
            events = [Event(eventName: "hello", eventTime: formatter.date(from: "08-08-2020")!, id: UUID())]
        }
        
        //observers so that we can keep main logic in this file
        NotificationCenter.default.addObserver(forName: NSNotification.Name("addAnEvent"), object: nil, queue: nil, using: addEvent)
        NotificationCenter.default.addObserver(forName: NSNotification.Name("changeAnEvent"), object: nil, queue: nil, using: editEvent)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func addNewEventButton(_ sender: Any) {
        performSegue(withIdentifier: "modalPresentNewEvent", sender: nil)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier) {
        case "ShowItem":
            guard let eventDetailViewController = segue.destination as? EventDetailViewController else {
                fatalError("UGUHGUHGHGHUG")
            }
            guard let selectedEventCell = sender as? CustomCollectionViewCell else {
                fatalError("efuhguhfguhud")
            }
            guard let indexPath = eventsCollectionView.indexPath(for: selectedEventCell) else {
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
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as! CustomCollectionViewCell
        cell.event = events[indexPath.row]
        cell.deleteButton.addTarget(self, action: #selector(self.deleteCellAction(_:)), for: .touchUpInside)
        cell.update();
        return cell
    }
    
    
    private func loadEvents() -> [Event]? {
        do {
            let rawData = try Data(contentsOf: Event.ArchiveURL)
            return try (NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(rawData) as? [Event])
        } catch {
            return nil
        }
    }
    
    @objc func addEvent(notification: Notification) -> Void {
        
        let recievedEventName: String = notification.userInfo!["eventName"] as! String
        let recievedEventTime: Date = notification.userInfo!["eventTime"] as! Date
        let UUIDString: UUID = notification.userInfo!["uuid"] as! UUID
        
        let eventToAdd = Event(eventName: recievedEventName, eventTime: recievedEventTime, id: UUIDString)
        
        scheduleEventNotification(event: eventToAdd)

        let indexPath = IndexPath(row: self.events.count, section: 0)
        events.append(eventToAdd)
        self.eventsCollectionView.insertItems(at: [indexPath])
        
        saveEvents();
        self.eventsCollectionView.reloadData()
        
    }
    
    
    @objc func editEvent(notification: Notification) -> Void {
        
        let recievedEventName: String = notification.userInfo!["eventName"] as! String
        let recievedEventTime: Date = notification.userInfo!["eventTime"] as! Date
        let UUIDString: UUID = notification.userInfo!["uuid"] as! UUID
        //makes sure to cancel notification for event, update event info, then remake a notification
        for (n, event) in events.enumerated() {
            if(event.id == UUIDString){
                cancelEventNotification(event: event)
                events[n].eventName = recievedEventName
                events[n].eventTime = recievedEventTime
                scheduleEventNotification(event: event)
                eventsCollectionView.reloadItems(at: [IndexPath(row: n, section: 0)])
            }
        }
        saveEvents()
        
    }
    
    private func saveEvents() {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: events, requiringSecureCoding: false)
            try data.write(to: Event.ArchiveURL)
        } catch {
            print("error trying to save events")
        }
    }
    
    
    
    @objc func deleteCellAction(_ sender:UIButton!){
        //gets which cell the user wanted to delete
        if let button = sender {
            let point: CGPoint = button.convert(.zero, to: eventsCollectionView)
            if let indexPath = eventsCollectionView!.indexPathForItem(at: point) {
                self.cancelEventNotification(event: events[indexPath.row])
                removeExistingImage(eventUUID: events[indexPath.row].id.uuidString)
                events.remove(at: indexPath.row)
                
                self.eventsCollectionView.deleteItems(at: [indexPath])
                
                saveEvents()
            }
        }
    }
    
    
    private func scheduleEventNotification(event: Event) {
        let notificationCenter = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        //check that the user actually has notifications enabled if not then prompt
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if (didAllow) {
                let content = UNMutableNotificationContent()
                content.title = "Your Countdown has finished!"
                content.body = "It's time for \(event.eventName)!!!"
                content.sound = .default
                
                let componentsFromDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: event.eventTime)
                let trigger = UNCalendarNotificationTrigger(dateMatching: componentsFromDate, repeats: false)
                let request = UNNotificationRequest(identifier: event.id.uuidString, content: content, trigger: trigger)
                
                notificationCenter.add(request) {(error) in
                    if error != nil {
                        print(error ?? "error with notification center")
                }}
            }
        }
        
    }
    
    
    private func cancelEventNotification(event:Event) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [event.id.uuidString])
    }
    
    
    
    
    
    
    
}
