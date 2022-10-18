package edu.uqac.aop.chess.aspect.movement;

import edu.uqac.aop.chess.Board;
import edu.uqac.aop.chess.Spot;
import edu.uqac.aop.chess.agent.Move;

public aspect IsMovingAPieceAspect {

    //pointcut right after a move is made by a player
    pointcut moveMade(Move movement) : call(boolean edu.uqac.aop.chess.agent.Player.makeMove(Move)) && args(movement);

    boolean around(Move movement) : moveMade(movement) {

        System.out.println("IsMovingAPieceAspect: " + movement);
        // get the player's board from the player's instance (board is protected)
        try {
            Board board = (Board) thisJoinPoint.getTarget().getClass().getSuperclass().getDeclaredField("playGround").get(thisJoinPoint.getTarget());

            Spot startSpot = board.getGrid()[movement.xI][movement.yI];

            if(startSpot.isOccupied()) {
                return proceed(movement);
            } else {
                System.out.println("IsMovingAPieceAspect: " + movement + " is not a valid move");
                return false;
            }
        } catch (IllegalAccessException | NoSuchFieldException e) {
            throw new RuntimeException(e);
        }
    }
}
