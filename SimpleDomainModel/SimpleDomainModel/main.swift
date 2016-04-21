//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

public class TestMe {
  public func Please() -> String {
    return "I have been tested"
  }
}

protocol CustomStringConvertible {
    var description : String { get }
}

protocol Mathematics {
    func +(this: Money, that: Money) -> Money
    func -(this: Money, from: Money) -> Money
}

public func +(this:Money, that: Money) -> Money {
    return this.add(that)
}

func -(this:Money, from: Money) -> Money {
    return this.subtract(from)
}

extension Double {
    var USD: Money { return Money(amount: Int(self), currency: "USD")}
    var EUR: Money { return Money(amount: Int(self), currency: "EUR")}
    var GBP: Money { return Money(amount: Int(self), currency: "GBP")}
    var YEN: Money { return Money(amount: Int(self), currency: "YEN")}
}

////////////////////////////////////
// Money
//
public struct Money: CustomStringConvertible, Mathematics {
  public var amount : Int
  public var currency : String
    public var description: String {
        get {
            return "\(self.currency)\(self.amount)"
        }
    }
  
  public func convert(to: String) -> Money {
    let currencyRates = ["USD": 1.0, "GBP": 0.5, "EUR": 1.5, "CAN": 1.25]
    
    if self.currency == to {
        return self
    } else {
        return Money(amount: Int((currencyRates[to]! / currencyRates[self.currency]!) * Double(self.amount)), currency: to)
    }
  }
  
  public func add(to: Money) -> Money {
    if to.currency == self.currency {
        return Money(amount: to.amount + self.amount, currency: self.currency)
    } else {
        let convertedAmount = self.convert(to.currency)
        return Money(amount: convertedAmount.amount + to.amount, currency: self.currency)
    }
  }
    
  public func subtract(from: Money) -> Money {
    if from.currency == self.currency {
        return Money(amount: from.amount - self.amount, currency: self.currency)
    } else {
        let convertedAmount = self.convert(from.currency)
        return Money(amount: from.amount - convertedAmount.amount, currency: self.currency)
    }
  }
}

////////////////////////////////////
// Job
//
public class Job: CustomStringConvertible {
    public var title : String
    public var type : JobType
    public var description: String {
        get {
            switch type {
            case let .Hourly(value):
                return "\(self.title): $\(value) per hour"
            case let .Salary(value):
                return "\(self.title): $\(value) per year"
            }
        }
    }
    
  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  public func calculateIncome(hours: Int) -> Int {
    switch type {
        case let .Hourly(rate):
            return Int(Double(hours) * rate)
        case let .Salary(amt):
            return amt
        }
  }
  
  public func raise(amt : Double) {
    switch type {
        case let .Hourly(rate):
            self.type = .Hourly(amt + rate)
        case let .Salary(total):
            self.type = .Salary(Int(amt) + total)
    }
  }
}

////////////////////////////////////
// Person
//
public class Person: CustomStringConvertible {
  public var firstName : String = ""
  public var lastName : String = ""
  public var age : Int = 0
  private var _job : Job? = nil
  private var _spouse : Person? = nil
    public var description: String {
        get {
            return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age)]"
        }
    }

  public var job : Job? {
    get {
        return _job
    }
    
    set(value) {
        if (age >= 16) {
            _job = value
        }
    }
  }
  
  public var spouse : Person? {
    get {
        return _spouse
    }
    
    set(value) {
        if (age >= 18) {
            _spouse = value
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  public func toString() -> String {
    return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job) spouse:\(spouse)]"
  }
}

////////////////////////////////////
// Family
//
public class Family: CustomStringConvertible {
  private var members : [Person] = []
    public var description: String {
        var family = "Members: "
        for person in members {
            family += "\(person.description), "
        }
        family += "Household income: \(householdIncome())"
        return family
    }
  
  public init(spouse1: Person, spouse2: Person) {
    if spouse1.spouse == nil && spouse2.spouse == nil {
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        members.append(spouse1)
        members.append(spouse2)
    }
  }
  
  public func haveChild(child: Person) -> Bool {
    if members[0].age > 21 || members[1].age > 21 {
        child.age = 0
        members.append(child)
    }
    return true
  }
  
  public func householdIncome() -> Int {
    var totalIncome = 0
    for person in members {
        if person.job != nil {
            totalIncome = totalIncome + (person.job?.calculateIncome(2000))!
        }
    }
    return totalIncome
    }
}