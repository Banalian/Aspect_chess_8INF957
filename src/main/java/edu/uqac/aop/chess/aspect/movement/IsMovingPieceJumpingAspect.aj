package edu.uqac.aop.chess.aspect.movement;

import edu.uqac.aop.chess.Board;
import edu.uqac.aop.chess.Spot;
import edu.uqac.aop.chess.agent.Move;
import edu.uqac.aop.chess.piece.Piece;

/**
 * Aspect to check if a piece is moving over other pieces (except for the knight)
 */
public aspect IsMovingPieceJumpingAspect {

    /**
     * Check if a piece is moving over other pieces (except for the knight)
     * @param piece the piece to check
     * @param board the board on which the piece is moving
     * @param move the move to check
     * @return true if the piece is moving over other pieces, false otherwise
     */
    public boolean IsMovingPieceJumping(Piece piece, Board board, Move move) {

        // TODO : not a correct implementation, to be completed/modified
        int x = move.xI;
        int y = move.yI;
        int x2 = move.xF;
        int y2 = move.yF;
        int dx = x2 - x;
        int dy = y2 - y;
        int xinc = dx > 0 ? 1 : -1;
        int yinc = dy > 0 ? 1 : -1;
        dx = Math.abs(dx);
        dy = Math.abs(dy);
        int n = dx > dy ? dx : dy;
        dx = dx * 2;
        dy = dy * 2;
        for (int i = 0; i < n; i++) {
            if (dx > dy) {
                x += xinc;
                dx -= dy;
            } else {
                y += yinc;
                dy -= dx;
            }
            if (board.getGrid()[x][y] != null) {
                return true;
            }
        }
        return false;
    }

    //pointcut right after a move is made by a player
    pointcut moveMade(Move movement) : call(boolean edu.uqac.aop.chess.agent.Player.makeMove(Move)) && args(movement);

    boolean around(Move movement) : moveMade(movement) {

        // we need the board to check the spots
        try {
            Board board = (Board) thisJoinPoint.getTarget().getClass().getSuperclass().getDeclaredField("playGround").get(thisJoinPoint.getTarget());

            // we need the piece to check if it is a knight
            Piece piece = board.getGrid()[movement.xI][movement.yI].getPiece();

            // if the piece is a knight, we don't check if it is jumping
            if (piece != null && piece.getClass() == Class.forName("edu.uqac.aop.chess.piece.Knight")) {
                return proceed(movement);
            }

            // if the piece is not a knight, we check if it is jumping
            if (IsMovingPieceJumping(piece, board, movement)) {
                System.out.println("IsMovingPieceJumpingAspect - " + movement + " : The piece is jumping over other pieces");
                return false;
            }

            // else the checks are not the responsibility of this aspect
            return proceed(movement);

        } catch (IllegalAccessException | NoSuchFieldException | ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
    }
}
