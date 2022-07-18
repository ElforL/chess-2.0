import 'package:chess_2/models/pieces/piece.dart';

class Spot {
  final SpotCoordinates coords;
  ChessPiece? piece;

  final bool isJailCell;
  final Side? jailCellSide;

  Spot(this.coords)
      : isJailCell = false,
        jailCellSide = null;

  Spot.jail(this.jailCellSide)
      : isJailCell = true,
        coords = SpotCoordinates.jail();

  bool get hasPiece => piece != null;
}

class SpotCoordinates {
  final int x, y;

  SpotCoordinates(this.x, this.y);

  bool get isJailSpot => x == -1 && y == -1;

  /// x = `-1`
  ///
  /// y = `-1`
  SpotCoordinates.jail()
      : x = -1,
        y = -1;
}
