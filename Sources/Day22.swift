import Algorithms
import Collections

private let modulo = 16777216

struct Day22: AdventDay {
    var data: String
    
    var entities: [Int] {
        data.split(separator: "\n").compactMap { Int($0) }
    }
    
    private func next(_ secret: Int) -> Int {
        var secret = secret
        
        secret = ((secret * 64) ^ secret)
        secret = secret % modulo
        
        secret = (Int(Double(secret) / 32) ^ secret)
        secret = secret % modulo
        
        secret = (secret * 2048 ^ secret)
        secret = secret % modulo
        
        return secret
    }
    
    func part1() -> Any {
        var secrets = entities
        
        for i in 0..<secrets.count {
            var secret = secrets[i]
            for _ in 0..<2000 {
                secret = next(secret)
            }
            secrets[i] = secret
        }
        return secrets.reduce(0, +)
    }
    
    func part2() -> Any {
        let secrets = entities
        var cache = [[String: Int]](repeating: [:], count: secrets.count)
        
        for i in 0..<secrets.count {
            var secret = secrets[i]
            var streak = [0, 0, 0, 0]
            for j in 0..<2000 {
                let new = next(secret)
                streak.swapAt(0, 1)
                streak.swapAt(1, 2)
                streak.swapAt(2, 3)
                let bananas = new % 10
                streak[3] = bananas - (secret % 10)
                let key = streak.map({ String($0) }).joined(separator: ",")
                if j > 3 {
                    cache[i][key] = cache[i][key] ?? bananas
                }
                secret = new
            }
        }
        var all = Set<String>()
        for i in 0..<secrets.count {
            all.formUnion(Set(cache[i].keys))
        }
        var record = 0
        for key in all {
            var candidate = 0
            for i in 0..<secrets.count {
                candidate += cache[i][key] ?? 0
            }
            record = max(record, candidate)
        }
        return record
    }
}
