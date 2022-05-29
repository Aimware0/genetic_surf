-- References https://en.wikipedia.org/wiki/Genetic_algorithm , https://www.youtube.com/watch?v=9zfeTw-uFCw
include("agent.lua")
include("utils.lua")
local agents = {}

local me = function()
    for k, v in pairs(player.GetAll()) do
        if not v:IsBot() then
            return v
        end
    end
end

local function sort_by_fitness(a, b) if a and b then return a:GetFitness() > b:GetFitness() end end
local target = Vector(0, 2798, 10198)

local reset_timer = 10 -- When to reset the bots back to the start
local data_pool = {}

local function get_fitness(data)
    local lowest_dist = math.huge
    for _, v in pairs(data) do
        if v.pos then
            if v.pos:Distance(target) < lowest_dist then
                lowest_dist = v.pos:Distance(target)
            end
        end
    end
    return math.ceil(map(lowest_dist, 0, 3000, 100, 0))
end

local function get_best_fitness()
    local best_fitness = 0
    local best = nil
    for k, v in pairs(data_pool) do
        local fitness = get_fitness(v)
        if fitness > best_fitness then
            best_fitness = fitness
            best = v
        end
    end
    return best, best_fitness
end


timer.Create("reset_bots", reset_timer, 0, function()
    print("Resetting bots")
    for k, v in pairs(agents) do
        table.insert(data_pool, v:GetActions())
        v:Reset()
        v.actions = v:GenerateRandomActions(reset_timer)
    end
    best, best_fitness = get_best_fitness()
    print("Best fitness: " .. best_fitness)
    -- Sort the fitness of the agents.
    -- Entity:SetPreventTransmit( Player player, boolean stopTransmitting )
    -- Only allow the top 3 to transmit.
  
end)

hook.Add("PlayerSpawn", "setup_agent", function(ply)
    if ply:IsBot() and agents[ply:EntIndex()] == nil then
        local agent = Agent:new()
        agent.ply = ply
        agent:SetTarget(target)
        ply:SetVar("agent", agent)

        local index = ply:EntIndex()
        agents[index] = agent
        print("Agent " .. index .. " spawned")
    end
end)


hook.Add("StartCommand", "agent_think", function(ply, cmd)
    local agent = ply:GetVar("agent")

    if agent and not agents[ply:EntIndex()] then -- Check to make sure the agent is inside the agents table. On lua reload, agents table is cleared
        agents[ply:EntIndex()] = agent
    end

    if engine.TickCount() % 64 == 0 then
        -- if agent then
        --     agent:Think(cmd)
        -- end
        print("TickCount" .. cmd:TickCount())
    -- table.sort(agents, sort_by_fitness)

    end

    if agent then
        agent:Think(cmd)
    end

    for i = 1, #agents do
        local v = agents[i]
        if v then
            if i < 4 then
                v.ply:SetPreventTransmit(me(), false)
            else
                v.ply:SetPreventTransmit(me(), true)
            end
        end
    end

   
end)
