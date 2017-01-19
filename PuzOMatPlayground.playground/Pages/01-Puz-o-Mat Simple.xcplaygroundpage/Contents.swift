//: Puz-o-Mat sample code

import UIKit

// See PuzOMatCommon.swift for GameOutcome and Button

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

