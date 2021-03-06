import Foundation
var compScore = 0
var playerScore = 0
var state = false // false if alive, true if dead
var turn = 0 // k + 1 when Player's, k when Computer's, if k even 
var PlayerGridDisp = [
    ["  ", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j"],
    ["1 ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
    ["2 ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
    ["3 ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
    ["4 ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
    ["5 ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
    ["6 ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
    ["7 ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
    ["8 ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
    ["9 ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "],
    ["10", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "]
]
var PlayerGridHidden = PlayerGridDisp
var CompGridDisp = PlayerGridDisp
var CompGridHidden = PlayerGridDisp

func printGrid() {
  print("Player:")
  for row in 0..<11 { // print
    for col in 0..<11 {
      print(PlayerGridDisp[row][col], terminator: " ")
    }
    print()
  }
  print("Computer:")
  for row in 0..<11 { // print
    for col in 0..<11 {
      print(CompGridDisp[row][col], terminator: " ")
    }
    print()
  }  
}

func check(x : Int, y: Int, grid: [[String]]) -> Bool { // check other ships nearby
  if x < 1 || y < 1 || x > 10 || y > 10 {
    return false
  }
  for i in max(x - 1, 1)...min(x + 1, 10) {
    for j in max(y - 1, 1)...min(y + 1, 10) {
      if grid[j][i] == "#" {
        return false
      }
    }
  }
  return true
}

func place(l: Int, grid: inout [[String]]) { 
  let len = l - 1
  var ch: Bool = false
  while ch == false {
    let x = Int.random(in: 1...10) // coordinates
    let y = Int.random(in: 1...10)
    let dir = Int.random(in: 1...4) // direction 1 - left, 2 - up,  3 - right, 4 - down
    if dir == 1 {
        var b: Bool = true // check the cell 
        for i in 0...len {
          if !check(x: x - i, y: y, grid: grid){
            b = false
          }
        }
        if x - len < 1 || !b {
          continue
        }
        for i in 0...len {
          grid[y][x - i] = "#"
        }
    }
    else if dir == 2 {
      var b: Bool = true
        for i in 0...len {
          if !check(x: x, y: y - i, grid: grid){
            b = false
          }
        }
        if y - len < 1 || !b {
          continue
        }
      for i in 0...len {
        grid[y - i][x] = "#"
      }
    }
    else if dir == 3 {
      var b: Bool = true
        for i in 0...len {
          if !check(x: x + i, y: y, grid: grid){
            b = false
          }
        }
        if x + len > 10 || !b {
          continue
        }
      for i in 0...len {
        grid[y][x + i] = "#"
      }
    }
    else if dir == 4 {
      var b: Bool = true
        for i in 0...len {
          if !check(x: x, y: y + i, grid: grid){
            b = false
          }
        }
        if y + len > 10 || !b {
          continue
        }
      for i in 0...len {
        grid[y + i][x] = "#"
      }
    }
    ch = true;
  }
}

for i in 1...4 { // place all the ships on the grid
  for _ in 1...4-i+1 {
    place(l: i, grid: &PlayerGridDisp)
    place(l: i, grid: &CompGridHidden)
  }
}
func shoot (x: Int, y : Int, turn: inout Int)  {// turn = 1 - player, turn = 2 - computer 
    if x > 10 || x < 1 || y > 10 || y < 1{
      print("Out of range, please try again")
      turn -= 1;
      return
    }
  
    if (CompGridHidden[y][x] == "#") {
      CompGridDisp[y][x] = "@"
      CompGridHidden[y][x] = "@"
      ifSunk(x: x, y: y, grid: CompGridHidden, turn: turn)
      turn -= 1
    }
    else if CompGridHidden[y][x] == " " {
      CompGridDisp[y][x] = "*"
      CompGridHidden[y][x] = "*"
    } 
    else if CompGridHidden[y][x] == "*" || CompGridHidden[y][x] == "@" {
      print("You have shot in this place, try again")
      turn -= 1
    }
    else if CompGridHidden[y][x] == "X" {
      print("It is obvious there is not a bomb. Please try again")
      turn -= 1
    }
  
  //else if turn % 2 == 0 {
  //   if (PlayerGridDisp[y][x] == "#") {
  //     PlayerGridDisp[y][x] = "@"
  //     PlayerGridHidden[y][x] = "@"
  //     ifSunk(x: x, y: y, grid: PlayerGridDisp, turn: turn)
  //     turn -= 1
  //   }
  //   else if PlayerGridDisp[y][x] == " " {
  //     PlayerGridDisp[y][x] = "*"
  //     PlayerGridHidden[y][x] = "*"
  //   } 
  // }
}

func printTurn (_ turn: Int) {
  if turn % 2 == 1 {
    print("It is Player's turn. Please enter number and then letter with whitespace in between:")
  }
  else {
    // print("It is Computer's turn. Please enter number and then letter with whitespace in between:")
  }
}

func BFS(x: Int, y: Int, grid: [[String]], used: inout [[Bool]], state: inout Bool) {
  used[y][x] = true
  if x - 1 > 0 {
    if grid[y][x - 1] == "#" {
      state = true
      return
    }
    else if grid[y][x - 1] == "@" && !used[y][x - 1] {
      BFS(x: x - 1, y: y, grid: grid, used: &used, state: &state)
      if state {
        return
      }
    }
  } 
  if x + 1 < 11 {
    if grid[y][x + 1] == "#" {
      state = true
      return
    }
    else if grid[y][x + 1] == "@" && !used[y][x + 1] {
      BFS(x: x + 1, y: y, grid: grid, used: &used, state: &state)
      if state {
        return
      }
    }
  } 
  if y - 1 > 0 {
    if grid[y - 1][x] == "#" {
      state = true
      return
    }
    else if grid[y - 1][x] == "@" && !used[y - 1][x] {
      BFS(x: x, y: y - 1, grid: grid, used: &used, state: &state)
      if state {
        return
      }
    }
  } 
  if y + 1 < 11 {
    if grid[y + 1][x] == "#" {
      state = true
      return
    }
    else if grid[y + 1][x] == "@" && !used[y + 1][x] {
      BFS(x: x, y: y + 1, grid: grid, used: &used, state: &state)
      if state {
        return
      }
    }
  } 
}

func toXAround(x: Int, y: Int, grid: inout [[String]]) {
  if x - 1 > 0 {
    if grid[y][x - 1] == "*" || grid[y][x - 1] == " " {
      grid[y][x - 1] = "X"
    }
    if y - 1 > 0 {
      if grid[y - 1][x - 1] == "*" || grid[y - 1][x - 1] == " " {
        grid[y - 1][x - 1] = "X"
      }
    }
    if y + 1 < 11 {
      if grid[y + 1][x - 1] == "*" || grid[y + 1][x - 1] == " " {
        grid[y + 1][x - 1] = "X"
      }
    }
  }
  if y - 1 > 0 {
    if grid[y - 1][x] == "*" || grid[y - 1][x] == " " {
      grid[y - 1][x] = "X"
    }
  }
  if y + 1 < 11 {
    if grid[y + 1][x] == "*" || grid[y + 1][x] == " " {
      grid[y + 1][x] = "X"
    }
  }
  if x + 1 < 11 {
    if grid[y][x + 1] == "*" || grid[y][x + 1] == " " {
      grid[y][x + 1] = "X"
    }
    if y - 1 > 0 {
      if grid[y - 1][x + 1] == "*" || grid[y - 1][x + 1] == " " {
        grid[y - 1][x + 1] = "X"
      }
    }
    if y + 1 < 11 {
      if grid[y + 1][x + 1] == "*" || grid[y + 1][x + 1] == " " {
        grid[y + 1][x + 1] = "X"
      }
    }
  }
}

func bfsWhenSunk(x: Int, y: Int, used: inout [[Bool]], grid1: inout [[String]], grid2: inout [[String]]) {
  used[y][x] = true 
  toXAround(x: x, y: y, grid: &grid1)
  toXAround(x: x, y: y, grid: &grid2)
  if x - 1 > 0 {
    if grid1[y][x - 1] == "@" && !used[y][x - 1] {
      toXAround(x: x - 1, y: y, grid: &grid1)
      toXAround(x: x - 1, y: y, grid: &grid2)
      bfsWhenSunk(x: x - 1, y: y, used: &used, grid1: &grid1, grid2: &grid2)
    }
  } 
  if x + 1 < 11 {
    if grid1[y][x + 1] == "@" && !used[y][x + 1] {
      toXAround(x: x + 1, y: y, grid: &grid1)
      toXAround(x: x + 1, y: y, grid: &grid2)
      bfsWhenSunk(x: x + 1, y: y, used: &used, grid1: &grid1, grid2: &grid2)
    }
  } 
  if y - 1 > 0 {
    if grid1[y - 1][x] == "@" && !used[y - 1][x] {
      toXAround(x: x, y: y - 1, grid: &grid1)
      toXAround(x: x, y: y - 1, grid: &grid2)
      bfsWhenSunk(x: x, y: y - 1, used: &used, grid1: &grid1, grid2: &grid2)
    }
  } 
  if y + 1 < 11 {
    if grid1[y + 1][x] == "@" && !used[y + 1][x] {
      toXAround(x: x, y: y + 1, grid: &grid1)
      toXAround(x: x, y: y + 1, grid: &grid2)
      bfsWhenSunk(x: x, y: y + 1, used: &used, grid1: &grid1, grid2: &grid2)
    }
  } 
}

func ifSunk(x: Int, y: Int, grid: [[String]], turn: Int) {
  var used: [[Bool]] = [[Bool]](repeating: [Bool](repeating: false, count: 15), count: 15)
  state = false
  BFS(x: x, y: y, grid: grid, used: &used, state: &state)
  if state == false {
    var used1: [[Bool]] = [[Bool]](repeating: [Bool](repeating: false, count: 15), count: 15)
    if turn % 2 == 1 {
      playerScore += 1
      bfsWhenSunk(x: x, y: y, used: &used1, grid1: &CompGridDisp, grid2: &CompGridHidden)
    } else {
      compScore += 1
      bfsWhenSunk(x: x, y: y, used: &used1, grid1: &PlayerGridDisp, grid2: &PlayerGridHidden)
    }
  }
}
var reading = false

func readInt(x: inout Int, y: inout Int) {
  if let a = readLine() { 
    if a.contains("  ") || a.contains("   ") || a.contains("    ") || a.contains("     ") {
      print ("invalid coordinates, please try again: ")
      return
    }
    let fullLine = a.components(separatedBy: " ") 
    if let int = Int(fullLine[0]) {
      y = int 
      if Int(Character(fullLine[1]).asciiValue!) - 64 > 10 {
        x = Int(Character(fullLine[1]).asciiValue!) - 96
      }
      else {
        x = Int(Character(fullLine[1]).asciiValue!) - 64
      }
      reading = true
      // print ("x = \(x). y = \(y)")
    }
    else {
      print ("invalid coordinates, please try again: ")
    }
  }
}

func compGoes() {
  var x = 0
  var y = 0
  while true {
    x = Int.random(in: 1...10) // coordinates
    y = Int.random(in: 1...10)
    if (PlayerGridHidden[y][x] == "X" || PlayerGridHidden[y][x] == "*" || PlayerGridHidden[y][x] == "@") {
      continue
    } else {
      break
    }
  }
  if (PlayerGridDisp[y][x] == "#") {
    PlayerGridDisp[y][x] = "@"
    PlayerGridHidden[y][x] = "@"
    ifSunk(x: x, y: y, grid: PlayerGridDisp, turn: turn)
    turn -= 1
  }
  else if PlayerGridDisp[y][x] == " " {
    PlayerGridDisp[y][x] = "*"
    PlayerGridHidden[y][x] = "*"
  } 
}

while true {
  printGrid();
  turn += 1
  printTurn(turn)
  var x = 0
  var y = 0
  reading = false
  
  if turn % 2 == 1 {
    while (!reading) {
    readInt(x: &x, y: &y)
  }
    shoot (x: x, y: y, turn: &turn)
  }
  else {
    print("It's the Computer's turn ")
    compGoes()
  }
  if playerScore == 10 {
    printGrid();
    print("Player wins!")
    break
  }
  if compScore == 10 {
    printGrid();
    print("Computer wins!")
    break
  }
}