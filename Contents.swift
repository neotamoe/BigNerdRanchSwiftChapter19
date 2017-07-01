//: Playground - noun: a place where people can play

import UIKit

// protocol allows you to define the inteface you want a type to satisfy: a type that satisfies a protocol is said to "conform" to the protocol
// {get} signifies that these properties can be read, if it were a read/write, it would be {get set}
// with {get} a conforming type may be read/write, but the protocol requires it to be readable
// protocol sets the minimum set of properties and methods a type must have; it can have more as long as minimum is met
// protocol inheritance: adds any requirements from the parent protocol to the child protocol, in next line, TabularDataSource inherits from the CustomStringConvertible protocol -- however this is not best decision, so commented out
//protocol TabularDataSource: CustomStringConvertible {
protocol TabularDataSource {

    var numberOfRows: Int {get}
    var numberOfColumns: Int {get}
    
    func label (forColumn column: Int) -> String
    
    func itemFor (row: Int, column: Int) -> String
}

// setting up a table
//func printTable(_ data: [[String]], withColumnLabels columnLabels: String...) {
func printTable(_ dataSource: TabularDataSource & CustomStringConvertible){
    print("Table: \(dataSource.description)")
    //create first row containing column headers
    var firstRow = "|"
    // keep track of the width of each column
    var columnWidths = [Int]()
    
//    for columnLabel in columnLabels {
    for i in 0 ..< dataSource.numberOfColumns {
        let columnLabel = dataSource.label(forColumn: i)
        let columnHeader = " \(columnLabel) |"
        firstRow += columnHeader
        columnWidths.append(columnLabel.characters.count)
    }
    print(firstRow)

//    for row in data {
    for i in 0 ..< dataSource.numberOfRows {
        // start the output string
        var out = "|"
        // append each item in this row to the string
//      commented out these lines when adding columnWidths
//        for item in row {
//            out += " \(item) |"
//        }
//        for (j,item) in row.enumerated() {
        for j in 0 ..< dataSource.numberOfColumns {
            let item = dataSource.itemFor(row: i, column: j)
//            let paddingNeeded = columnWidths[j] - item.characters.count
            let paddingNeeded = item.characters.count

            let padding = repeatElement(" ", count: paddingNeeded).joined(separator: "")
            out += " \(padding)\(item)"
        }
        
        // done--print it!
        print(out)
    }
}

// the above function works, but it is difficult to use...so use structures and classes
//let data = [
//    ["Joe", "30", "6"],
//    ["Karen", "40", "18"],
//    ["Fred", "50", "20"],
//]
//
//printTable(data, withColumnLabels: "Employee Name", "Age", "Years of Experience")

// use model objects
struct Person {
    let name: String
    let age: Int
    let yearsOfExperience: Int
}

struct Department: TabularDataSource, CustomStringConvertible {
    let name: String
    var people = [Person]()
    
    var description: String {
        return "Department (\(name))"
    }
    
    init(name: String) {
        self.name = name
    }
    
    mutating func add (_ person: Person) {
        people.append(person)
    }
    
    var numberOfRows: Int {
        return 3
    }
    var numberOfColumns: Int {
        return 3
    }
    
    func label(forColumn column: Int) -> String {
        switch column {
        case 0: return "Employee Name"
        case 1: return "Age"
        case 2: return "Years of Experience"
        default: fatalError("Invalid column!")
        }
    }

    func itemFor(row: Int, column: Int) -> String {
        let person = people[row]
        switch column  {
        case 0: return person.name
        case 1: return String(person.age)
        case 2: return String(person.yearsOfExperience)
        default: fatalError("Invalid column!")
        }
    }
}

var department = Department(name: "Engineering")
department.add(Person(name: "Joe", age: 1000, yearsOfExperience: 6))
department.add(Person(name: "Karen", age: 40, yearsOfExperience: 18))
department.add(Person(name: "Fred", age: 50, yearsOfExperience: 20))

//current implementation to print a table could be used to print any kind of table data (rather than modifying the function to take a Department instead of the two arguments it takes now) and functionality can help preserve this functionality (see code above original function)

printTable(department)

// recall that methods on value types (structs and enums) can't modify self unless method is marked as mutating.  methods in protocols default to nonmutating.

// SILVER CHALLENGE: printTable(_:) function has a bug--crashes if any data longer than label of their column.  Change joe's age to 1000.  fix the bug.  for harder version, make all rows and columns still align correctly too.
// see above (line 52).  fixed bug, but made columns out of alignment



