import '../spot.dart';
import '../board.dart';
import 'piece.dart';

class Queen extends ChessPiece {
  Queen(super.coordinates, super.side);

  @override
  bool isLegalMove(SpotCoordinates coordinates, ChessBoard board) {
    if (!isValidNewSpot(coordinates)) return false;

    final endSpot = board.getSpotFromCoords(coordinates);
    if (endSpot.piece?.side == side || endSpot.isJailCell) return false;

    return isTherePieceBetween(coordinates, board);
  }

  @override
  bool isValidNewSpot(SpotCoordinates coordinates) {
    final dx = (coordinates.x - x).abs();
    final dy = (coordinates.y - y).abs();

    if (dx > 0 && dy == 0) return true; // horizontal movement
    if (dy > 0 && dx == 0) return true; // vertical movement
    if (dx > 0 && dx == dy) return true; // diagonal movement

    return false;
  }

  bool isTherePieceBetween(SpotCoordinates coordinates, ChessBoard board) {
    final dx = (coordinates.x - x).abs();
    final dy = (coordinates.y - y).abs();

    int xStep = dx == 0
        ? 0
        : coordinates.x - x > 0
            ? 1
            : -1;
    int yStep = dy == 0
        ? 0
        : coordinates.y - y > 0
            ? 1
            : -1;

    for (var i = 1; i < dx; i++) {
      final checkCoordinates = SpotCoordinates(x + xStep * i, y + yStep * i);
      try {
        final spot = board.getSpotFromCoords(checkCoordinates);
        if (spot.hasPiece) return true;
      } on RangeError catch (e) {
        // ignore: avoid_print
        print(e);
        continue;
      }
    }

    return false;
  }
}
