import '../spot.dart';
import '../board.dart';
import 'piece.dart';

class King extends ChessPiece {
  bool hasBanana = true;

  King(super.coordinates, super.side);

  @override
  bool isLegalMove(SpotCoordinates coordinates, ChessBoard board) {
    if (!isValidNewSpot(coordinates)) return false;

    final endSpot = board.getSpotFromCoords(coordinates);

    if (endSpot.piece?.side == side) return false;

    return true;
  }

  @override
  bool isValidNewSpot(SpotCoordinates coordinates) {
    final dx = (coordinates.x - x).abs();
    final dy = (coordinates.y - y).abs();

    if (dx > 1) return false;
    if (dy > 1) return false;
    return true;
  }
}
