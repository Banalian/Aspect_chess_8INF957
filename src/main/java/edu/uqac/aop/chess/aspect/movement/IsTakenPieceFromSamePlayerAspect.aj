package edu.uqac.aop.chess.aspect.movement;

import edu.uqac.aop.chess.Board;
import edu.uqac.aop.chess.Spot;
import edu.uqac.aop.chess.agent.Move;
import edu.uqac.aop.chess.piece.Piece;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Aspect that checks if a taken piece is from the same color as the initial piece
 */
public aspect IsTakenPieceFromSamePlayerAspect {

    private final Logger logger = LoggerFactory.getLogger("consoleLogger");

    /**
     * Checks if the taken piece is from the same color as the initial piece
     * @param piece the initial piece
     * @param takenPiece the taken piece
     * @return true if the taken piece is from the same color as the initial piece, false otherwise
     */
    public boolean IsTakenPieceFromSamePlayer(Piece piece, Piece takenPiece) {
        return piece.getPlayer() == takenPiece.getPlayer();
    }

    //pointcut right after a move is made by a player
    pointcut moveMade(Move movement) : call(boolean edu.uqac.aop.chess.agent.Player.makeMove(Move)) && args(movement);

    boolean around(Move movement) : moveMade(movement) {

        // we need the board to check the spots
        try {
            Board board = (Board) thisJoinPoint.getTarget().getClass().getSuperclass().getDeclaredField("playGround").get(thisJoinPoint.getTarget());

            Spot startSpot = board.getGrid()[movement.xI][movement.yI];
            Spot endSpot = board.getGrid()[movement.xF][movement.yF];

            // Check both spots have a piece
            if (startSpot.getPiece() != null && endSpot.getPiece() != null) {
                // Check if the taken piece is from the same color as the initial piece
                if (IsTakenPieceFromSamePlayer(startSpot.getPiece(), endSpot.getPiece())) {
                    logger.warn("IsTakenPieceFromSamePlayerAspect - " + movement + " : The taken piece is from the same color as the initial piece");
                    return false;
                }
            }

            // else the checks are not the responsibility of this aspect
            return proceed(movement);

        } catch (IllegalAccessException | NoSuchFieldException e) {
            throw new RuntimeException(e);
        }
    }
}
