import 'errors.dart';
import 'pieces/king.dart';
import 'pieces/monkey.dart';
import 'pieces/piece.dart';
import 'pieces/queen.dart';
import 'spot.dart';

class ChessBoard {
  static const width = 8;
  static const height = 8;

  /// The spots on the board excluding jail spots.
  ///
  /// White pieces start at y = 0-1
  /// and black pieces at 6-7
  late final List<List<Spot>> spots;
  late final List<Spot> whiteJail;
  late final List<Spot> blackJail;

  /// all spots in [whiteJail] are filled making white the winner.
  bool get whiteJailFilled => whiteJail.every((spot) => spot.hasPiece);

  /// all spots in [blackJail] are filled making black the winner.
  bool get blackJailFilled => blackJail.every((spot) => spot.hasPiece);

  /// if a player took a King or Queen, this variable will hold the King/Queen for the player to move them to a jail cell.
  ChessPiece? heldKingOrQueen;

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
      height,
      (y) => List.generate(
        width,
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

  static bool _areValidCoordinates(SpotCoordinates coordinates) {
    if (coordinates.x < 0 || coordinates.x >= width) return false;
    if (coordinates.y < 0 || coordinates.y >= height) return false;
    return true;
  }

  /// This functions checks if there's only one jail spot to hold a royal of [side].
  /// if it found it (only one) it'll return it.
  ///
  /// A King/Queen on [side] will be held at this spot.
  /// so if a white King was taken this method will be called to return a black jail spot.
  Spot? _onlyOneJailSpotToPut(Side side) {
    try {
      switch (side) {
        case Side.black:
          final allEmpty = whiteJail.every((spot) => !spot.hasPiece);
          if (allEmpty) {
            return null;
          } else {
            return whiteJail.firstWhere((spot) => !spot.hasPiece);
          }
        case Side.white:
          final allEmpty = blackJail.every((spot) => !spot.hasPiece);
          if (allEmpty) {
            return null;
          } else {
            return blackJail.firstWhere((spot) => !spot.hasPiece);
          }
        case Side.neutral:
          return null;
      }
    } on StateError {
      // ignore: avoid_print
      print(
        'State Error in _onlyOneJailSpotToPut() which means a king or queen was taken but had no jail cell to be held at.',
      );
      rethrow;
    }
  }

  /// Moves the piece in [start] spot to [end] spot.
  /// Doesn't do anything if start is empty.
  ///
  /// Throws [IllegalMoveError] if the move is illegal
  void movePiece(SpotCoordinates start, SpotCoordinates end) {
    if (heldKingOrQueen != null) throw MustJailRoyalsError(heldKingOrQueen!);

    final startSpot = getSpotFromCoords(start);
    if (!startSpot.hasPiece) return; // TODO throw error? (update func docs)

    final startPiece = startSpot.piece;
    final endSpot = getSpotFromCoords(end);

    final isLegalMove = startPiece!.isLegalMove(end, this);
    if (!isLegalMove) throw IllegalMoveError(startPiece, start, end);

    if (!endSpot.isJailCell) {
      // Update the end spot and piece coords.
      if (endSpot.hasPiece) {
        _handleTakingPiece(endSpot);
      } else {
        _resetKills();
      }
      endSpot.piece = startPiece;
      startPiece.coordinates = end;

      // Check if it's a Monkey holding a king.
      if (startPiece is Monkey && startPiece.isHoldingKing) {
        // Drop the king at [start]
        startSpot.piece = startPiece.heldKing;
        startPiece.heldKing = null;
      } else {
        // Empty the [start] spot.
        startSpot.piece = null;
      }
    } else {
      // Monkey breaking a King out.
      // Since the move passed isLegalMove() above, then there's a King with a banana in [end] and there's
      // piece near [start] for the monkey to jump over after dropping the king leaving the king at [start].

      if (startPiece is! Monkey) throw IllegalMoveError(startPiece, start, end);

      // Empty the jail
      endSpot.piece = null;

      // Hold the king
      startPiece.heldKing = endSpot.piece as King?;
      startPiece.heldKing!.coordinates = start;
      startPiece.heldKing!.hasBanana = false;
    }
  }

  /// Handles taking a piece at [endSpot].
  ///
  /// checks if the piece is a King/Queen and either holds them in [heldKingOrQueen] or move them to a jail spot
  /// if it's the only open one.
  void _handleTakingPiece(Spot endSpot) {
    final takenPiece = endSpot.piece!;
    final takenSide = takenPiece.side;
    if (endSpot.piece is King || endSpot.piece is Queen) {
      // check if there's only one jail cell available and if so,
      // move the taken king or queen to it.
      final jailCell = _onlyOneJailSpotToPut(takenSide);
      if (jailCell == null) {
        heldKingOrQueen = takenPiece;
      } else {
        // 🎇🎉 WINNER 🎉🎇

        // If there was only one jail spot open and now it's filled this means both king and queen are now captured.
        jailCell.piece = takenPiece;
        takenPiece.coordinates = jailCell.coords;
      }
    }
    switch (takenSide) {
      case Side.white:
        didBlackKill = true;
        break;
      case Side.black:
        didWhiteKill = true;
        break;
      case Side.neutral:
        break;
    }
  }

  void _resetKills() {
    didWhiteKill = false;
    didBlackKill = false;
  }
}
