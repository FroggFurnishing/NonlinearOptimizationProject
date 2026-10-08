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

@constraint( # customer demand =  (produced_power used by own node) + sum(incoming Pkl)
    the_model,
    customer_demands[customer_index] = local_power_used[customer_index] + (voltage_amplitute[k]^2) * G[k][customer_index] - voltage_amplitute[k] * voltage_amplitute[customer_index] * G[k][customer_index] * cos(voltage_angle[k] - voltage_angle[customer_index]) - voltage_amplitute[k] * voltage_amplitute[customer_index] * B[k][customer_index] * sin(voltage_angle[k] * voltage_angle[customer_index])
)

@constraint( # -0.03 * (generator capacity) <= incoming reactive power <= 0.03 (generator_capacity)
    the_model,
    -0.03 * generator_capacities[generator_index] <= -(voltage_amplitute[k]^2) * B[k][generator_index] + voltage_amplitute[k] * voltage_amplitute[generator_index] * B[k][generator_index] * cos(voltage_angle[k] - voltage_angle[generator_index]) - voltage_amplitute[k] * voltage_amplitute[generator_index] * G[k][generator_index] * sin(voltage_angle[k] - voltage_angle[generator_index])
)

# 0 <= outgoing active power <= (output power from node i)

