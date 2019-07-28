//
//  TimeZoneData.swift
//  MustangClock
//
//  Created by ryu-ushin on 4/21/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

import UIKit

public class SmileTimeZoneData: NSObject, NSCoding {
    //MARK: ==
    public override func isEqual(_ object: Any?) -> Bool {
        if let rhs = object as? SmileTimeZoneData {
            return timeZone.isEqual(rhs.timeZone)
        }
        return false
    }
    
    //MARK: Property
    public var timeZone: NSTimeZone!
    public var region: String!
    public var subRegion: String?
    public var city: String!
    
    public var hour: Int = 0
    public var minute: Int = 0
    public var second: Int = 0
    public var ampm: String = ""
    public var dayTime: Bool = true
    public var hourMinuteString: String = "00:00"
    public var dayDate: String = "0"
    public var offsetFromLocalTimeZone: String = "0"
    
    //MARK: Init
    override init() {
        
    }
    
    public convenience init(timeZone: NSTimeZone) {
        self.init()
        self.timeZone = timeZone
        parseTimeZoneLocationInfo()
    }
    
    //MARK: NSCoding
    required public init?(coder aDecoder: NSCoder) {
        timeZone = aDecoder.decodeObject(forKey: "zone") as? NSTimeZone
        super.init()
        parseTimeZoneLocationInfo()
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(timeZone, forKey: "zone")
    }
    
    //MARK:parse timeZone Location Info
    func parseTimeZoneLocationInfo() {
        var components = timeZone.description.components(separatedBy: " ")
        let name = components[0]
        components = name.components(separatedBy: "/")
        region = name.replacingOccurrences(of: "_", with: " ")

        if components.count == 3 {
            subRegion = components[1].replacingOccurrences(of: "_", with: " ")
            city = components[2].replacingOccurrences(of: "_", with: " ")
        } else if components.count == 2 {
            city = components[1].replacingOccurrences(of: "_", with: " ")
        } else if components.count == 1 {
            city = components[0].replacingOccurrences(of: "_", with: " ")
        }
    }
    
    let calendar: NSCalendar! = NSCalendar(identifier: .gregorian)
    
    //MARK: Update every 1 second
    func updateTime() {
        let localTimeZone = NSTimeZone.local
        let zoneComponents = calendar.components(in: self.timeZone as TimeZone, from: Date())
        
        //set AM || PM
        if zoneComponents.hour! >= 12 {
            ampm = "PM"
        } else {
            ampm = "AM"
        }
        
        //set dayTime
        if zoneComponents.hour! >= 19 || zoneComponents.hour! < 7 {
            dayTime = false
        } else {
            dayTime = true
        }
        
        //set hour & minute & second
        hour = zoneComponents.hour!
        minute = zoneComponents.minute!
        second = zoneComponents.second!
        
        //set hour minute string
        hourMinuteString = String(format: "%02d:%02d", arguments: [hour, minute])
        
        //set day
        dayDate = String(describing: zoneComponents.day)
    
        //set offset From Local TimeZone
        let secondsBetweenZones: TimeInterval = Double(timeZone.secondsFromGMT - localTimeZone.secondsFromGMT())
        let hoursBetweenZones = secondsBetweenZones / 60 * 60
        var hourOffset: String?
        var dayOffset: String?
        
        if hoursBetweenZones == 0 {
            hourOffset = nil
        } else if hoursBetweenZones == 1 {
            hourOffset = String(format: "%d hour ahead", arguments: [hoursBetweenZones])
        } else if hoursBetweenZones == -1 {
            hourOffset = String(format: "%d hour behind", arguments: [abs(hoursBetweenZones)])
        } else if hoursBetweenZones > 0 {
            hourOffset = String(format: "%d hours ahead", arguments: [hoursBetweenZones])
        } else {
            hourOffset = String(format: "%d hours behind", arguments: [abs(hoursBetweenZones)])
        }
        
        let dateToZoneNow = Date(timeIntervalSinceNow: secondsBetweenZones)
        
        if calendar.isDateInToday(dateToZoneNow) {
            dayOffset = "Today"
        } else if calendar.isDateInTomorrow(dateToZoneNow) {
            dayOffset = "Tomorrow"
        } else if calendar.isDateInYesterday(dateToZoneNow) {
            dayOffset = "Yesterday"
        }
        
        if hourOffset != nil && dayOffset != nil {
            offsetFromLocalTimeZone = String(format: "%@, %@", arguments: [dayOffset!, hourOffset!])
        } else if hourOffset == nil && dayOffset != nil{
            offsetFromLocalTimeZone = String(format: "%@", arguments: [dayOffset!])
        }
    }
    
    //MARK: Debug
    func debugLog() {
        print("\(timeZone.name) - \(timeZone.description) - \(String(describing: timeZone.localizedName(.standard, locale: Locale.current))) - \(String(describing: timeZone.localizedName(.shortStandard, locale: Locale.current))))")
    }
}
