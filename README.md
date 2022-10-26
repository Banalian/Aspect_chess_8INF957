# Aspect_chess_8INF957

## Introduction

In this project we use Java aspect classes to monitor the behaviour of a simple chess games pieces.
The aspect classes are used to ensure no illegal move is made by either player during the game, and every move attempted is saved in a log file.
We also used SL4J to generate logs.

## The Aspects

This project implements 6 Aspect classes to monitor piece movements:
|Aspect|Description|
|-|-|
|IsMoveLegalAspect|Ensures that the attempted move is legal according to the way the selected piece moves |
|IsMoveWithinTheBoardAspect|Ensures that the attempted move does not put a piece outside of the board boundaries|
|IsMovingAPieceAspect|Ensures the player is not attempting to move an empty space on the board|
|IsMovingPieceJumpingAspect|Ensures the moved piece is not moving through other pieces to reach the target tile (except for a knight)|
|IsOwnerOfMovedPieceAspect|Ensure the attempted move moves a piece owned by the correct player (i.e black player can't move white pieces)|
|IsTakenPieceFromSamePlayerAspect|Ensures the attempted move does not result in a piece taking another piece of the same color|

This project also has 1 Aspect that keeps track of all legal moves that were player using a logger.
The moves are logged into the logfile.log file in the root directory of the project.

### Logic behind IsMovingPieceJumpingAspect

This aspect is the only one that has a moderately complex algorithm powering it.

To check if the moved piece is jumping over any other pieces, we simply check every tile the piece has to clear to arrive at the target tile, we don't check the target tile because the piece could be moving to take another piece, in which case the move is legal (or illegal and caught by IsTakenPieceFromSamePlayerAspect).

This prevents this type of move: 

![image](https://user-images.githubusercontent.com/48995051/197904684-3ec89161-e03e-4e8a-9031-dfa4764e5394.png)

Here the bishops path would be blocked by the queen at the first tile step of the necessary movement to get to its target tile.


The algorithm is pretty simple: first determine what the total movement looks like (the yellow vector on the image), then break it down into unitary sub-movements and ommit the very last one (because we don't check the last tile), then check if any of those submovements puts the moving piece on another piece, if any of them do, it means we would jump over another piece, and the move is illegal.

Luckily most of the pieces in chess move in straight lines, orthogonal or diagonal, than means each sub-movement vector is very simple to quantify with coordinates over x and y that are always either ±1 or 0, thus a submovement will always have the same unitary direction as the overall movement it is derived from.

Note: The knight is the only piece that moves in a non-linear pattern, but it can also jump over pieces so we do not have to care for any knight movements in this Aspect.
