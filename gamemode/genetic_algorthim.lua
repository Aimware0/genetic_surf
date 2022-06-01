-- References https://en.wikipedia.org/wiki/Genetic_algorithm , https://www.youtube.com/watch?v=9zfeTw-uFCw
include("agent.lua")
include("utils.lua")

-- local target = Vector(-2.672320, 1076.718994, 10084.031250)


function deep_copy_table(tbl)
    local new_tbl = {}
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            new_tbl[k] = deep_copy_table(v)
        else
            new_tbl[k] = v
        end
    end
    return new_tbl
end

 agents = {
    mating_pool = {},
    population = {},
    mutation_rate = 0.01,    
    

    AddAgent = function(self, agent)
        table.insert(self.population, agent)
    end,

    ClearAgents = function(self)
        self.population = {}
    end,

    CalcFitness = function(self)
        for _, v in pairs(self.population) do
            v:CalcFitness(target)
        end
    end,

    -- Clear the the agents table.

    NaturalSelection = function(self)
        self.mating_pool = {}
        for k, v in pairs(self.population) do
            local fitness = v:CalcFitness(target)
            if fitness then
                -- fitness = v.fell and fitness / 10 or fitness
                for i = 1, fitness do
                    table.insert(self.mating_pool, deep_copy_table(v.actions))
                end
            end
        end
    end,


    GetTopAgents = function(self)
        local top_agents = {}
        local sorted_agents = {}
        for k, v in pairs(self.population) do
            table.insert(sorted_agents, v)
        end
        table.sort(sorted_agents, function(a, b)
            return a.fitness > b.fitness
        end)
        for i = 1, math.floor(#sorted_agents * 0.01) do
            table.insert(top_agents, sorted_agents[i])
        end
        return top_agents
    end,
    

    Mutate = function(self, agent)
        for i=1, #agent.actions do
            if math.random() < self.mutation_rate then
                local props = {"pitch", "yaw", "forwardspeed", "sidemove"}
                local values = {
                    -- pitch = math.random(-89, 89),
                    -- yaw = math.random(-180, 180),
                    forwardspeed = math.random(0,1) == 1 and 450 or -450,
                    sidemove =math.random(0,1) == 1 and 450 or -450,
                }
                local prop_to_mutate = props[math.random(1, #props)]
                agent.actions[i][prop_to_mutate] = values[prop_to_mutate]
            end
        end

    end,

    Breed = function(self)
        print("Agents inside the mating pool: " .. #self.mating_pool)
        print("Agents inside the population: " .. #self.population)
        for i = 1, #self.population do
            local random_actions1 = self.mating_pool[math.random(1, #self.mating_pool)]
            local random_actions2 = self.mating_pool[math.random(1, #self.mating_pool)]
            if not random_actions1 or not random_actions2 then print(696969) return end

            -- Check to make sure that all the agents are not the same.
            local iteration = 0
            while random_actions1  == random_actions2 do
                random_actions2 = self.mating_pool[math.random(1, #self.mating_pool)]
                if iteration == #self.mating_pool then
                    print("Hmm seems like all the agents are the same in the mating pool. This is not good. ")
                    break
                end
                iteration = iteration + 1
            end
            
            local mid_point = math.random(1, #random_actions1)

            for j=1, #random_actions1 do
                -- local r1 = math.random() > 0.5 and random_actions1[j].forwardspeed or random_actions2[j].forwardspeed
                -- local r2 = math.random() > 0.5 and random_actions1[j].sidemove or random_actions2[j].sidemove
                
                -- self.population[i].actions[j].forwardspeed = r1
                -- self.population[i].actions[j].sidemove = r2

                if j < mid_point then -- this probably needs a rework
                    self.population[i].actions[j].forwardspeed = random_actions1[j].forwardspeed
                    self.population[i].actions[j].sidemove = random_actions1[j].sidemove
                else
                    self.population[i].actions[j].forwardspeed = random_actions2[j].forwardspeed
                    self.population[i].actions[j].sidemove = random_actions2[j].sidemove
                end
            end

            self:Mutate(self.population[i])
        end
    end,

    
}


local reset_timer = 15 -- When to reset the bots back to the start
local generation = 0 -- How many generations have passed

timer.Create("reset_bots", reset_timer, 0, function()
    -- Get number of bots
    local num_bots = #player.GetAll() - 1 -- Assumes that we are the only player in the server
    if num_bots == 0 then return end
    print("Resetting bots")

    for k, v in pairs(agents.population) do
        v:Reset()
        if generation == 0 then
            v.actions = v:GenerateRandomActions(reset_timer)
        end
    end

    if generation > 0 then
        agents:CalcFitness()
        agents:NaturalSelection()
        agents:Breed()
        print("Generation: " .. tostring(generation))
    end

    generation = generation + 1
end)


hook.Add( "OnTeleport", "reset", function()
    local activator, caller = ACTIVATOR, CALLER
    local agent = activator:GetVar("agent")
    agent.fell = true
    agent.times_fell = agent.times_fell + 1
end)


hook.Add("PlayerSpawn", "setup_agent", function(ply)
    if ply:IsBot() and agents[ply:EntIndex()] == nil then
        local agent = Agent:new()
        agent.ply = ply
        ply:SetVar("agent", agent)

        local index = ply:EntIndex()
        agents:AddAgent(agent)
        print("Agent " .. index .. " spawned")
    end
end)


hook.Add("StartCommand", "agent_think", function(ply, cmd)
    local agent = ply:GetVar("agent")

    if agent and not agents[ply:EntIndex()] then -- Check to make sure the agent is inside the agents table. On lua reload, agents table is cleared
        agents[ply:EntIndex()] = agent
    end

    if agent then
        agent:Think(cmd)
    end
end)
