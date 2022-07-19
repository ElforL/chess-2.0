import '../board.dart';
import '../spot.dart';
import 'piece.dart';

class Elephant extends ChessPiece {
  Elephant(super.coordinates, super.side);

  @override
  bool isLegalMove(SpotCoordinates coordinates, ChessBoard board) {
    if (!isValidNewSpot(coordinates)) return false;
    final endSpot = board.getSpotFromCoords(coordinates);
    if (endSpot.isJailCell) return false;

    // can move if there's no piece or the piece isn't a teammate
    return !endSpot.hasPiece || endSpot.piece?.side != side;
  }

  @override
  bool isValidNewSpot(SpotCoordinates coordinates) {
    if ((coordinates.x - x).abs() != 2) return false;
    if ((coordinates.y - y).abs() != 2) return false;
    return true;
  }
}
