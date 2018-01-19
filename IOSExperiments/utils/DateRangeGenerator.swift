//
//  DateRangeGenerator.swift
//  IOSExperiments
//
//  Created by 0x384c0 on 19.12.16.
//  Copyright © 2016 0x384c0. All rights reserved.
//


class DateRangeGenerator{
    private var
    start:Date?,
    end:Date?
    func dateTap(_ date:Date){
        if start == nil , end == nil{
            start = date
            return
        }
        if start != nil, end == nil{
            if start!.timeIntervalSince1970 > date.timeIntervalSince1970 {
                end = start
                self.start = date
            } else {
                end = date
            }
            return
        }
        if start != nil && end != nil {
            start = date
            end = nil
            return
        }
    }
    func generateDateRange() -> [Date]{
        return generateDateRange(start:start,end:end)
    }
    func reset(){
        start = nil
        end = nil
    }
    
    var startDaysSince1970:Int?{
        return start?.daysSince1970
    }
    
    private func generateDateRange(start:Date?,end:Date?) -> [Date]{
        var result = [Date]()
        if let start = start,let end = end{
            var dateTmp = start
            result.append(start)
            
            while dateTmp.addingTimeInterval(24*60*60).timeIntervalSince1970 <= end.timeIntervalSince1970{
                dateTmp = dateTmp.addingTimeInterval(24*60*60)
                result.append(dateTmp)
            }
            
        } else if let start = start{
            result.append(start)
        }
        return result
    }
}
