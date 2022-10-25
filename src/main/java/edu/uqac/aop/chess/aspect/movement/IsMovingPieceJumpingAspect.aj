package edu.uqac.aop.chess.aspect.movement;

import edu.uqac.aop.chess.Board;
import edu.uqac.aop.chess.Spot;
import edu.uqac.aop.chess.agent.Move;
import edu.uqac.aop.chess.piece.Knight;
import edu.uqac.aop.chess.piece.Piece;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Aspect to check if a piece is moving over other pieces (except for the knight)
 */
public aspect IsMovingPieceJumpingAspect {

    private final Logger logger = LoggerFactory.getLogger("consoleLogger");

    /**
     * Check if a piece is moving over other pieces (except for the knight)
     * @param piece the piece to check
     * @param board the board on which the piece is moving
     * @param move the move to check
     * @return true if the piece is moving over other pieces, false otherwise
     */
    public boolean IsMovingPieceJumping(Piece piece, Board board, Move move) {

        int x = move.xI;
        int y = move.yI;
        int x2 = move.xF;
        int y2 = move.yF;
        int dx = x2 - x;
        int dy = y2 - y;
        //identify which way the piece is moving on the board
        // NOTE : the piece can move only in 3 patterns:
        //perfectly diagonally (ie increment of x is equal to increment of y in absolute, as is dx and dy)
        //only vertically (ie increment of y = ±1 and increment of x = dx = 0)
        //only horizontally (ie increment of x = ±1 and increment of y = dy = 0)
        int xinc = dx == 0 ? 0 : dx/Math.abs(dx);
        int yinc = dy == 0 ? 0 : dy/Math.abs(dy);

        // NOTE : we just need to know how many spots we are moving the piece to check for other pieces on each in-between spot
        int n = Math.max(Math.abs(dx) , Math.abs(dy)) - 1;
        for (int i = 0; i < n; i++) {

            //Check the next spot on the moves path for other pieces
            x += xinc;
            y += yinc;
            if (board.getGrid()[x][y].getPiece() != null) {
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
            if (piece != null && piece instanceof Knight) {
                return proceed(movement);
            }

            // if the piece is not a knight, we check if it is jumping
            if (IsMovingPieceJumping(piece, board, movement)) {
                logger.warn("IsMovingPieceJumpingAspect - " + movement + " : The piece is jumping over other pieces");
                return false;
            }

            // else the checks are not the responsibility of this aspect
            return proceed(movement);

        } catch (IllegalAccessException | NoSuchFieldException e) {
            throw new RuntimeException(e);
        }
    }
}
