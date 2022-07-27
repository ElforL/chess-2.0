import 'pieces/piece.dart';
import 'spot.dart';

class IllegalMoveError {
  final ChessPiece piece;
  final SpotCoordinates startCoordinates;
  final SpotCoordinates endCoordinates;

  IllegalMoveError(this.piece, this.startCoordinates, this.endCoordinates);

  @override
  String toString() {
    return 'IllegalMoveError: Moving ${piece.runtimeType} from $startCoordinates to $endCoordinates.';
  }
}

class MustJailRoyalsError {
  final ChessPiece heldPiece;

  MustJailRoyalsError(this.heldPiece);

  @override
  String toString() {
    return 'MustJailRoyalsError: Must move ${heldPiece.runtimeType} to jail first.';
  }
}

class MoveOpponentPieceError {
  final Side currentSide;
  final ChessPiece piece;

  MoveOpponentPieceError(this.currentSide, this.piece);

  @override
  String toString() {
    return 'MoveOpponentPieceError: Player of side ${currentSide.toShortString()} can not move a piece of side ${piece.side.toShortString()}';
  }
}
