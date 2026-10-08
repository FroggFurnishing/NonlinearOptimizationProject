using JuMP
import Ipopt

include("data.jl")

the_model = Model(Ipopt.Optimizer)

@variable( # Power produced by generator i
    the_model,
    0 <= produced_power[i=generator_index] <= generator_capacities[i],
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
    0 <= local_power_used[i=generator_index] <= generator_capacities[i]
)

@constraint(the_model, [i in generator_index], local_power_used[i] <= produced_power[i])



@variable( # output power
    the_model,
    0 <= output_power[i = generator_index] <= generator_capacities[i]) 

@constraint(the_model, [i in generator_index],
output_power[i] <= produced_power[i] - local_power_used[i]
)

@objective(
    the_model,
    Min,
    sum(
        generator_costs[i]*produced_power[i]
        for i in generator_index
    )
)



@constraint( # customer demand =  (produced_power used by own node) + sum(incoming Pkl)
    the_model, [k in node_index, l in node_index, k != l],
    customer_demands[l] == local_power_used[l] + (voltage_amplitute[k]^2) * G[k][l] - voltage_amplitute[k] * voltage_amplitute[l] * G[k][l] * cos(voltage_angle[k] - voltage_angle[l]) - voltage_amplitute[k] * voltage_amplitute[l] * B[k][l] * sin(voltage_angle[k] - voltage_angle[l])
)

@constraint( # -0.03 * (generator capacity) <= incoming reactive power <= 0.03 (generator_capacity)
    the_model,[k in generator_index],
    -0.03 * generator_capacities[generator_index] <= -(voltage_amplitute[k]^2) * B[k][generator_index] + voltage_amplitute[k] * voltage_amplitute[generator_index] * B[k][generator_index] * cos(voltage_angle[k] - voltage_angle[generator_index]) - voltage_amplitute[k] * voltage_amplitute[generator_index] * G[k][generator_index] * sin(voltage_angle[k] - voltage_angle[generator_index])
)

#@constraint( # 0 <= outgoing active power <= (output power from node i)
#    the_model,
#    0 <= 
#)

println(the_model)

optimize!(the_model)

println("") # Printing white line after solver output, before printing
println("Termination status: ", termination_status(the_model))
println("Optimal objective function value: ", objective_value(the_model))
#println("Optimal point: ", value.(x))
#println("Dual variables/Lagrange multipliers corresponding to some constraints:")
#println(dual(SOS_constr))
#println(dual.(ub_constr))
#println(dual.(LowerBoundRef.(x)))

