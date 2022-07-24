import '../pieces/piece.dart';
import '../spot.dart';

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
