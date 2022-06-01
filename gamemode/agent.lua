-- Represents one in game bot
Agent = {
    actions = {},
    action_index = 1,
    fitness = 0,
    fell = false,
    tick = 0,
    switch = true,
    times_fell = 0,
}


local respawn_point = spawn_pos -- Where the bots respawn

function Agent:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Agent:GetAvgDistance(target)
    local sum = 0
    for i, v in ipairs(self.actions) do
        if v.pos then
            sum = sum + v.pos:Distance(target)
        end     
    end
    print("Sum of average distance is " .. tostring(sum))
    return sum / #self.actions
end

function Agent:GetLowestDistance(target)
    local lowest_dist = math.huge
    local lowest = nil
    for i, v in ipairs(self.actions) do
        if v.pos then
            local distance = v.pos:Distance(target)
            if distance < lowest_dist then
                lowest = v
                lowest_dist = distance
            end
        end
    end
    return lowest_dist, lowest
end

function Agent:CalcFitness(target)
    local lowest_dist, lowest = self:GetLowestDistance(target)
    local fitness = math.floor(map(lowest_dist , 0, respawn_point:Distance(target), 30, 0))
    fitness = fitness * math.floor(map(CurTime() - lowest.time, 0, 15, 2, 1))
    -- Reduce the fitness if the bot fell often.
    if self.times_fell > 0 then
        fitness = fitness / self.times_fell
    end
    self.fitness = fitness
    return fitness
end



function Agent:AddAction(action)
    table.insert(self.actions, action)
end

function Agent:GetActions()
    return self.actions
end

function Agent:ClearActions()
    self.actions = {}
    self.action_index = 1
end

function Agent:GetRandomAction()
    return {
        -- pitch = math.random(-89, 89),
        -- yaw = math.random(-180, 180),
        
       

        forwardspeed = math.random(0,1) == 1 and 450 or -450,
        sidemove = math.random(0,1) == 1 and 450 or -450,

         pitch = 0,
        yaw = 0,
        -- forwardspeed = 0,
        -- sidemove = 0,
    }
end

function Agent:Reset()
    self.ply:SetPos(spawn_pos)
    self.action_index = 1
    self.fell = false
end

local j = 0

function Agent:GenerateRandomActions(seconds)

    local actions = {}
    local tickrate = 1 / engine.TickInterval()
    local ticks = seconds * tickrate
    for i = 1, ticks do
        if ticks % 33 == 0 then
            self.switch = not self.switch
        end
        if self.switch then
            table.insert(actions, self:GetRandomAction())
        else
            table.insert(actions, self:GetActions()[#self.actions])
        end
    end
    return actions
end



function Agent:Think(cmd)
    if #self.actions >= self.action_index then
        -- print(1)
        local action = self.actions[self.action_index]
        cmd:SetViewAngles(Angle(action.pitch, action.yaw, 0))
        cmd:SetForwardMove(action.forwardspeed)
        cmd:SetSideMove(action.sidemove)
        if self.action_index > 1 then
            self.actions[self.action_index-1].pos = self.ply:GetPos()
            self.actions[self.action_index-1].time = CurTime()
        else
            self.actions[self.action_index].pos = self.ply:GetPos()
        end
        self.action_index = self.action_index + 1
    else
        -- print("All out.", #self.actions, self.action_index)
    end
end

function GM:PlayerSpawn()
end
