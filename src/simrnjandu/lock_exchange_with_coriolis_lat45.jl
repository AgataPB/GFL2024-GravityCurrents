using Oceananigans
using Oceananigans.Units

for k in 1:3
    for i in 1:5
        grid = RectilinearGrid(CPU(), size = (k*160, k*32), extent = (10000meters, 500meters), topology = (Bounded, Flat, Bounded))
            
        model = NonhydrostaticModel(; grid,
                                          advection = WENO(; grid),
                                          coriolis = FPlane(latitude = 45),
                                          closure = AnisotropicMinimumDissipation(),
                                          buoyancy = SeawaterBuoyancy(constant_salinity = true),
                                          tracers = (:T, :S))


        T0 = 9
        
        set!(model, T = function (x,z) T0 + 0.05 * tanh((x - 7000 + 4 * z) / (i*500)) end )
                
        simulation = Simulation(model; Δt = 50/k, stop_time = 20days)

        u, v, w = model.velocities
         
        outputs = (
                u  = @at((Center, Center, Center), u),
                v = @at((Center, Center, Center), v),
                w = @at((Center, Center, Center), w)
        )
        simulation.output_writers[:fields] = NetCDFOutputWriter(model, merge(outputs, model.tracers),
                                                                 filename = string("../../data/lat45/buoyancy_front_",k,"_", i,".nc"),
                                                                 schedule = TimeInterval(24minute),
                                                                 overwrite_existing = true)
                
        run!(simulation)    
    end
end