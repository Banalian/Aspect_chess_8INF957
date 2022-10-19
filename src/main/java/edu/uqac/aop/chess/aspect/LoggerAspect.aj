package edu.uqac.aop.chess.aspect;
import edu.uqac.aop.chess.agent.Move;
import edu.uqac.aop.chess.agent.Player;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public aspect LoggerAspect {

    private String getPlayerString(Player player){
        return player.getColor() == 1 ? "player_white" : "player_black";
    }

    pointcut moveMade() : call(Move edu.uqac.aop.chess.agent.Player.makeMove());
    after() returning(Move mouvement) : moveMade(){
        Logger logger = LoggerFactory.getLogger("moveLogger");
        Player player = (Player)thisJoinPoint.getTarget();
        StringBuilder logString = new StringBuilder(getPlayerString(player));

        //catch the move and convert in to string
        logString.append(" ").append(mouvement.toString()) ;
        //write the string into a file using logger
        logger.info(logString.toString());
    }
}
