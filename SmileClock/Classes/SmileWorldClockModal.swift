//
//  WorldClockModal.swift
//  MustangClock
//
//  Created by yuchen liu on 4/22/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

import UIKit

@objc public protocol SmileWorldClockModelDelegate {
    func timeZonesInModelHaveChanged()
    func secondHasPassed()
}

public class SmileWorldClockModel: NSObject, NSCoding {
    //MARK: ==
    public override func isEqual(_ object: Any?) -> Bool {
        if let rhs = object as? SmileWorldClockModel {
            return selectedTimeZones == rhs.selectedTimeZones
        }
        return false
    }
    
    //MARK: Property
    var timer: Timer?
    public var selectedTimeZones = [SmileTimeZoneData]()
    var delegate: SmileWorldClockModelDelegate!
    
    //MARK: Init
    public override init() {
        
    }
    
    public convenience init(theDelegate: SmileWorldClockModelDelegate) {
        self.init()
        self.delegate = theDelegate
    }
    
    //MARK: NSCoding
    required public init?(coder aDecoder: NSCoder) {
        if let data = aDecoder.decodeObject(forKey: "selectedTimeZones") as? [SmileTimeZoneData] {
            selectedTimeZones = data
        }
        super.init()
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(selectedTimeZones, forKey: "selectedTimeZones")
    }
    
    //MARK: Timer
    public func startTimerWithDelegate(theDelegate: SmileWorldClockModelDelegate) {
        delegate = theDelegate
        if selectedTimeZones.count > 0 {
            startTimer()
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    @objc func fireTimer() {
        if selectedTimeZones.count > 0 {
            for timeZoneData in selectedTimeZones {
                timeZoneData.updateTime()
            }
            delegate.secondHasPassed()
        }
    }
    
    //MARK: Add New TimeZoneData
    public func addData(timeZoneData: SmileTimeZoneData) {
        selectedTimeZones.append(timeZoneData)
        timeZoneData.updateTime()
        if selectedTimeZones.count == 1 {
            startTimer()
        }
    }
}
