# Small data file to show how one can import julia files into other julia files.
# For example, this gives a convenient way to create files containing all the data for a problem.

#n_vars_first_dimension = 2 # Number of variables in first dimension
#n_vars_second_dimension = 2 # Number of variables in second dimension
#lb = 0 # Lower bounds for the varaibles; same for all of them
#ub = [[3, 2] [4, 1]] # Upper bounds for the variables
#sum_bound = 7.75 # Constraint on sum of variables




generators = [[2, 0.02, 175] [2, 0.15, 100] [2, 0.08, 150] [3, 0.07, 150] [4, 0.04, 300] [5, 0.17, 350] [7, 0.17, 400] [9, 0.26, 300] [9, 0.05, 200]]

customers = [[1, 0.10] [4, 0.19] [6, 0.11] [8, 0.09] [9, 0.21] [10, 0.05] [11, 0.04]]