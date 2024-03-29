import '../board.dart';
import '../spot.dart';

abstract class ChessPiece {
  SpotCoordinates coordinates;
  final Side side;

  ChessPiece(this.coordinates, this.side);

  int get x => coordinates.x;
  int get y => coordinates.y;

  /// Is a move to spot [coordinates] legal?
  ///
  /// ### This method checks if the move is legal based on the moving behaviour only,
  /// **it DOES NOT check/know if another piece is in that spot**.
  bool isValidNewSpot(SpotCoordinates coordinates);

  // TODO check for checkmate when calling this 👇
  bool isLegalMove(SpotCoordinates coordinates, ChessBoard board);

  @override
  String toString() {
    return '$runtimeType(x:$x, y:$y, side:${side.toShortString()})';
  }
}

enum Side {
  white,
  black,
  neutral;

  String toShortString() {
    return toString().split('.').last;
  }
}
