import 'board.dart';

import 'spot.dart';

class ChessGame {
  ChessBoard _board;
  ChessGame() : _board = ChessBoard();

  void movePiece(SpotCoordinates start, SpotCoordinates end) {
    final startSpot = _board.getSpotFromCoords(start);
    if (startSpot.piece == null) return;
    final endSpot = _board.getSpotFromCoords(end);
    final piece = startSpot.piece;

    final isLegalMove = piece!.isLegalMove(end, _board);

    if (isLegalMove) {
      endSpot.piece = piece;
      startSpot.piece = null;
    }
  }
}
