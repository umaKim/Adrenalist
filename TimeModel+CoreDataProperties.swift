//
//  TimeModel+CoreDataProperties.swift
//  
//
//  Created by 김윤석 on 2021/04/19.
//
//

import Foundation
import CoreData


extension TimeModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TimeModel> {
        return NSFetchRequest<TimeModel>(entityName: "TimeModel")
    }

    @NSManaged public var timeCountUpTo: Int64

}
