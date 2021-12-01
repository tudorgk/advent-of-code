import Cocoa
import Combine

let filePath = Bundle.main.path(forResource: "input", ofType: "txt")!
let text = try! String(contentsOfFile: filePath)
let lines : [Int] = text.components(separatedBy: "\n").filter { string in
    !string.isEmpty
}.map { (string) -> Int in
    return Int(string) ?? 0
}

var lastDepthReading: Int?
var increased = 0

for line in lines {
    if let last = lastDepthReading {
        if line > last {
            increased += 1
        }
    }
    lastDepthReading = line

}

extension Publisher {
    func sliding(window: Int) -> AnyPublisher<[Output], Failure> {
        if window < 1 { return Empty().eraseToAnyPublisher() }
        return self
           .scan([], { arr, value in
               if arr.count < window {
                   return arr + [value]
               } else {
                   return arr.dropFirst() + [value]
               }
           })
           .dropFirst(window - 1)
           .eraseToAnyPublisher()
   }
}

lastDepthReading = nil
increased = 0

lines.publisher
    .sliding(window: 3)
    .map({ sequence in
//        debugPrint(sequence)
        return sequence.reduce(0, +)
    })
    .sink {
        if let last = lastDepthReading {
            if $0 > last {
                increased += 1
            }
        }
        lastDepthReading = $0
    }

debugPrint(increased)
