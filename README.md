# cs50-breakout
A remake of the original Arkanoid game. Made with instructions from Harvard's CS50.

As a requirement for the CS50 GD, this is Breakout (a derivation of Arkanoid) with power ups update.

The power ups have 50% chance to be spawned on destroy of the bricks. When the level is divisible by 5, the power ups have 100% chance.

The additional balls power up is applied on only one ball. E.g. if there are 3 balls on the screen, getting the power up will only spawn two more balls for a total of 5 balls that can wreak havoc.

A key is used to unlock the locked bricks. The player is originally given keys at the start based on the number of locked bricks. Succeeding levels will just use the current number of keys that the player has. This is done to ensure that the player will at least be able to pass the first level presented.

Additional bonuses are also included:
* Green X will allow the paddle to enlarge.
* Red X will shrink the paddle.
* Heart will add health (paddle size will not change).
* Skull will decrease the health (paddle size will not change).
* Ascending bars will speed up the paddle movement.
* Descending bars will slow down the paddle movement.
