package edu.uqac.aop.chess.aspect.movement;

import edu.uqac.aop.chess.Board;
import edu.uqac.aop.chess.Spot;
import edu.uqac.aop.chess.agent.Move;
import edu.uqac.aop.chess.agent.Player;

/**
 * This aspect checks that the current moved piece is owned by the current player.
 */
public aspect IsOwnerOfMovedPieceAspect {

    //pointcut right after a move is made by a player
    pointcut moveMade(Move movement) : call(boolean edu.uqac.aop.chess.agent.Player.makeMove(Move)) && args(movement);

    boolean around(Move movement) : moveMade(movement) {

        // get the player's board from the player's instance (board is protected)
        try {
            Board board = (Board) thisJoinPoint.getTarget().getClass().getSuperclass().getDeclaredField("playGround").get(thisJoinPoint.getTarget());

            Spot startSpot = board.getGrid()[movement.xI][movement.yI];
            Player player = (Player) thisJoinPoint.getTarget();

            // if the piece on the source spot is not the player's piece, return false and write a message
            // it's "==" because of the incorrect check in the original code
            if (startSpot.getPiece().getPlayer() == player.getColor()) {
                System.out.println("IsOwnerOfMovedPieceAspect - " + movement + " : You can't move a piece that is not yours!");
                return false;
            }

            return proceed(movement);
        } catch (IllegalAccessException | NoSuchFieldException e) {
            throw new RuntimeException(e);
        }
    }
}