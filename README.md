# Customizable Meal Planner: A Healthy Diet for An Individual
MIE465 - Analytics in Action, 2018, University of Toronto

This is the directory of the optimization part of the project for the course "Analytics in Action" winter 2018, University of Toronto. This directory contains cleaned and parsed data used in the optimization as well as the code for the optimization algorithm. For more detailed description and final results of the project, please refer to (`Report.pdf`). For a more brief overview, refer to (`Presentation.pdf`).

Smart fridges are a rising technology. A powerful algorithm behind it could be an optimization algorithm which prepares an optimal meal plan for the day from ingredients readily available from the individual's household, which of course is kept track by the fridge. Such an algorithm also serves some powerful meal planning apps. In this project, we develop a mixed integer programming model from scratch which constructs a plan of three meals by allocating ingredients in a way that maximizes nutritional value while adhering to the user's perference for cuisine.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

The required environment for running the code and reproducing the results is a computer with a valid installation of MATLAB. More specifically, [MATLAB 2018a](https://www.mathworks.com/help/releases/R2018a/index.html) is used.

Besides that (and the built-in Python libraries), the following packages are used and have to be installed:

* [NumPy 1.13.3](http://www.numpy.org). `pip3 install --user numpy==1.13.3`
* [Matplotlib 2.0.2](https://matplotlib.org). `pip3 install --user matplotlib==2.0.2`
* [Networkx 2.2](https://networkx.github.io)    `pip install --user networkx==2.2`
* [Pandas 0.23.4](https://pandas.pydata.org)    `pip install --user pandas==0.23.4`
* [PyGSP 0.5.1](https://pygsp.readthedocs.io/en/stable/) `pip install --user pygsp==0.5.1`
* [TQDM 4.28.1](https://github.com/tqdm/tqdm)    `pip install --user tqdm==4.28.1`

### Installing

To install the previously mentioned libraries a requirements.txt file is provided. The user is free to use it for installing the previously mentioned libraries.  


## Project Structure

The project has the following folder (and file) structure:

* `data/`. Directory containing original dataset from LINQS. [online] Linqs.soe.ucsc.edu. Available at: https://linqs.soe.ucsc.edu/node/236 [Accessed 11 Jan. 2019].

* `project/`. Folder containing the actual code files for the project:
    * `gephi/` Folder containing gephi files for visualization and exploration of the network.
    * `images/` Folder containing different images that are generated when running the different notebooks.
    * `fragmentation measures.py` Contains functions to compute fragmentation measures on the provided network.
    * `optimization_algorithms.py` Contains both optimization algorithms for fragmentation and information flow as well as the necessary functions to compute the respectives objective values. 
    * `data_exploration_functions.py` Contains several functions used for the import and parse of the data, creation of the network structure or identification of largest component among others.
    * `fragmentation.ipynb` Notebook containing initial data exploration as well as optimization task and results on the fragmentation problem. The provided notebook is already executed and shows the desired results.
    * `information_flow.ipynb` Notebook containing the data exploration and optimization task and results on the information diffusion problem. The provided notebook is already executed and shows the desired results. A new execution can take around 15 to 20 minutes. 
    * `adjacency.npy` Numpy file containing the structure of the adjacency matrix of the original network. Can be used to avoid creating it from scratch if a new execution of any of the two notebooks wants to be done. 

* `Report.pdf`
* `requirements.txt`


## How to execute the files.
	
Only fragmentation and information flow Notebooks are intended to be executed. All other files do not provide any directly readable result. The project has been developed so that fragmentation notebook is read first as it contains an initial exploration of the data. Nevertheless, information_flow notebook can be read and understood without need of previous consultation to the fragmentation notebook, taking into account the reader is aware of the purpose of the project.

## Authors

* **Brandimarte, Alexander** - 
* **Park, Jangwon** - 
* **Tata, Sowmya** - 
* **Ye, Tony** - 

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
