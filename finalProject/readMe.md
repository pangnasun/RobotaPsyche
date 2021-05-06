
# Final Project: Simulating a Simple Ecosystem

### Project Concept
My project is about creating an evironment where, initially, animals  of different kinds are randomly put together to interact. Like a real world ecosystem, animals have these relations such as preys, predators, or allies (same species). However, these relations will be randomly assinged to them, so they need to figure this out through interactions. For instance, when animal A notices that another animal of its kind (same features like color, size, speed) gets eaten by animal B, animal A will learn to avoid animal B. Animal A learns that animal B is a predator. On the other hand, animal B will notice that any animals that have same features as the animal it had eaten are its preys. 

As the simulation continues, animals will learn to associate which animals are preys, predators, or allies based on their interaction. Then, preys will move away from predators, while predators chase after preys. In addition, animals of the same kind will move together as a group to protect themselves or hunt for food. At the end of the simulation, I expect to see these animals able to decide which animals they can form allies with and which animals they need to avoid. This will be shown in whether they are moving in group or avoiding each other. 


### Progress Journal
#### Log 0: 
I was looking for image sprites to put in my project. I saw some image sprites of spiders, squirrels, tigers, and other bugs. I downloaded them all. 
#### Log 1: 
I started thinking about how to code the "learning" process of each animal. I was playing around with Michael's Association program. I added a variable relation to the class Vehicle as a mean of keeping track of its relation to other animals. However, I soon realized that it was not right to define a relation to yourself; it should be relations to other animals. Thus, one variable will not be enough. I needed to create an arraylist the stores its relations to other animals. The array list will store all the animals that will be created in the main program. 

#### Log 2: 
I came across a problem as I started coding random relations for these animals. When one animal ate another animal, the eaten animal would be deleted, so it wouldn't be able to pass information to other animals. I needed to store this information somewhere outisde the animal class in order for animals to acess this information. I took a step to consider what I meant in my Project Concept when I said "animal A notices." So far, when I was running through the array list of animals, information only passed between two animals at a time during the loop. I needed to find a way to allow the information to pass out to other animlas, so they could "notice" what was going on between the two interacting animals. 

I tried to create loops within loops to allow other animals to be involved in the other animals' interactions. I felt like this is too complicated. I may need to simplify how I create their relationships. 

#### Log 3: 
I simplified their relations by creating a function that gave them relations based on their size. I created Animal class (similar to Michael's Vehicle class), where in the constructor I randomly two sizes to the animal. 
````
  if (round(random(1))== 1) {
      r = 3;
    } else {
      r = 6;
    }
````
Thus, their relations would mainly depend on their size: when two animals encounter each other, the one with larger size have a higher chance to be a predator. 
````
//randomly defines relations between animals
  int relation(Animal other) {
    float chance = random(100);

    if (other.r > r) {
      // if size is bigger, high chance of being a predator
      if (chance > 20) {
        return 1;     //relation is a predator
      }
    } else {
      // chance is lower to be a predator
      if (chance > 80) {
        return 1;
      }
    }

    return 2;  // netural relation ship
  }
````








### Demo Videos

Simulation # 1 with 100 animals:

[![Demo](gifs/EcoSim1.gif)](https://www.youtube.com/watch?v=NswwYQcuVkE&t)

Simulation # 2 with 150 animals:

[![Demo](gifs/EcoSim2.gif)](https://www.youtube.com/watch?v=uDsjksdJaDU)

Simulation # 3 with 200 animals:

[![Demo](gifs/EcoSim3.gif)](https://www.youtube.com/watch?v=OK1kmvzanII)

