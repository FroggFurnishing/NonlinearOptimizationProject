# Small data file to show how one can import julia files into other julia files.
# For example, this gives a convenient way to create files containing all the data for a problem.

#n_vars_first_dimension = 2 # Number of variables in first dimension
#n_vars_second_dimension = 2 # Number of variables in second dimension
#lb = 0 # Lower bounds for the varaibles; same for all of them
#ub = [[3, 2] [4, 1]] # Upper bounds for the variables
#sum_bound = 7.75 # Constraint on sum of variables


generator_nodes = [2, 2, 2, 3, 4, 5, 7, 9, 9]
generator_capacities = [0.02, 0.15, 0.08, 0.07, 0.04, 0.17, 0.17, 0.26, 0.05]
generator_costs = [175, 100, 150, 150, 300, 350, 400, 300, 200]


node_demands = [0.10, 0, 0, 0.19, 0, 0.11, 0, 0.09, 0.21, 0.05, 0.04]

generator_index = 1:9
customer_index = 1:7
node_index = 1:11

# vi behöver hårdkoda två 11x11 matriser där elementen är 0 om det inte finns en väg mellan noderna och annars är värdet på Gkl/Bkl som ges av tabellen i labb-beskrivningen
# sen kan vi räkna på customer demand = local_power_used + sum(incoming Pkl)
# Reactive power intervall för alla noder

#11x11 matriser med Bkl värdena
B = [
    0 -20.1 0 0 0 0 0 0 0 0 -22.3;
    -20.1 0 -16.8 0 0 0 0 0 0 0 -17.2;
    0 -16.8 0 -11.7 0 0 0 0 -19.4 0 0;
    0 0 -11.7 0 -10.8 0 0 0 0 0 0;
    0 0 0 -10.8 0 -12.3 0 -9.2 0 0 0;
    0 0 0 0 -12.3 0 -13.9 0 0 0 0;
    0 0 0 0 0 -13.9 0 -8.7 -11.3 0 0;
    0 0 0 0 -9.2 0 -8.7 0 -7.7 0 0;
    0 0 -19.4 0 0 0 -11.3 -7.7 0 -13.5 0;
    0 0 0 0 0 0 0 0 -13.5 0 -26.7;
    -22.3 -17.2 0 0 0 0 0 0 0 -26.7 0
]
G = [
    0 4.12 0 0 0 0 0 0 0 0 5.67;
    4.12 0 2.41 0 0 0 0 0 0 0 2.78;
    0 2.41 0 1.98 0 0 0 0 3.23 0 0;
    0 0 1.98 0 1.59 0 0 0 0 0 0;
    0 0 0 1.59 0 1.71 0 1.26 0 0 0;
    0 0 0 0 1.71 0 1.11 0 0 0 0;
    0 0 0 0 0 1.11 0 1.32 2.01 0 0;
    0 0 0 0 1.26 0 1.32 0 4.41 0 0;
    0 0 3.23 0 0 0 2.01 4.41 0 2.14 0;
    0 0 0 0 0 0 0 0 2.14 0 5.06;
    5.67 2.78 0 0 0 0 0 0 0 5.06 0
]
