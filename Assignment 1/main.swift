//
//  main.swift
//  Assignment 1
//
//  Created by Nicholas Tofani on 9/7/18.
//  Copyright © 2018 Nicholas Tofani. All rights reserved.
//

import Foundation

//Used to a see if the line contains any variable declarations in Pep9
//  If it does, the func will return true
//  if not, the func will return false
func lineHasVariableDeclaration(line: String) -> Bool {
    let lowerCaseLine = line.lowercased()
    if ( (lowerCaseLine.range(of: ".ascii")) != nil ||
        (lowerCaseLine.range(of: ".block")) != nil ||
        (lowerCaseLine.range(of: ".equate")) != nil ||
        (lowerCaseLine.range(of: ".word") != nil) )
    {
        return true
    }
    return false
}

//**********************************
//Begining of Program

//Will hold the strings of the file specified by the user
var contents:NSString?

//Keep iterating until the user enters a valid file path
while(contents == nil) {
    print("What is the path of the pep or txt file? Or if you want to quit type 'exit'")
    let path = readLine()
    
    //Checks to see if user killed the program
    if(path == "exit") {
        exit(0)
    }
    //Places files strings into contents if the file path is valid
    contents = try? NSString(contentsOfFile: path!,encoding: String.Encoding.ascii.rawValue)
    if(contents == nil) {
        print("Invalid path... Please try again")
    }
}

//key == variable name;  Value == line #s of where that variable appears
var varLocations = [String : [Int]]()

//Loop through all lines of file
contents!.enumerateLines({ (line, _) -> () in
    if (lineHasVariableDeclaration(line: line)) {
        var variableName = ""
        
        //pull variable name from file, 1 char at a time
        for c in line {
            if(c != ":" && c != " ") {
                variableName.append(c)
            }
            else {
                //kill for loop (can't have multiple conditions in for loop in swift)
                break
            }
        }
        //make sure the variable name isn't empty
        if(variableName != "") {
            varLocations[variableName] = []
        }
    }
})

var lineCount = 1
//Loop through all lines of file
contents!.enumerateLines({ (line, _) -> () in
    //check if any variable is in line
    for vars in varLocations {
        if (line.contains(vars.key)) {
            varLocations[vars.key]?.append(lineCount)
        }
    }
    lineCount += 1
})

//Print results of program
for vars in varLocations {
    print(vars.key + ": ", terminator: "")
    for spots in vars.value {
        print(spots.description + ", ", terminator: "")
    }
    print("")
}


