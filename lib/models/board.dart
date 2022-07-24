import 'pieces/piece.dart';
import 'spot.dart';

class ChessBoard {
  /// The spots on the board excluding jail spots.
  ///
  /// White pieces start at y = 0-1
  /// and black pieces at 6-7
  late final List<List<Spot>> spots;
  late final List<Spot> whiteJail;
  late final List<Spot> blackJail;

  /// Did this side kill on the previous turn.
  ///
  /// Used to determine if the [Rook] can kill on this turn.
  bool didBlackKill = false, didWhiteKill = false;

  ChessBoard() {
    _initCells();
  }

  void _initCells() {
    spots = _generateEmptyBoard();
    whiteJail = [
      Spot.jail(SpotCoordinates(-2, 3), Side.white),
      Spot.jail(SpotCoordinates(-2, 4), Side.white),
    ];
    whiteJail = [
      Spot.jail(SpotCoordinates(9, 3), Side.black),
      Spot.jail(SpotCoordinates(9, 3), Side.black),
    ];
  }

  List<List<Spot>> _generateEmptyBoard() {
    return List.generate(
      8,
      (y) => List.generate(
        8,
        (x) => Spot(SpotCoordinates(x, y)),
      ),
    );
  }

  /// Returns the [Spot] of given [coordinates] on main board or jail spots.
  ///
  /// Assumes [coordinates] are in range, so it throws a [RangeError] if [coordinates] are invalid.
  Spot getSpotFromCoords(SpotCoordinates coordinates) {
    try {
      return spots[coordinates.y][coordinates.x];
    } on RangeError {
      final wIndex = whiteJail.indexWhere((jailSpot) => jailSpot.coords == coordinates);
      if (wIndex != -1) return whiteJail[wIndex];
      final bIndex = blackJail.indexWhere((jailSpot) => jailSpot.coords == coordinates);
      if (bIndex != -1) return blackJail[bIndex];

      rethrow;
    }
  }

  /// Returns `true` if the spot with given [coordinates] are next to [side]'s enemy's jail.
  ///
  /// [side] is for the player's side **not the enemy**.
  bool isSpotNextToEnemyJail(SpotCoordinates coordinates, Side side) {
    // Must be in middle rows
    if (coordinates.y != spots.length - 1 && coordinates.y != spots.length - 2) return false;

    switch (side) {
      case Side.white:
        return coordinates.x == spots.length - 1;
      case Side.black:
        return coordinates.x == 0;
      case Side.neutral:
        return false;
    }
  }
}
