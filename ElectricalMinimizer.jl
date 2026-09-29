using JuMP
import Ipopt

include("data.jl")

the_model = Model(Ipopt.Optimizer)

@variable( # Power produced by generator i
    the_model,
    0 <= produced_power[generator_index] <= generator_capacities[generator_index],
)

@variable( # voltage_amplitute
    the_model,
    0.98 <= voltage_amplitute[node_index] <= 1.02
)

@variable( # voltage_angle
    the_model,
    -pi <= voltage_angle[node_index] <= pi
)

@variable( # produced power used by own node
    the_model,
    0 <= local_power_used[generator_index] <= produced_power[generator_index]
)


@variable( # output power
    the_model,
    0 <= output_power[generator_index] <= produced_power[generator_index] - local_power_used[generator_index]
)



@objective(
    the_model,
    Min,
    sum(
        generator_costs[i]*produced_power[i]
        for i in G
    )
)



# customer_demand = (produced_power used by own node) + sum(incoming Pkl)

# 0 <= outgoing active power <= (output power from node i)

# -0.03 * (generator capacity) <= incoming reactive power <= 0.03 (generator_capacity)