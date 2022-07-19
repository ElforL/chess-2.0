import '../board.dart';
import '../spot.dart';
import 'piece.dart';

class Rook extends ChessPiece {
  Rook(super.coordinates, super.side) : assert(side != Side.neutral);

  @override
  bool isValidNewSpot(SpotCoordinates coordinates) => !coordinates.isJailSpot;

  @override
  bool isLegalMove(SpotCoordinates coordinates, ChessBoard board) {
    if (!isValidNewSpot(coordinates)) return false;

    var endSpot = board.getSpotFromCoords(coordinates);
    if (endSpot.isJailCell) return false;

    final isSpotEmpty = !endSpot.hasPiece;

    if (isSpotEmpty) {
      // Not killing any piece
      return true;
    } else {
      // Killing/taking

      if (endSpot.piece!.side == side) {
        // Can't kill teammate
        return false;
      }

      // Check if opponent killed in previous turn
      bool canKill;
      switch (side) {
        case Side.white:
          canKill = board.didBlackKill;
          break;
        case Side.black:
          canKill = board.didWhiteKill;
          break;
        case Side.neutral:
          // Impossible but just to shut the linter up.
          canKill = false;
      }

      return canKill;
    }
  }
}
