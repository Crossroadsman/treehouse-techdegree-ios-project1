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

/**
 returns the sum of the heights of the players
 */
func getHeights(ofPlayers players: [[String:Any]]) -> Int {
    var totalSoFar = 0
    for player in players {
        totalSoFar += player["Height"]! as! Int
    }
    return totalSoFar
}

/**
 returns the index of the team with the lowest total height.
 */
func getLowestHeightTeam( teams: [ [[String:Any]] ]) -> Int {
    var lowestValueSoFar: Int?
    var lowestIndexSoFar = 0
    
    for (index, team) in teams.enumerated() {
        let teamHeight = getHeights(ofPlayers: team)
        if lowestValueSoFar == nil || teamHeight < lowestValueSoFar! {
            lowestValueSoFar = teamHeight
            lowestIndexSoFar = index
        }
    }
    return lowestIndexSoFar
}
 

/**
 Note that binning/packing problems, of the sort described here are NP-hard
 A simple 'good enough' method (similar to the LPT algorithm for multiprocessor scheduling) is to sort by value being binned (height)
 Then starting with the largest value, place it into the emptiest available bin
 (where, in this case, emptiest takes account of the fact that only [# total experienced players / 3] experienced players
 and [# total inexperienced players / 3] inexperienced players
 are permitted in each bin.
 - Parameter players: The player list (array of [String:Any]). Each player entity comprises:
 Name: String
 Height: Int
 Experience: Bool
 Guardians: [String]
 - Parameter teamsCount: The number of teams over which to assign the players. Assumed to be a factor of the total number of players.
 - Returns: An array of player arrays representing teams (e.g., [dragons, sharks, raptors]).
 */
func assign(players: [[String:Any]], teamsCount: Int) -> [[[String:Any]]] {
    
    var teams = [ [[String:Any]] ]()
    for _ in 0 ..< teamsCount {
        teams.append( [[String:Any]]())
    }
    
    // IMPORTANT:
    // we are making a couple of assumptions for this exercise:
    // the number of total players will always be a multiple of the number of teams
    // the number of experienced players will always be a multiple of the number of teams
    let maxPlayersInTeam = players.count / teamsCount
    
    var totalExperiencedPlayers = 0
    for player in players {
        if isExperienced(player) {
            totalExperiencedPlayers += 1
        }
    }
    
    let maxExperiencedInTeam = totalExperiencedPlayers / teamsCount
    let maxInexperiencedInTeam = maxPlayersInTeam - maxExperiencedInTeam
    
    // sort ascending
    var sortedPlayers = badSort(arr: players, key: "Height")
    
    // repeat
    while sortedPlayers.count > 0 {
        
        /*
        //debug
        print("--- Sorted Players ---")
        print(sortedPlayers)
        print("--- End Sorted Players ---")
        //end debug
         */
 
        // pop the last element
        let last = sortedPlayers.removeLast()
        /*
        //debug
        print("popping last: \(last)")
        //end debug
         */
        
        // which bin has the lowest total AND can take an element of this type
        // add to that bin
        var allocated = false
        
        var tempTeamsForAllocation = teams
        while !allocated {
            
            if tempTeamsForAllocation.count == 0 {
                fatalError()
            }
            
            let index = getLowestHeightTeam(teams: tempTeamsForAllocation)
            //debug:
            /*
            for (index, team) in teams.enumerated() {
                print("team: \(index)")
                print(team)
                print("sum of heights: ")
                print(getHeights(ofPlayers: team))
            }
            print("index of team with lowest total height: \(index)")
             */
            //end debug
            
            if last["Experience"]! as! Bool {
                if remainingExperienced(players: teams[index], totalPermitted: maxExperiencedInTeam) > 0 {
                    teams[index].append(last)
                    tempTeamsForAllocation = teams
                    allocated = true
                } else {
                    tempTeamsForAllocation.remove(at: index)
                }
            } else {
                // inexperienced
                if remainingInexperienced(players: teams[index], totalPermitted: maxInexperiencedInTeam) > 0 {
                    teams[index].append(last)
                    tempTeamsForAllocation = teams
                    allocated = true
                } else {
                    tempTeamsForAllocation.remove(at: index)
                }
            }
            
        }
        
        
    }
    
    return teams
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

let assignedTeams = assign(players: players, teamsCount: 3)
