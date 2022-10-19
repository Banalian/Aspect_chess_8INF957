package edu.uqac.aop.chess.aspect.movement;

import edu.uqac.aop.chess.agent.Move;

/**
 * Aspect that checks if a move is within the board's boundaries.
 */
public aspect IsMoveWithinTheBoardAspect {

    //pointcut right after a move is made by a player
    pointcut moveMade(Move movement) : call(boolean edu.uqac.aop.chess.agent.Player.makeMove(Move)) && args(movement);

    boolean around(Move movement) : moveMade(movement) {

        // check if the move is within the board (x and y initial and final are between 0 and 7)
        // if not, return false
        if (movement.xI < 0 || movement.xI > 7 ||
                movement.yI < 0 || movement.yI > 7 ||
                movement.xF < 0 || movement.xF > 7 ||
                movement.yF < 0 || movement.yF > 7) {
            System.out.println("IsMoveWithinTheBoardAspect - " + movement + " : move is not within the board");
            return false;
        }
        return proceed(movement);
    }
}
