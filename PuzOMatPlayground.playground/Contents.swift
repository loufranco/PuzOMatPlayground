//: Puz-o-Mat sample code

import UIKit

/// This is a mock button we'll use to hold our game state. In a real game, 
/// this would likely be a collection of components.
class Button: NSObject {
    let tapCount: Int

    init(tapCount: Int) {
        self.tapCount = tapCount
    }
}

/// These are the facts that can be asserted about our game. If no fact is asserted,
/// the game allows the user to keep playing. When they win, it moves on to the next
/// level. If they hit a reset, the buttons all go back to an initial state.
enum GameOutcome: NSString {
    case win
    case reset
}

/// Simple implementation of the level one evaluator. In this puzzle, you
/// need to tap each button once. If you tap any of them twice, it will reset.
/// When you tap all of them, you win.
func evaluateLevel001(buttons: [Button]) -> GameOutcome? {
    var foundUntappedButton = false

    for button in buttons {
        if button.tapCount >= 2 {
            return .reset
        }
        else if button.tapCount == 0 {
            foundUntappedButton = true
        }
    }

    if !foundUntappedButton {
        return .win
    }
    
    return nil
}

/// Test runs of level 1
evaluateLevel001(buttons: [Button(tapCount:2), Button(tapCount:1)])
evaluateLevel001(buttons: [Button(tapCount:1), Button(tapCount:1)])
evaluateLevel001(buttons: [Button(tapCount:0), Button(tapCount:1)])

/// In this puzzle, you need to tap each button in order.
func evaluateLevel002(buttons: [Button]) -> GameOutcome? {
    var foundUntappedButton = false

    for button in buttons {
        if button.tapCount >= 2 {
            return .reset
        }
        else if button.tapCount == 0 {
            foundUntappedButton = true
        }
        // This else-if is the only difference from 001
        else if button.tapCount == 1 && foundUntappedButton {
            return .reset
        }
    }

    if !foundUntappedButton {
        return .win
    }

    return nil
}

/// Test runs of level 2
evaluateLevel002(buttons: [Button(tapCount:2), Button(tapCount:1)])
evaluateLevel002(buttons: [Button(tapCount:1), Button(tapCount:1)])
evaluateLevel002(buttons: [Button(tapCount:0), Button(tapCount:1)])
evaluateLevel002(buttons: [Button(tapCount:1), Button(tapCount:0)])

/// In this puzzle, you need to tap each button in reverse order.
func evaluateLevel003(buttons: [Button]) -> GameOutcome? {
    var foundUntappedButton = false
    for button in buttons.reversed() { // .reversed() is the ony difference from 002
        if button.tapCount >= 2 {
            return .reset
        }
        else if button.tapCount == 0 {
            foundUntappedButton = true
        }
        else if button.tapCount == 1 && foundUntappedButton {
            return .reset
        }
    }
    if !foundUntappedButton {
        return .win
    }
    return nil
}

/// Test runs of level 3
evaluateLevel003(buttons: [Button(tapCount:2), Button(tapCount:1)])
evaluateLevel003(buttons: [Button(tapCount:1), Button(tapCount:1)])
evaluateLevel003(buttons: [Button(tapCount:0), Button(tapCount:1)])
evaluateLevel003(buttons: [Button(tapCount:1), Button(tapCount:0)])

/// Refactor the code above around "rules"

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

/// The same function in functional style
func evaluateFunctionalStyle(buttons: [Button], rules: [Rule]) -> GameOutcome? {
    return rules.reduce(nil, { (outcome, rule) in
        return outcome ?? rule(buttons)
    })
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
//    return evaluateFunctionalStyle(buttons: buttons, rules: rulesForLevel001())
}


evaluateLevel001WithRules(buttons: [Button(tapCount:2), Button(tapCount:1)])
evaluateLevel001WithRules(buttons: [Button(tapCount:1), Button(tapCount:1)])
evaluateLevel001WithRules(buttons: [Button(tapCount:0), Button(tapCount:1)])

/// Reimplement using GameplayKit
import GameplayKit

/// Basic usage of GKRuleSystem
func evaluate(state: [String: Any], rules: [GKRule]) -> GameOutcome? {
    let rs = GKRuleSystem()
    rs.add(rules)
    rs.state.addEntries(from: state)
    rs.evaluate()

    if rs.facts.count > 0, let fact = rs.facts[0] as? NSString {
        return  GameOutcome(rawValue: fact)
    }
    return nil
}

/// Using GKRule's init that takes blocks
func blockRulesForLevel001() -> [GKRule] {
    return [
        GKRule(blockPredicate: { rs in
            guard let buttons = rs.state["b"] as? [Button] else { return false }
            return (buttons.first { $0.tapCount >= 2 }) != nil
        }, action: { rs in
            rs.assertFact(GameOutcome.reset.rawValue)
        }),
        GKRule(blockPredicate: { rs in
            guard let buttons = rs.state["b"] as? [Button] else { return false }
            return (buttons.first { $0.tapCount != 1 }) == nil
        }, action: { rs in
            rs.assertFact(GameOutcome.win.rawValue)
        }),
    ]
}

evaluate(state: ["b": [Button(tapCount: 2), Button(tapCount: 1)]], rules: blockRulesForLevel001())
evaluate(state: ["b": [Button(tapCount: 1), Button(tapCount: 1)]], rules: blockRulesForLevel001())
evaluate(state: ["b": [Button(tapCount: 0), Button(tapCount: 1)]], rules: blockRulesForLevel001())

/// Add a function to GameOutcome to make GKRule construction easier
extension GameOutcome {
    func assertIf(_ predicateFormat: String) -> GKRule {
        return GKRule(predicate: NSPredicate(format: predicateFormat), assertingFact: self.rawValue, grade: 1.0)
    }
}

/// The GKRules using our GameOutcome predicate extension
func predicateRulesForLevel001() -> [GKRule] {
    return [
        GameOutcome.reset.assertIf("ANY $b.tapCount == 2"),
        GameOutcome.win.assertIf("ALL $b.tapCount == 1"),
    ]
}


evaluate(state: ["b": [Button(tapCount: 2), Button(tapCount: 1)]], rules: predicateRulesForLevel001())
evaluate(state: ["b": [Button(tapCount: 1), Button(tapCount: 1)]], rules: predicateRulesForLevel001())
evaluate(state: ["b": [Button(tapCount: 0), Button(tapCount: 1)]], rules: predicateRulesForLevel001())

