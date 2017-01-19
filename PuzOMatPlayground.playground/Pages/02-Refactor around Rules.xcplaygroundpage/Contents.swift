//: [Previous](@previous)
//: Refactor the simple code around "rules"

import UIKit

/// A Rule is a function that takes an array of buttons (the game state) and
/// returns a GameOutcome or nil if it can't determine one.
typealias Rule = (_: [Button]) -> GameOutcome?

/// - returns: a Rule that resets the game if the player taps any button maxTaps times.
func makeTapLimitRule(maxTaps: Int) -> Rule {
    return { buttons in
        if (buttons.first { $0.tapCount >= maxTaps }) != nil {
            return .reset
        }
        return nil
    }
}

/// - returns: a Rule that results in a win if the player taps each button once
func makeAllTappedRule() -> Rule {
    return { buttons in
        if (buttons.first { $0.tapCount != 1 }) == nil {
            return .win
        }
        return nil
    }
}

/// A generic evaluator that will take an array of rules and try each one. If any
/// of them return non-nil, it returns it. If all are nil, it returns nil
func evaluate(buttons: [Button], rules: [Rule]) -> GameOutcome? {
    for rule in rules {
        if let outcome = rule(buttons) {
            return outcome
        }
    }
    return nil
}

/// - returns: an array of rules to describe level one.
func rulesForLevel001() -> [Rule] {
    return [
        makeTapLimitRule(maxTaps: 2),
        makeAllTappedRule(),
    ]
}

func evaluateLevel001WithRules(buttons: [Button]) -> GameOutcome? {
    return evaluate(buttons: buttons, rules: rulesForLevel001())
}


evaluateLevel001WithRules(buttons: [Button(tapCount:2), Button(tapCount:1)])
evaluateLevel001WithRules(buttons: [Button(tapCount:1), Button(tapCount:1)])
evaluateLevel001WithRules(buttons: [Button(tapCount:0), Button(tapCount:1)])

//: [Next](@next)
