import '../board.dart';
import '../spot.dart';
import 'piece.dart';

class Fish extends ChessPiece {
  Fish(super.coordinates, super.side);

  @override
  bool isLegalMove(SpotCoordinates coordinates, ChessBoard board) {
    if (!isValidNewSpot(coordinates)) return false;
    final endSpot = board.getSpotFromCoords(coordinates);

    // Can't go to jail cell
    if (endSpot.isJailCell) return false;
    // No teamkill
    if (endSpot.piece?.side == side) return false;

    if (endSpot.hasPiece) {
      // If end spot has an enemy,
      // it must be a diagonal move to kill.
      final xDiff = (coordinates.x - x).abs();
      final yDiff = (coordinates.y - y).abs();

      return xDiff == yDiff && xDiff == 1;
    } else {
      return true;
    }
  }

  @override
  bool isValidNewSpot(SpotCoordinates coordinates) {
    if (coordinates == this.coordinates) return false;
    final xDiff = coordinates.x - x;
    final yDiff = coordinates.y - y;

    if (xDiff.abs() > 1) return false;
    if (yDiff.abs() > 1) return false;

    // a fish can't go backwards
    // for white going backwards means a decrease in y
    // for black it's an increase in y
    if (side == Side.white && yDiff < 0) return false;
    if (side == Side.black && yDiff > 0) return false;
    return true;
  }
}
