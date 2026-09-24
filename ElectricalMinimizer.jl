using JuMP
import Ipopt

include("data.jl")

the_model = Model(Ipopt.Optimizer)

@variable(
    the_model,
    0 <= produced_power[i in G] <= generator_capacities[G]
)

@objective(
    the_model,
    Min,
    sum(
        generator_costs[i]*produced_power[i]
        for i in G
    )
)

@constraint( # Constraint for voltage_angle 
    the_model,
    -pi <= voltage_angle[i in node_index] <= pi
)

@constraint(
    the_model,
    0.98 <= voltage_amplitute[i in node_index] <= 1.02
)