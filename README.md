# Customizable Meal Planner: A Healthy Diet for An Individual
MIE465 - Analytics in Action, 2018, University of Toronto

This is the directory of the optimization part of the project for the course "Analytics in Action" winter 2018, University of Toronto. This directory contains cleaned and parsed data used in the optimization as well as the code for the optimization algorithm. For more detailed description and final results of the project, please refer to (`Report.pdf`). For a more brief overview, refer to (`Presentation.pdf`).

Smart fridges are a rising technology. A powerful algorithm behind it could be an optimization algorithm which prepares an optimal meal plan for the day from ingredients readily available from the individual's household, which of course is kept track by the fridge. Such an algorithm also serves some powerful meal planning apps. In this project, we develop a mixed integer programming model from scratch which constructs a plan of three meals by allocating ingredients in a way that maximizes nutritional value while adhering to the user's preference for cuisine.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

The required environment for running the code and reproducing the results is a computer with a valid installation of MATLAB. More specifically, [MATLAB 2018a](https://www.mathworks.com/help/releases/R2018a/index.html) is used.

Besides that (and the built-in Python libraries), the Gurobi package needs to be installed. :

* [Gurobi 8.1.0](https://www.gurobi.com/documentation/8.1/quickstart_mac/matlab_setting_up_gurobi_f.html). 

## Project Structure

The `project/` directory has the following folder (and file) structure:

* `data/`. Directory containing cleaned and parsed data.
    * `aggregateData.csv` CSV file listing each recipe row by row and its nutritional content. Original data was accessed via Yummly API.
    * `FemaleValues.csv` CSV file listing recomended nutritional intake by age for females. Original data was acquired from Office of Disease Prevention and Health Promotion.
    * `MaleValues.csv` CSV file listing recomended nutritional intake by age for males.

* `Matlab Code/`. Folder containing the actual code files for the project:
    * `MIE465Optimize_New.m` Gurobi model for mixed integer programming.
    * `main.m` Imports data, accepts user data, and constructs constriants for the Gurobi model.

* `Report.pdf`
* `Presentation.pdf`

## How to execute the files.
	
Make sure that the directories to the data are correctly specified. Ensure that `MIE465Optimize_New.m` and `main.m` are in the same directory. Run `main.m` and results will be displayed in the MATLAB interface.

## Authors

* **Brandimarte, Alexander** - 
* **Park, Jangwon** - 
* **Tata, Sowmya** - 
* **Ye, Tony** - 

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
