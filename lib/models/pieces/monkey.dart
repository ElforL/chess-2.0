import '../board.dart';
import '../spot.dart';
import 'king.dart';
import 'piece.dart';

/// ## Moving
/// The monkey can move 1 spot in any direction **without killing**.
/// But can also jump over pieces adjacent to it.
class Monkey extends ChessPiece {
  Monkey(super.coordinates, super.side);

  /// When the monkey saves the king, it'll hold him until the next move.
  King? heldKing;
  bool get isHoldingKing => heldKing != null;

  @override
  bool isLegalMove(SpotCoordinates coordinates, ChessBoard board) {
    if (!isValidNewSpot(coordinates)) return false;
    final endSpot = board.getSpotFromCoords(coordinates);

    if (endSpot.isJailCell) {
      final nearJail = board.isSpotNextToEnemyJail(this.coordinates, side);
      // Return `false` if monkey is not next to the enemy's jail spots.
      // or if he's next to the other jail spot.
      if (!nearJail || y != coordinates.y) return false;

      if (endSpot.piece is! King) return false;
      final king = endSpot.piece as King;
      if (!king.hasBanana) return false;

      return _checkForEscapeSpot(board);
    }

    // No teamkill
    if (endSpot.piece?.side == side) return false;

    final dX = (coordinates.x - x).abs();
    final dY = (coordinates.y - y).abs();

    // 1 step move;
    if ((dX == 1 || dY == 1) && !endSpot.hasPiece) {
      return true;
    }

    // Jump move
    return _canJumpToCoordinates(coordinates, board);
  }

  @override
  bool isValidNewSpot(SpotCoordinates coordinates) {
    /// The monkey can move 1 spot in any direction **without killing**.
    /// But can also jump over pieces adjacent to it.
    /// So a valid spot is 1 or 2 straight steps in any direction.

    // Saving the king
    if (coordinates.isJailSpot) return true;

    // Difference in x and y
    final dX = (coordinates.x - x).abs();
    final dY = (coordinates.y - y).abs();

    if (dX * dY == 0) {
      // the change is vertical or horizontal (only one axis changed)
      // return `true` if the diff is 1 or 2
      return dX == 2 || dX == 1 || dY == 2 || dY == 1;
    }

    /// is the change in x within 0 - 2
    final xInRange = dX <= 2 && dX >= 0;

    // return true if both changes are equal (i.e., the change is diagonal)
    // and the change is between 0 or 2
    return dX == dY && xInRange;
  }

  /// Returns `true` if there is a middle piece between current position and [coordinates].
  ///
  /// Returns `false` if [coordinates] are not 2 straight steps from current position (i.e., `dX != 2 && dY != 2`).
  bool _canJumpToCoordinates(SpotCoordinates coordinates, ChessBoard board) {
    final dX = (coordinates.x - x).abs();
    final dY = (coordinates.y - y).abs();

    if (dX != 2 && dY != 2) return false;

    /// The coords of the spot in between current spot and endSpot (The spot the monkey is jumping over).
    SpotCoordinates middleSpotCoordinates;
    if (dX == dY) {
      // Diagonal
      middleSpotCoordinates = SpotCoordinates(
        coordinates.x > x ? x + 1 : x - 1,
        coordinates.y > y ? y + 1 : y - 1,
      );
    } else if (dX == 0) {
      // Vertical
      middleSpotCoordinates = SpotCoordinates(
        x,
        coordinates.y > y ? y + 1 : y - 1,
      );
    } else if (dY == 0) {
      // Horizontal
      middleSpotCoordinates = SpotCoordinates(
        coordinates.x > x ? x + 1 : x - 1,
        y,
      );
    } else {
      return false;
    }

    final middleSpot = board.getSpotFromCoords(middleSpotCoordinates);
    return middleSpot.hasPiece;
  }

  /// Goes for a loop between all possible jumping locations and passes them to [_canJumpToCoordinates].
  /// Returns `true` once one of them return `true`.
  bool _checkForEscapeSpot(ChessBoard board) {
    for (var dy = -2; dy <= 2; dy += 2) {
      for (var dx = -2; dx <= 2; dx += 2) {
        if (dy == 0 && dx == 0) continue;

        final spotCoordinates = SpotCoordinates(
          x + dx,
          y + dy,
        );

        try {
          final canJump = _canJumpToCoordinates(spotCoordinates, board);
          if (canJump) return true;
        } on RangeError catch (_) {
          // Skip if the spot is out of range.
          continue;
        }
      }
    }
    return false;
  }
}
