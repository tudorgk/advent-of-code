import Foundation

enum Command {
    case forward
    case down
    case up
}

let filePath = Bundle.main.path(forResource: "input", ofType: "txt")!
let text = try! String(contentsOfFile: filePath)
let lines : [(Command, Int)] = text.components(separatedBy: "\n").filter { string in
    !string.isEmpty
}.map { (string) -> (Command, Int) in
    let commandArray = string.split(separator: " ")
    let command: Command
    switch commandArray[0] {
    case "forward":
        command = .forward
    case "down":
        command = .down
    case "up":
        command = .up
    default:
        command = .forward
    }
    return (command, Int(commandArray[1]) ?? 0)
}

var horizontalPosition = 0
var depthPositon = 0

for command in lines {
    switch command {
    case (.forward, let value):
        horizontalPosition += value
    case (.down, let value):
        depthPositon += value
    case (.up, let value):
        depthPositon -= value
    }
}

debugPrint(horizontalPosition * depthPositon)

horizontalPosition = 0
depthPositon = 0
var aim = 0

for command in lines {
    switch command {
    case (.forward, let value):
        horizontalPosition += value
        depthPositon += value * aim
    case (.down, let value):
        aim += value
    case (.up, let value):
        aim -= value
    }
}

debugPrint(horizontalPosition * depthPositon)
