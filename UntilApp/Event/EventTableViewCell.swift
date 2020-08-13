//
//  EventTableViewCell.swift
//  UntilApp
//
//  Created by Spencer Paciello on 8/7/20.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var timeLeft: UILabel!
    var eventTime: Date?
    let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .month, .year])
    
    var timerToUpdateCell: Timer?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        timerToUpdateCell = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {_ in
            if(self.eventTime != nil) {
                let currentdate = Date()
                let itemsOfDate = Calendar.current.dateComponents(self.components, from: currentdate, to: self.eventTime!)
                self.timeLeft.text = "\(itemsOfDate.day!) Days \(itemsOfDate.hour!) Hours \(itemsOfDate.minute!) Minutes \(itemsOfDate.second!) Seconds"
                self.stopTimer()
            }
            
        }
        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {_ in
            if(self.eventTime != nil) {
                let currentdate = Date()
                let itemsOfDate = Calendar.current.dateComponents(self.components, from: currentdate, to: self.eventTime!)
                self.timeLeft.text = "\(itemsOfDate.day!) Days \(itemsOfDate.hour!) Hours \(itemsOfDate.minute!) Minutes \(itemsOfDate.second!) Seconds"
            }
            
        }
        
    }

    func stopTimer() {
        self.timerToUpdateCell?.invalidate()
        self.timerToUpdateCell = nil
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
