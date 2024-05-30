-----------------------------------
-- Area: Mount Zhayolm
--  ZNM: Claret
-- !pos 501 -9 53
-- Spawned with Pectin: !additem 2591
-- Wiki: https://www.bg-wiki.com/ffxi/Claret
-----------------------------------
mixins = { require('scripts/mixins/rage') }
-----------------------------------
local entity = {}

entity.onMobInitialize = function(mob)
    mob:setMobMod(xi.mobMod.IDLE_DESPAWN, 300)
    mob:setMobMod(xi.mobMod.TARGET_DISTANCE_OFFSET, 50) -- Stands right against player, but not on top of them.
    mob:addImmunity(xi.immunity.BIND)
    mob:addImmunity(xi.immunity.LIGHT_SLEEP)
    mob:addImmunity(xi.immunity.DARK_SLEEP)
    mob:addImmunity(xi.immunity.PETRIFY)
    mob:setSpeed(40)  -- TODO: Capture has chase speed at 148 and sub speed 40. 148 is way too fast, but 40 "feels" close enough for now, investigate this.
    mob:setMod(xi.mod.AURA_SIZE, 5) -- 5'
    mob:setMobMod(xi.mobMod.GIL_MIN, 3000)
    mob:setMobMod(xi.mobMod.GIL_MAX, 3000)
end

entity.onMobSpawn = function(mob)
    mob:setLocalVar('[rage]timer', 3600) -- 60 minutes
    mob:addMod(xi.mod.REGEN, math.floor(mob:getMaxHP() / 300)) -- 51/tick
    mob:addMod(xi.mod.REGAIN, 335) -- TPs every 9 seconds under 25%
    mob:setAutoAttackEnabled(false)
end

entity.onMobFight = function(mob, target)
    if mob:checkDistance(target) < 3 then
        if not target:hasStatusEffect(xi.effect.POISON) then
            mob:addStatusEffectEx(xi.effect.COLURE_ACTIVE, xi.effect.COLURE_ACTIVE, 9, 3, 0, xi.effect.POISON, 100, xi.auraTarget.ENEMIES, xi.effectFlag.AURA)
        else
            if target:getStatusEffect(xi.effect.POISON):getPower() < 100 then
                target:delStatusEffect(xi.effect.POISON)
                mob:addStatusEffectEx(xi.effect.COLURE_ACTIVE, xi.effect.COLURE_ACTIVE, 9, 3, 0, xi.effect.POISON, 100, xi.auraTarget.ENEMIES, xi.effectFlag.AURA)
            end
        end
    end
end

entity.onMobDeath = function(mob, player, optParams)
end

return entity
