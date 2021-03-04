
### Assignment 3 (March 1): Bugs Simulation
#### My Final Product:
[![Demo](Simulation/product/bugsSimulation.gif)](https://www.youtube.com/watch?v=SA2FcCZLtvE)
#### My Process:
##### Part 1:
I did not start working on the assignment immediately. Before working on the actual evolution project, I was exploring how different forces affect the behavior of the vehicles. I add and manipulate forces like separation, cohesion, and alignment to make those vehicles behave more like animals. Undertanding these forces actually comes in handy later on in the environment.

I started the assignment by creating a very simple DNA class with three main features: size, color, and survivability index. As mentioned in my previous [post](#Assignment-3-February-22-My-Project-Ideas), the evolution of my bots will hugely depend on how well their sizes and colors adapt to their environment. 
After I created the DNA class, I modified the Vehicle constructor to take in DNA variable as one of its parameters. I added another function to the Vehicle class so its DNA can be copied to create an exact same vehicle. 

##### Part 2:
Creating the evolution processing was another story. I began by having two vehicles create another bots when they came in contact with each other. New vehicles would have blended color of their parents' colors and their sizee, locations, and survivability index would be the averages of their parents'. However, after they came in contact with each other, they did not separate from each other becaue of the cohesion that was applied. As a result, they conitnuously produced new vehicles. I tried manipulate the applied forces by making the seperation stronger but it did not work because new vehicles created always got in contact with them. To try to fix this I created a boolean variable that keeps track of whether a vehicle has reproduced yet. If a vehicle has produced a new vehicle, this variable will be set to false, so even if the vehicles are still in contact, they will not produce new vehicles. I also set this variable to false for the new vehicles, so they will not produce new vehcles. New vehicles' location  are set to the distance between their parents, so getting in contact with their parents was unavoidable. Although this method worked, the number of new vehicles were so limited because parent vehicles could reproduce only once and childen can not reproduce. I needed to add functions with conditions that after a while, these vehicles should be able to reproduce. I took a break and thought of my next steps.

##### Part 3:
I started again with finding pictures for my vehicles and background environment. After spending a few hours just searching for visuals, I realized that I just wasted my time on something unnecessary, but, well,at least I got something to work with. The images I found for my vehicles were black-and-white sprites of a bug and a black-and-white environment image, so I created a new sketch to figure out how to load and show those images to make an animation effect. Again, I realized that I spent time on something unnecessary, but I couldnot resist the feeling of satisfaction.  

I chose to use black and white colors because I wanted to use the PImage tint() function to change the environment color randomly as well as create random colors for my bugs. The idea is to change the color of my environment randomly and let the bugs evolve their colors to match the environment. The closer their colors are to the environment, the higher their chance of survivability. I determined the color difference by finding the differences in theri RGBs (the red color value of a bug - red value color of the environment, the green color value of a bug - green value color of the environment, the blue color value of a bug - blue value color of the environment), add them up, and divide by 3 to find the average. Then I compare this to a certain value to see whether their survability should decrease. 

Going back to my work from part 2, I chose a different to pass gone my bug's DNA. Two bugs could only reproduce when they come in contact of each other if their survivabilities are greater than a set value. The new produced bug will the average of all their parents' DNA traits(colors, locations...). In addition, after they reproduced, the parent bugs would died and removed from the environment. 

When the program ran, users could press SPACE to change the environment color and add 100 bugs to the environment or they could press ENTER to just add 50 bugs. These features allowed continuous running of many simulations of bugs' adaption to the environment.


#### Reflections:
The processing could get really fustrating sometimes when I could not figure something out. When that happened, I would debug with the print fuction or get a pen and paper to sketch the algorithm. These two steps helped me solve at least 90% of the time. Still, the project turned out satisfying as soon as I got my program to meet some of my expectations. 

Things to keep in mind for my next project:
- Always backup your program in case for unforseen cases 
- Expect to spend 100% more time than you think you'll need to finish the program
- Focus on the functionality aspect of the program first
