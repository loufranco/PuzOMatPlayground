import Foundation


/// This is a mock button we'll use to hold our game state. In a real game,
/// this would likely be a collection of components.
public class Button: NSObject {
    public let tapCount: Int

    public init(tapCount: Int) {
        self.tapCount = tapCount
    }
}

/// These are the facts that can be asserted about our game. If no fact is asserted,
/// the game allows the user to keep playing. When they win, it moves on to the next
/// level. If they hit a reset, the buttons all go back to an initial state.
public enum GameOutcome: NSString {
    case win
    case reset
}
