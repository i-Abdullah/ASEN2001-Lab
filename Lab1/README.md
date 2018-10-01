# This repo contains the work for Lab 1 in ASEN 2001: Statics and Materials, CU Boulder, Fall 18.

* In engineering, calculating the equilibrium of non-accelerating or constant velocity systems is essential to understand the loads and moments that system is undergoing. This is important because it allows us to think about our external loads and design our systems accordingly to withhold or behave in a certain way and provide strong enough supports to avoid failures. Therefore, for our system to be in static equilibrium, we want all of our net forces and net moments to be equal to zero. Supports on the system are responsible for having the system remaining static by exerting reaction forces and moments that interact with the applied forces and moments and cancel them out. This repo is designed to solve for this reaction given an ASCII input file.


### Contents:

* `truss3d.m`:This function is the chassis of our code. truss3d will utilize two sub-functions, ​Extraction,​ and ​Analyze.​ Afterwards, truss3d will perform the matrix operations above and write out the solutions found with the problem setup. The inputs and outputs are commented inside the .m file with a brief description about the code. The code is very well commented for anyone to see the process.

* `Extraction.m`: MATLAB function. This codes extracts information about a body, forces, and moments acting on a body from an ASCII input file, and example of the file in i Examples/Solved folder.

* `analyze.m`: MATLAB function. This function takes information about a system in static equilibrium and calculates the magnitudes of the reaction forces and moments.

* **Lab Report:** The final lab report, contains user manual, developer manual, code capabilities, and how to run the code via cli in MATLAB.

* **Examples/Solved:** Folder that contains set of solved examples to demonstrate the output and input files from the code. Problems are from Statics and Mechanics of Materials (5th Edition) [Russell C. Hibbeler].