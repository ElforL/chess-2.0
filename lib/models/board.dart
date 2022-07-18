import 'package:chess_2/models/pieces/piece.dart';
import 'package:chess_2/models/spot.dart';

class ChessBoard {
  // TODO are the indecies the same for all players?
  //  So if i'm playing white for example and the black pieces are at y = 0 and y = 1
  //  is it the same for black player? are my white pieces are at his y = 0-1????!.
  //  🐵 Fix Monkey jail position check once fixed. 🐵
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

  Spot getSpotFromCoords(SpotCoordinates coordinates) {
    try {
      return spots[coordinates.y][coordinates.x];
    } catch (e) {
      // TODO remove print.
      //  ignore: avoid_print
      print('getSpotFromCoords() error. Is it and out of range error?');
      rethrow;
    }
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
}
