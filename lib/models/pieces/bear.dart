import '../board.dart';
import '../spot.dart';
import 'piece.dart';

class Bear extends ChessPiece {
  Bear(SpotCoordinates coordinates) : super(coordinates, Side.neutral);

  @override
  bool isLegalMove(SpotCoordinates coordinates, ChessBoard board) {
    if (!isValidNewSpot(coordinates)) return false;

    final endSpot = board.getSpotFromCoords(coordinates);
    if (endSpot.hasPiece) return false;

    return true;
  }

  @override
  bool isValidNewSpot(SpotCoordinates coordinates) {
    if (coordinates == this.coordinates) return false;
    final dx = (coordinates.x - x).abs();
    final dy = (coordinates.y - y).abs();

    if (dx > 1) return false;
    if (dy > 1) return false;
    return true;
  }
}
