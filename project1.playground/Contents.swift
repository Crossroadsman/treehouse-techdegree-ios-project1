import Foundation

//MARK: - Project Background and Notes
//------------------------------------

// Permitted language features:
// ----------------------------
// 1
// - Basic Types

// 2
// - Arrays
// - Dictionaries
// - Loops
// - If and Switch

// 3
// - Functions

// Soccer League Coordinator

// Need to divide the 18 children who have signed up for the league into three even teams: Dragons, Sharks, Raptors.

// Each child has the following information: Name, height (in inches), whether they have played soccer before, guardians' names.

// Using Any here seems like a major smell, but without being able to use advanced types, it's not obvious that there is a better way
let testPerson: [String:Any] = ["Name": "test", "Height": 66, "playedBefore": false, "guardians": ["mother", "father"]]

// Permitted tools:
// Native types and collections,
// Accessing, appending, counting Arrays
// Accessing dictionaries/arrays
// Creating control flow
// Use of comparison operators
// String interpolation
// use of comments


//MARK: - Helper Functions
//------------------------

/**
 BadSort
 A very bad sorting algorithm (O(n^2), doesn't handle certain edge cases) but easy to implement using the permitted language features. And none of the failing edge cases (e.g., negative values) are valid inputs in this project
 */
func badSort(arr: [[String: Any]], key: String) -> [[String: Any]] {
    var oldArr = arr
    var newArr = [[String:Any]]()
    
    var smallestSoFarValue = oldArr[0]
    var smallestSoFarIndex = 0
    
    while oldArr.count > 0 {
        for i in 0 ..< oldArr.count {
            if (oldArr[i][key]! as! Int) < (smallestSoFarValue[key]! as! Int) {
                smallestSoFarValue = oldArr[i]
                smallestSoFarIndex = i
            }
        }
        newArr.append(smallestSoFarValue)
        oldArr.remove(at: smallestSoFarIndex)
        if oldArr.count > 0 {
            smallestSoFarValue = oldArr[0]
            smallestSoFarIndex = 0
        }
    }
    
    return newArr
}

/**
 Prints a table of players to check that manually-entered data corresponds to spreadsheet
 */
func describe(players: [[String:Any]]) {
    print("Name | Height | Experience | Guardian(s)")
    print("----------------------------------------")
    for player in players {
        print("\(player["Name"]!)\t\t\(player["Height"]!)\t\(player["Experience"]! as! Bool ? "YES" : "NO")\t\(player["Guardians"]!)")
    }
}

/**
 Quick and dirty function to return true if a specified player is experienced and false otherwise.
 */
func isExperienced(_ player: [String:Any]) -> Bool {
    if player["Experience"]! as! Bool {
        return true
    } else {
        return false
    }
}

/**
 counts the number of unoccupied experienced player slots remaining for a given team
 */
func remainingExperienced(players: [[String:Any]], totalPermitted: Int) -> Int {
    var experiencedPlayers = 0
    for player in players {
        if isExperienced(player) {
            experiencedPlayers += 1
        }
    }
    return totalPermitted - experiencedPlayers
}

/**
 counts the number of unoccupied inexperienced player slots remaining for a given team
 */
func remainingInexperienced(players: [[String:Any]], totalPermitted: Int) -> Int {
    var inexperiencedPlayers = 0
    for player in players {
        if !isExperienced(player) {
            inexperiencedPlayers += 1
        }
    }
    return totalPermitted - inexperiencedPlayers
}


// Note that binning problems, of the sort described here are NP-hard
// A simple 'good enough' method is to sort by value being binned (height)
// Then starting with the largest value, place it into the emptiest available bin
// (where, in this case, emptiest takes account of the fact that only [# total experienced players / 3] experienced players
// and [# total inexperienced players / 3] inexperienced players
// are permitted in each bin.



/**
 The binning process is a variant of packing problems, which are NP-hard. This uses a common approach, similar to the LPT algorithm for multiprocessor scheduling.
 */
func assign(players: [[String:Any]]) -> ([[String:Any]],[[String:Any]],[[String:Any]]) {
    
    // sort ascending
    // pop the last element
    // which bin has the lowest total AND can take an element of this type
    // add to that bin
    // repeat
    var sortedPlayers = badSort(arr: players, key: "Height")
    let last = sortedPlayers.removeLast()
    return (sortedPlayers, sortedPlayers, sortedPlayers)
}

//MARK: - Variables
//-----------------
let players: [[String:Any]] = [
    ["Name": "Joe Smith", "Height": 42, "Experience": true, "Guardians": ["Jim Smith", "Jan Smith"]],
    ["Name": "Jill Tanner", "Height": 36, "Experience": true, "Guardians": ["Clara Tanner"]],
    ["Name": "Bill Bon", "Height": 43, "Experience": true, "Guardians": ["Sara Bon", "Jenny Bon"]],
    ["Name": "Eva Gordon", "Height": 45, "Experience": false, "Guardians": ["Wendy Gordon", "Mike Gordon"]],
    ["Name": "Matt Gill", "Height": 40, "Experience": false, "Guardians": ["Charles Gill", "Sylvia Gill"]],
    ["Name": "Kimmy Stein", "Height": 41, "Experience": false, "Guardians": ["Bill Stein", "Hillary Stein"]],
    ["Name": "Sammy Adams", "Height": 45, "Experience": false, "Guardians": ["Jeff Adams"]],
    ["Name": "Karl Saygan", "Height": 42, "Experience": true, "Guardians": ["Heather Bledsoe"]],
    ["Name": "Suzane Greenberg", "Height": 44, "Experience": true, "Guardians": ["Henrietta Dumas"]],
    ["Name": "Sal Dali", "Height": 41, "Experience": false, "Guardians": ["Gala Dali"]],
    ["Name": "Joe Kavalier", "Height": 39, "Experience": false, "Guardians": ["Sam Kavalier", "Elaine Kavalier"]],
    ["Name": "Ben Finkelstein", "Height": 44, "Experience": false, "Guardians": ["Aaron Finkelstein", "Jill Finkelstein"]],
    ["Name": "Diego Soto", "Height": 41, "Experience": true, "Guardians": ["Robin Soto", "Sarika Soto"]],
    ["Name": "Chloe Alaska", "Height": 47, "Experience": false, "Guardians": ["David Alaska", "Jamie Alaska"]],
    ["Name": "Arnold Willis", "Height": 43, "Experience": false, "Guardians": ["Claire Willis"]],
    ["Name": "Phillip Helm", "Height": 44, "Experience": true, "Guardians": ["Thomas Helm", "Eva Jones"]],
    ["Name": "Les Clay", "Height": 42, "Experience": true, "Guardians": ["Wynonna Brown"]],
    ["Name": "Herschel Krustofski", "Height": 45, "Experience": true, "Guardians": ["Hyman Krustofski", "Rachel Krustofski"]]
]



