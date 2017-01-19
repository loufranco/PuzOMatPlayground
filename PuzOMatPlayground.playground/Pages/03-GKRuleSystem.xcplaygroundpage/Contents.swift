//: [Previous](@previous)

import Foundation
import UIKit
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

func evaluateLevel001WithPredicateRules(buttons: [Button]) -> GameOutcome? {
    return evaluate(state: ["b": buttons], rules: predicateRulesForLevel001())
}

evaluateLevel001WithPredicateRules(buttons: [Button(tapCount: 2), Button(tapCount: 1)])
evaluateLevel001WithPredicateRules(buttons: [Button(tapCount: 1), Button(tapCount: 1)])
evaluateLevel001WithPredicateRules(buttons: [Button(tapCount: 0), Button(tapCount: 1)])


