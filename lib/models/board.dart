import 'package:chess_2/models/pieces/piece.dart';
import 'package:chess_2/models/spot.dart';

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
      Spot.jail(Side.white),
      Spot.jail(Side.white),
    ];
    whiteJail = [
      Spot.jail(Side.black),
      Spot.jail(Side.black),
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

  /// Returns the [Spot] of given [coordinates].
  ///
  /// Assumes [coordinates] are in range, so it could throw a [RangeError].
  /// Suggest using [isOutOfRange] before.
  Spot getSpotFromCoords(SpotCoordinates coordinates) {
    return spots[coordinates.y][coordinates.x];
  }

  // TODO: test
  bool isOutOfRange(SpotCoordinates coordinates) {
    try {
      spots[coordinates.y][coordinates.x];
      return false;
    } on RangeError catch (_) {
      return true;
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
