//
//  PersonTests.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import XCTest

class PersonTests: XCTestCase {

  func testPerson() {
    let ted = Person(firstName: "Ted", lastName: "Neward", age: 45)
    XCTAssert(ted.toString() == "[Person: firstName:Ted lastName:Neward age:45 job:nil spouse:nil]")
  }
  
  func testAgeRestrictions() {
    let matt = Person(firstName: "Matthew", lastName: "Neward", age: 15)
    
    matt.job = Job(title: "Burger-Flipper", type: Job.JobType.Hourly(5.5))
    XCTAssert(matt.job == nil)

    matt.spouse = Person(firstName: "Bambi", lastName: "Jones", age: 42)
    XCTAssert(matt.spouse == nil)
  }
  
  func testAdultAgeRestrictions() {
    let mike = Person(firstName: "Michael", lastName: "Neward", age: 22)
    
    mike.job = Job(title: "Burger-Flipper", type: Job.JobType.Hourly(5.5))
    XCTAssert(mike.job != nil)
    
    mike.spouse = Person(firstName: "Bambi", lastName: "Jones", age: 42)
    XCTAssert(mike.spouse != nil)
  }
    
    func personTest() {
        let person = Person(firstName: "Brandon", lastName: "Hoang", age: 19)
        XCTAssert(person.description == "[Person: firstName:Brandon lastName:Hoang age:19]")
    }
}

class FamilyTests : XCTestCase {
  
  func testFamily() {
    let ted = Person(firstName: "Ted", lastName: "Neward", age: 45)
    ted.job = Job(title: "Gues Lecturer", type: Job.JobType.Salary(1000))
    
    let charlotte = Person(firstName: "Charlotte", lastName: "Neward", age: 45)
    
    let family = Family(spouse1: ted, spouse2: charlotte)

    let familyIncome = family.householdIncome()
    XCTAssert(familyIncome == 1000)
  }
  
  func testFamilyWithKids() {
    let ted = Person(firstName: "Ted", lastName: "Neward", age: 45)
    ted.job = Job(title: "Gues Lecturer", type: Job.JobType.Salary(1000))
    
    let charlotte = Person(firstName: "Charlotte", lastName: "Neward", age: 45)
    
    let family = Family(spouse1: ted, spouse2: charlotte)

    let mike = Person(firstName: "Mike", lastName: "Neward", age: 22)
    mike.job = Job(title: "Burger-Flipper", type: Job.JobType.Hourly(5.5))
    
    let matt = Person(firstName: "Matt", lastName: "Neward", age: 16)
    family.haveChild(mike)
    family.haveChild(matt)
    
    let familyIncome = family.householdIncome()
    XCTAssert(familyIncome == 12000)
  }
    
    func familyTest() {
        let person1 = Person(firstName: "Brandon", lastName: "Hoang", age: 25)
        person1.job = Job(title: "Barista", type: Job.JobType.Hourly(15000))
        let person2 = Person(firstName: "Alison", lastName: "Kojima", age:25)
        let family = Family(spouse1: person1, spouse2: person2)
        XCTAssert(family.description == "Members:[Person: firstName:Brandon lastName:Hoang age:25], [Person: firstName:Alison lastName:Kojima age:25], Household income: 15000")
    }
  
}