import 'pieces/piece.dart';

class Spot {
  final SpotCoordinates coords;
  ChessPiece? piece;

  final bool isJailCell;
  final Side? jailCellSide;

  Spot(this.coords)
      : isJailCell = false,
        jailCellSide = null;

  Spot.jail(this.coords, this.jailCellSide) : isJailCell = true;

  bool get hasPiece => piece != null;
}

class SpotCoordinates {
  final int x, y;

  SpotCoordinates(this.x, this.y);

  bool get isJailSpot {
    if (x < 0 || y < 0) return true;
    if (x > 7 || y > 7) return true;
    return false;
  }

  @override
  bool operator ==(other) {
    return other is SpotCoordinates && other.x == x && other.y == y;
  }

  @override
  int get hashCode => Object.hash(x, y);
}
