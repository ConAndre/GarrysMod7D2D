AddCSLuaFile("shared.lua")

include("shared.lua")


net.Receive("ixShipmentUse", function(length, client)
    local uniqueID = net.ReadString()
    local drop = net.ReadBool()

    local entity = client.ixShipment
    local itemTable = ix.item.list[uniqueID]

    if (itemTable and IsValid(entity)) then
        if (entity:GetPos():Distance(client:GetPos()) > 128) then
            client.ixShipment = nil

            return
        end

        local amount = entity.items[uniqueID]

        if (amount and amount > 0) then
            if (entity.items[uniqueID] <= 0) then
                entity.items[uniqueID] = nil
            end

            if (drop) then
                ix.item.Spawn(uniqueID, entity:GetPos() + Vector(0, 0, 16), function(item, itemEntity)
                    if (IsValid(client)) then
                        itemEntity.ixSteamID = client:SteamID()
                        itemEntity.ixCharID = client:GetCharacter():GetID()
                    end
                end)
            else
                local status, _ = client:GetCharacter():GetInventory():Add(uniqueID)

                if (!status) then
                    return client:NotifyLocalized("noFit")
                end
            end

            hook.Run("ShipmentItemTaken", client, uniqueID, amount)

            entity.items[uniqueID] = entity.items[uniqueID] - 1

            if (entity:GetItemCount() < 1) then
                entity:GibBreakServer(Vector(0, 0, 0.5))
                entity:Remove()
            end
        end
    end
end)

net.Receive("ixShipmentClose", function(length, client)
    local entity = client.ixShipment

    if (IsValid(entity)) then
        entity.ixInteractionDirty = false
        client.ixShipment = nil
    end
end)
net.Receive("ixShipmentOpen", function()
    local entity = net.ReadEntity()
    local items = net.ReadTable()

    ix.gui.shipment = vgui.Create("ixShipment")
    ix.gui.shipment:SetItems(entity, items)
end)
