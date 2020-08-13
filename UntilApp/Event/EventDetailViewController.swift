//
//  EventDetailViewController.swift
//  UntilApp
//
//  Created by Spencer Paciello on 8/7/20.
//

import UIKit

class EventDetailViewController: UIViewController {

    // passed by segue
    var event: Event? {
        didSet {
            
            update();
            _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        }
    }
    let formatter = DateFormatter()
    let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .month, .year])
    
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var dayLabel: UILabel?
    @IBOutlet weak var hourLabel: UILabel?
    @IBOutlet weak var minuteLabel: UILabel?
    @IBOutlet weak var secondLabel: UILabel?
    @IBOutlet weak var eventTitle: UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageFile = self.filePath(forKey: event!.id.uuidString);
        if let fileData = FileManager.default.contents(atPath: imageFile!.path) {
            let image = UIImage(data: fileData)
            let imageView = UIImageView(frame: self.view.bounds)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = image
            imageView.center = view.center
            imageView.layer.zPosition = -1
            self.eventView.addSubview(imageView)
        }

//
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is NewEventViewController {
            let vc = segue.destination as? NewEventViewController
            vc?.isInEditStage = true;
            vc?.previousEventName = event?.eventName
            vc?.previousEventDate = event?.eventTime
            vc?.eventId = event?.id
        }
    }
    
    
    @objc func update() {
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        let currentdate = Date()
        let itemsOfDate = Calendar.current.dateComponents(components, from: currentdate, to: event!.eventTime)

        eventTitle?.text = event?.eventName
        dayLabel?.text = "\(itemsOfDate.day!) Days"
        hourLabel?.text = "\(itemsOfDate.hour!) Hours"
        minuteLabel?.text = "\(itemsOfDate.minute!) Minutes"
        secondLabel?.text = "\(itemsOfDate.second!) Seconds"
    }
    @IBAction func backToMainMenu(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        return documentURL.appendingPathComponent(key + ".png")
    }
    @IBAction func returnToGridView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
