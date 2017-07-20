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
 Extracts the experienced players from an array of players
 */
func getExperienced(players: [[String:Any]]) -> [[String:Any]] {
    var outputArray = [[String:Any]]()
    for player in players {
        if isExperienced(player) {
            outputArray.append(player)
        }
    }
    return outputArray
}

/**
 Extracts the inexperienced players from an array of players
 */
func getInexperienced(players: [[String:Any]]) -> [[String:Any]] {
    var outputArray = [[String:Any]]()
    for player in players {
        if !isExperienced(player) {
            outputArray.append(player)
        }
    }
    return outputArray
}

/**
 Simple Assign
 */
func simpleAssign(players: [[String:Any]], teamsCount: Int) -> [[[String:Any]]] {
    
    var teams = [ [[String:Any]] ]()
    for _ in 0 ..< teamsCount {
        teams.append( [[String:Any]]())
    }
    
    // IMPORTANT:
    // we are making a couple of assumptions for this exercise:
    // the number of total players will always be a multiple of the number of teams
    // the number of experienced players will always be a multiple of the number of teams
    let maxPlayersInTeam = players.count / teamsCount
    
    let experiencedPlayers = getExperienced(players: players)
    let inexperiencedPlayers = getInexperienced(players: players)
    
    let maxExperiencedInTeam = experiencedPlayers.count / teamsCount
    let maxInexperiencedInTeam = maxPlayersInTeam - maxExperiencedInTeam
    
    
    var unallocatedExperiencedPlayers = experiencedPlayers
    var unallocatedInexperiencedPlayers = inexperiencedPlayers
    
    while unallocatedExperiencedPlayers.count > 0 {
        let last = unallocatedExperiencedPlayers.removeLast()
        for i in 0 ..< teams.count {
            if remainingExperienced(players: teams[i], totalPermitted: maxExperiencedInTeam) > 0 {
                teams[i].append(last)
                break
            }
        }
    }
    
    while unallocatedInexperiencedPlayers.count > 0 {
        let last = unallocatedInexperiencedPlayers.removeLast()
        for i in 0 ..< teams.count {
            if remainingInexperienced(players: teams[i], totalPermitted: maxInexperiencedInTeam) > 0 {
                teams[i].append(last)
                break
            }
        }
    }
    
    return teams
}


/**
 Write a letter to guardians
 */
func writeLetters(toGuardiansOfTeams teams: [[[String:Any]]], withNames teamNames: [String], andSchedule schedule: [String:String]) -> [String] {
    
    var letters = [String]()
    for (index, team) in teams.enumerated() {
        
        for player in team {
            
            for guardian in (player["Guardians"]! as! [String]) {
                
                letters.append("Dear \(guardian),\nThank you for registering for this season's youth soccer league.\nPlease be advised that your child, \(player["Name"]! as! String), has been assigned to Team \(teamNames[index]).\n\(player["Name"]! as! String)'s first practice will be held at the town youth center at the following date and time: \(schedule[teamNames[index]]!).\nWe look forward to seeing you.\nKind regards,\n\nTown Youth Soccer League Coordinator\n")
                
            }
            
        }
        
    }
    return letters
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
    
    let experiencedPlayers = getExperienced(players: players)
    let totalExperiencedPlayers = experiencedPlayers.count
    
    let maxExperiencedInTeam = totalExperiencedPlayers / teamsCount
    let maxInexperiencedInTeam = maxPlayersInTeam - maxExperiencedInTeam
    
    // sort ascending
    var sortedPlayers = badSort(arr: players, key: "Height")
    
    // repeat
    while sortedPlayers.count > 0 {
        
        // pop the last element
        let last = sortedPlayers.removeLast()
        
        // which bin has the lowest total AND can take an element of this type
        // add to that bin
        var allocated = false
        
        var tempTeamsForAllocation = teams
        while !allocated {
            
            if tempTeamsForAllocation.count == 0 {
                fatalError()
            }
            
            let index = getLowestHeightTeam(teams: tempTeamsForAllocation)
            
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
//MARK: - ** PART 1 **
// Manually create a single collection named 'players' that contains all information for all 18 players. Each player must themselves be represented by a Dictionary with String keys and the corresponding values
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

let practiceDates = [
    "Dragons" : "March 17, 1pm",
    "Sharks" : "March 17, 3pm",
    "Raptors" : "March 18, 1pm"
]

//MARK: - ** PART 2 **
//--------------------
//Create appropriate variables and logic to sort and store players into three teams: Sharks, Dragons and Raptors. Store the players for each team in collection variables named 'teamSharks', 'teamDragons', and 'teamRaptors'. Be sure that your logic results in all teams having the same number of experienced players on each

let teamNames = ["Sharks", "Dragons", "Raptors"]

var teams = simpleAssign(players: players, teamsCount: teamNames.count)

var teamSharks = teams[0]
var teamDragons = teams[1]
var teamRaptors = teams[2]

// tests (uncomment to run tests):
/*
teamSharks.count == teamDragons.count
teamDragons.count == teamRaptors.count

getExperienced(players: teamSharks).count == getExperienced(players: teamDragons).count
getExperienced(players: teamDragons).count == getExperienced(players: teamRaptors).count
*/

//MARK - ** PART 2 ** (Exceeds expectations variant)
//--------------------------------------------------
//As previous section but also ensures that each team's average player height is within 1.5"

teams = assign(players: players, teamsCount: [teamSharks, teamDragons, teamRaptors].count)

(teamSharks, teamDragons, teamRaptors) = (teams[0], teams[1], teams[2])

// tests (uncomment to run tests):
/*
teamSharks.count == teamDragons.count
teamDragons.count == teamRaptors.count

getExperienced(players: teamSharks).count == getExperienced(players: teamDragons).count
getExperienced(players: teamDragons).count == getExperienced(players: teamRaptors).count

let totalSharksHeights = getHeights(ofPlayers: teamSharks)
let totalDragonsHeights = getHeights(ofPlayers: teamDragons)
let totalRaptorsHeights = getHeights(ofPlayers: teamRaptors)

let averageSharksHeights = Double(totalSharksHeights) / Double(teamSharks.count)
let averageDragonsHeights = Double(totalDragonsHeights) / Double(teamDragons.count)
let averageRaptorsHeights = Double(totalRaptorsHeights) / Double(teamRaptors.count)

[averageSharksHeights, averageDragonsHeights, averageRaptorsHeights].max()! - [averageSharksHeights, averageDragonsHeights, averageRaptorsHeights].min()! < 1.5
 */
 
 
//MARK - ** PART 3 ** (Using Exceeds expectations version)
//--------------------------------------------------------
//Provide logic that prints a personalized letter to each of the guardians specifying:
//- the player's name
//- the guardian's name
//- the team name
//- date/time of first practice
//
//Letter must be stored in a collection variable named 'letters'.
//When code is run, the letters should be printed in the console.
let letters = writeLetters(toGuardiansOfTeams: [teamSharks, teamDragons, teamRaptors], withNames: teamNames, andSchedule: practiceDates)
for letter in letters {
    print(letter)
}


//test of variable names (uncomment to test):
/*
//part1
players
//part2
teamSharks
teamDragons
teamRaptors
//part3
letters
*/
 
