
### Assignment 3 (February 22): My Project Ideas
##### Boid DNA:
The main and most important variable in my DNA class is the survivablity variable. This variable is declared as a float and initiated with an initial value of 1, meaning that all the boids have the same chance of surviving. Then, as the process procedes, this parameter increaes or decreases depending on the interaction to show a certain boid's survivability. However, its value will never get greater than 1.

There are certain criteria that are put into consideration when determing the survivability of a boid. My DNA has other two vairables: color and size. Thus, depending on these two conditions, a boid's survivabilty may increase or decrease depending on how well its color and size let its adapt to its environment(flow field). For example, if its color matches with the flow field, it will have camaflouge and have a very high chance of surviving. On the other hand, if a boid size is really large but the flow field has narrow path, it won't be able to travel smoothly or keep up with the flock, so its survability will be really low.
