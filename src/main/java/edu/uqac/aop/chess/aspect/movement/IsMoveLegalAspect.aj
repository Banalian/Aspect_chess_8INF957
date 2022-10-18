package edu.uqac.aop.chess.aspect.movement;

import edu.uqac.aop.chess.Board;
import edu.uqac.aop.chess.Spot;
import edu.uqac.aop.chess.agent.Move;

/**
 * Aspect that checks if a move is legal
 */
public aspect IsMoveLegalAspect {

    //pointcut right after a move is made by a player
    pointcut moveMade(Move movement) : call(boolean edu.uqac.aop.chess.agent.Player.makeMove(Move)) && args(movement);

    boolean around(Move movement) : moveMade(movement) {

        // get the player's board from the player's instance (board is protected)
        try {
            Board board = (Board) thisJoinPoint.getTarget().getClass().getSuperclass().getDeclaredField("playGround").get(thisJoinPoint.getTarget());

            Spot startSpot = board.getGrid()[movement.xI][movement.yI];

            // check is the move is legal
            if (startSpot.getPiece().isMoveLegal(movement)) {
                // if the move is legal, let the player make the move
                return proceed(movement);
            } else {
                // if the move is not legal, print a message and return false
                System.out.println("IsMoveLegalAspect : Illegal move, try again");
                return false;
            }
        } catch (IllegalAccessException | NoSuchFieldException e) {
            throw new RuntimeException(e);
        }
    }
}
