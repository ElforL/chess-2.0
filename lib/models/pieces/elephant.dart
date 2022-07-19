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

    if (isTherePieceBetween(coordinates, board)) return false;

    // Move if there's no piece or the piece isn't a teammate
    return !endSpot.hasPiece || endSpot.piece?.side != side;
  }

  @override
  bool isValidNewSpot(SpotCoordinates coordinates) {
    if ((coordinates.x - x).abs() != 2) return false;
    if ((coordinates.y - y).abs() != 2) return false;
    return true;
  }

  bool isTherePieceBetween(SpotCoordinates coordinates, ChessBoard board) {
    final dX = (coordinates.x - x).abs();
    final dY = (coordinates.y - y).abs();

    if (dX != 2 && dY != 2) throw ArgumentError('Illegal Elephant move: dx=$dX dy=$dY');

    /// The coords of the spot in between current spot and endSpot (The spot the monkey is jumping over).
    SpotCoordinates middleSpotCoordinates = SpotCoordinates(
      dX == 0
          ? x
          : coordinates.x > x
              ? x + 1
              : x - 1,
      dY == 0
          ? y
          : coordinates.y > y
              ? y + 1
              : y - 1,
    );

    final middleSpot = board.getSpotFromCoords(middleSpotCoordinates);
    return middleSpot.hasPiece;
  }
}
