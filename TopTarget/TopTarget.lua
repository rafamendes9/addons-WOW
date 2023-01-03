-- TopTarget by Vaeyn@PVPXTV https://www.curseforge.com/members/pvpxtv/projects

local TT_IN = nil
local TT_ZN = nil
local TT_NPU = C_NamePlate.GetNamePlateForUnit

local TT_NPTG = nil
local TT_NPTG_ICK = "TopTarget_TGICK"
local TT_NPTG_ICI = "Interface\\AddOns\\TopTarget\\Media\\Icons\\toptarget-enemy.tga"
local TT_NPOT_ICI = "Interface\\AddOns\\TopTarget\\Media\\Icons\\onlytarget-enemy.tga"

local TT_NPLH = nil
local TT_NPLH_ICK = "TopTarget_LHICK"
local TT_NPLH_ICI = "Interface\\AddOns\\TopTarget\\Media\\Icons\\lowhp-enemy.tga"

local TT_NPLM = nil
local TT_NPLM_ICK = "TopTarget_LMICK"
local TT_NPLM_ICI = {}
TT_NPLM_ICI[1] = { TT_NPLM_ICI_TX = "Interface\\AddOns\\TopTarget\\Media\\Icons\\lowmana1-enemy.tga" }
TT_NPLM_ICI[2] = { TT_NPLM_ICI_TX = "Interface\\AddOns\\TopTarget\\Media\\Icons\\lowmana2-enemy.tga" }
TT_NPLM_ICI[3] = { TT_NPLM_ICI_TX = "Interface\\AddOns\\TopTarget\\Media\\Icons\\lowmana3-enemy.tga" }
TT_NPLM_ICI[4] = { TT_NPLM_ICI_TX = "Interface\\AddOns\\TopTarget\\Media\\Icons\\lowmana4-enemy.tga" }

local TT_NPRI = nil
local TT_NPRI_ICK = "TopTarget_RIICK"
local TT_NPRI_ICI = {}
TT_NPRI_ICI[1] = { TT_NPRI_ICI_TX = "Interface\\AddOns\\TopTarget\\Media\\Icons\\raid1-enemy.tga" }
TT_NPRI_ICI[2] = { TT_NPRI_ICI_TX = "Interface\\AddOns\\TopTarget\\Media\\Icons\\raid2-enemy.tga" }
TT_NPRI_ICI[3] = { TT_NPRI_ICI_TX = "Interface\\AddOns\\TopTarget\\Media\\Icons\\raid3-enemy.tga" }
TT_NPRI_ICI[4] = { TT_NPRI_ICI_TX = "Interface\\AddOns\\TopTarget\\Media\\Icons\\raid4-enemy.tga" }
TT_NPRI_ICI[5] = { TT_NPRI_ICI_TX = "Interface\\AddOns\\TopTarget\\Media\\Icons\\raid5-enemy.tga" }
TT_NPRI_ICI[6] = { TT_NPRI_ICI_TX = "Interface\\AddOns\\TopTarget\\Media\\Icons\\raid6-enemy.tga" }
TT_NPRI_ICI[7] = { TT_NPRI_ICI_TX = "Interface\\AddOns\\TopTarget\\Media\\Icons\\raid7-enemy.tga" }
TT_NPRI_ICI[8] = { TT_NPRI_ICI_TX = "Interface\\AddOns\\TopTarget\\Media\\Icons\\raid8-enemy.tga" }

local TT_EVT_FRM = CreateFrame("Frame")
TT_EVT_FRM:HookScript("OnEvent", function(self, event, ...)

	if TT_NPTG and TT_NPTG[TT_NPTG_ICK] then
		TT_NPTG[TT_NPTG_ICK]:Hide()
		TT_NPTG[TT_NPTG_ICK] = nil
		TT_NPTG = nil
	end
	
	if TT_NPLH and TT_NPLH[TT_NPLH_ICK] then
		TT_NPLH[TT_NPLH_ICK]:Hide()
		TT_NPLH[TT_NPLH_ICK] = nil
		TT_NPLH = nil
	end
	
	if TT_NPLM and TT_NPLM[TT_NPLM_ICK] then
		TT_NPLM[TT_NPLM_ICK]:Hide()
		TT_NPLM[TT_NPLM_ICK] = nil
		TT_NPLM = nil
	end
	
	if TT_NPRI and TT_NPRI[TT_NPRI_ICK] then
		TT_NPRI[TT_NPRI_ICK]:Hide()
		TT_NPRI[TT_NPRI_ICK] = nil
		TT_NPRI = nil
	end
	
	if event == "ZONE_CHANGED" or event == "ZONE_CHANGED_INDOORS" or event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD" then
		_, TT_IN = IsInInstance()
		TT_ZN, _, _ = GetZonePVPInfo()
	end
	
	if IsInGroup() and ((TT_IN and (TT_IN == "arena" or TT_IN == "pvp")) or (TT_ZN and TT_ZN ~= "sanctuary") or (TT_IN and TT_IN == "none" and not TT_ZN)) and (event == "NAME_PLATE_UNIT_ADDED" or event == "PLAYER_STARTED_MOVING" or event == "PLAYER_STOPPED_MOVING" or event == "PLAYER_STARTED_LOOKING" or event == "PLAYER_STOPPED_LOOKING" or event == "PLAYER_STARTED_TURNING" or event == "PLAYER_STOPPED_TURNING" or event == "UNIT_HEALTH" or event == "UNIT_ABSORB_AMOUNT_CHANGED" or event == "UNIT_POWER_UPDATE") then

		local TT_RITB = {}
		local TT_TGTB = {}
		local TT_GRPNUM = GetNumGroupMembers()
		local TT_GRPRD_F = false
		local TT_GRPRI_F = false
		local TT_FRTGNM_F = false
		
		for i = 1, TT_GRPNUM do
			
			local TT_FRNM = nil
			local TT_FRCR = nil
			if IsInRaid() then
				TT_GRPRD_F = true
				TT_FRNM, _, _, _, _, _, _, _, _, _, _, TT_FRCR = GetRaidRosterInfo(i);
			else
				TT_FRNM = GetUnitName("party" .. i, true)
				TT_FRCR = UnitGroupRolesAssigned(TT_FRNM)
			end
			
			if TT_FRNM and UnitIsConnected(TT_FRNM) and not UnitIsDeadOrGhost(TT_FRNM) and not UnitIsDeadOrGhost("player") and TT_FRCR ~= "HEALER" and TT_FRCR ~= "TANK" and UnitInRange(TT_FRNM) and GetUnitName("player", true) ~= TT_FRNM then

				local TT_FRTG = TT_FRNM .. "-target"

				if UnitIsPlayer(TT_FRTG) and UnitIsEnemy("player", TT_FRTG) and UnitInRange("player", TT_FRTG) and UnitCanAttack("player", TT_FRTG) then

					local TT_FRTGNM = GetUnitName(TT_FRTG, true)
					if TT_FRTGNM then

						TT_FRTGNM_F = true
						
						if TT_GRPRD_F then
						
							local TT_FRRI = GetRaidTargetIndex(TT_FRNM)
							if TT_RITB and TT_FRRI and TT_FRRI >= 1 and TT_FRRI <= 8 then
								TT_GRPRI_F = true
								TT_RITB[TT_FRRI] = { TT_TRRITG = TT_FRTG }
							end
						end

						if TT_TGTB then
						
							local TT_TRCTV = 1
							local TT_TRDMV = 0
							local TT_TRMNV = 0
							local TT_TRTGNMV = nil
							local TT_TRTGV = nil
							local TT_TRHPCRV = nil
							local TT_TRHPMXV = nil
							local TT_TRMNCRV = nil
							local TT_TRMNMXV = nil
					
							if TT_TGTB[TT_FRTGNM] then
							
								TT_TRCTV = TT_TGTB[TT_FRTGNM].TT_TRCT
								TT_TRDMV = TT_TGTB[TT_FRTGNM].TT_TRDM
								TT_TRMNV = TT_TGTB[TT_FRTGNM].TT_TRMN
								TT_TRTGNMV = TT_TGTB[TT_FRTGNM].TT_TRTGNM
								TT_TRTGV = TT_TGTB[TT_FRTGNM].TT_TRTG

								if TT_TRCTV and TT_TRDMV and TT_TRMNV and TT_TRTGNMV and TT_TRTGV then
							
									TT_TRCTV = TT_TRCTV + 1
							
									TT_TGTB[TT_FRTGNM] = { TT_TRCT = TT_TRCTV, TT_TRDM = TT_TRDMV, TT_TRMN = TT_TRMNV, TT_TRTGNM = TT_TRTGNMV, TT_TRTG = TT_TRTGV }
								end
								
							else
							
								TT_TRHPCRV = UnitHealth(TT_FRTG)
								TT_TRHPMXV = UnitHealthMax(TT_FRTG)
								if TT_TRHPCRV and TT_TRHPMXV and TT_TRHPCRV > 0 and TT_TRHPMXV > 0 and TT_TRHPMXV > TT_TRHPCRV then
									TT_TRDMV = math.floor(100-((TT_TRHPCRV/TT_TRHPMXV)*100))
								end
								
								TT_TRMNCRV = UnitPower(TT_FRTG, Enum.PowerType.Mana)
								TT_TRMNMXV = UnitPowerMax(TT_FRTG, Enum.PowerType.Mana)
								if TT_TRMNCRV and TT_TRMNMXV and TT_TRMNCRV > 0 and TT_TRMNMXV > 0 and TT_TRMNMXV > TT_TRMNCRV then
									TT_TRMNV = math.floor(100-((TT_TRMNCRV/TT_TRMNMXV)*100))
								end

								TT_TGTB[TT_FRTGNM] = { TT_TRCT = TT_TRCTV, TT_TRDM = TT_TRDMV, TT_TRMN = TT_TRMNV, TT_TRTGNM = TT_FRTGNM, TT_TRTG = TT_FRTG }

							end
						end
					end
				end
			end
		end
		
		if TT_FRTGNM_F and TT_TGTB then
		
			local TT_TGTB_CT = 0
			
			local TT_TGTB_LH_MAXDMK_F = false
			local TT_TGTB_LM_MAXMNK_F = false
			
			local TT_TGTB_MAXCT, TT_TGTB_MAXCTK = -math.huge
			local TT_TGTB_LH_MAXDM, TT_TGTB_LH_MAXDMK = -math.huge
			local TT_TGTB_LM_MAXMN, TT_TGTB_LM_MAXMNK = -math.huge
			
			for k,v in pairs(TT_TGTB) do
			
				TT_TGTB_CT = TT_TGTB_CT + 1
			
				if v.TT_TRCT > TT_TGTB_MAXCT then
					TT_TGTB_MAXCT, TT_TGTB_MAXCTK = v.TT_TRCT, k
				end

				if v.TT_TRDM > TT_TGTB_LH_MAXDM then
					TT_TGTB_LH_MAXDMK_F = true
					TT_TGTB_LH_MAXDM, TT_TGTB_LH_MAXDMK = v.TT_TRDM, k
				end

				if v.TT_TRMN >= 70 and v.TT_TRMN > TT_TGTB_LM_MAXMN then
					TT_TGTB_LM_MAXMNK_F = true
					TT_TGTB_LM_MAXMN, TT_TGTB_LM_MAXMNK = v.TT_TRMN, k
				end
			end
			
			local TT_TGTB_TG_MAXDMCT = 0
			local TT_TGTB_TG_MAXDMK_F = false
			local TT_TGTB_TG_MAXDM, TT_TGTB_TG_MAXDMK = -math.huge
			
			local TT_TGTB_LM_MAXDMCT = 0
			local TT_TGTB_LM_MAXDMK_F = false
			local TT_TGTB_LM_MAXDM, TT_TGTB_LM_MAXDMK = -math.huge
			
			for k,v in pairs(TT_TGTB) do

				if v.TT_TRCT == TT_TGTB_MAXCT and v.TT_TRDM > TT_TGTB_TG_MAXDM then
					TT_TGTB_TG_MAXDMCT = TT_TGTB_TG_MAXDMCT + 1
					if TT_TGTB_TG_MAXDMCT > 1 then
						TT_TGTB_TG_MAXDMK_F = true
					end
					TT_TGTB_TG_MAXDM, TT_TGTB_TG_MAXDMK = v.TT_TRDM, k
				end
				
				if v.TT_TRMN == TT_TGTB_LM_MAXMN and v.TT_TRDM > TT_TGTB_LM_MAXDM then
					TT_TGTB_LM_MAXDMCT = TT_TGTB_LM_MAXDMCT + 1
					if TT_TGTB_LM_MAXDMCT > 1 then
						TT_TGTB_LM_MAXDMK_F = true
					end
					TT_TGTB_LM_MAXDM, TT_TGTB_LM_MAXDMK = v.TT_TRDM, k
				end
			end
			
			local TT_TGTB_TGK = nil
			if TT_TGTB_TG_MAXDMK_F then
				TT_TGTB_TGK = TT_TGTB_TG_MAXDMK
			else
				TT_TGTB_TGK = TT_TGTB_MAXCTK
			end

			if TT_TGTB_TGK and TT_TGTB[TT_TGTB_TGK] then
			
				local TT_TG = TT_TGTB[TT_TGTB_TGK].TT_TRTG
				
				if TT_TG then
				
					TT_NPTG = TT_NPU(TT_TG)
					
					if TT_NPTG then
					
						local TT_NPTG_IC = TT_NPTG[TT_NPTG_ICK]
						if not TT_NPTG_IC then
							TT_NPTG_IC = TT_NPTG:CreateTexture(nil, "OVERLAY")
							TT_NPTG_IC:SetPoint("CENTER", 0, 0)
							TT_NPTG_IC:SetSize(128, 128)
							TT_NPTG[TT_NPTG_ICK] = TT_NPTG_IC
						end
						if TT_TGTB_CT > 1 then
							TT_NPTG_IC:SetTexture(TT_NPTG_ICI)
						elseif TT_TGTB_CT == 1 then
							TT_NPTG_IC:SetTexture(TT_NPOT_ICI)
						end
						TT_NPTG_IC:Show()
					end
				end
			end
			
			if TT_TGTB_LH_MAXDMK_F and TT_TGTB_LH_MAXDMK and TT_TGTB[TT_TGTB_LH_MAXDMK] then
			
				local TT_LH = TT_TGTB[TT_TGTB_LH_MAXDMK].TT_TRTG
				
				if TT_LH then
				
					TT_NPLH = TT_NPU(TT_LH)
					
					if TT_NPLH then
					
						local TT_NPLH_IC = TT_NPLH[TT_NPLH_ICK]
						if not TT_NPLH_IC then
							TT_NPLH_IC = TT_NPLH:CreateTexture(nil, "OVERLAY")
							TT_NPLH_IC:SetPoint("CENTER", 0, 0)
							TT_NPLH_IC:SetSize(128, 128)
							TT_NPLH[TT_NPLH_ICK] = TT_NPLH_IC
						end
						TT_NPLH_IC:SetTexture(TT_NPLH_ICI)
						TT_NPLH_IC:Show()
					end
				end
			end

			local TT_TGTB_MNK = nil
			if TT_TGTB_LM_MAXDMK_F then
				TT_TGTB_MNK = TT_TGTB_LM_MAXDMK
			else
				TT_TGTB_MNK = TT_TGTB_LM_MAXMNK
			end
			
			if TT_TGTB_LM_MAXMNK_F and TT_TGTB_MNK and TT_TGTB[TT_TGTB_MNK] then
			
				local TT_LM = TT_TGTB[TT_TGTB_MNK].TT_TRTG
				
				if TT_LM then
				
					TT_NPLM = TT_NPU(TT_LM)
					
					if TT_NPLM then
					
						local TT_NPLM_IC = TT_NPLM[TT_NPLM_ICK]
						if not TT_NPLM_IC then
							TT_NPLM_IC = TT_NPLM:CreateTexture(nil, "OVERLAY")
							TT_NPLM_IC:SetPoint("CENTER", 0, 0)
							TT_NPLM_IC:SetSize(128, 128)
							TT_NPLM[TT_NPLM_ICK] = TT_NPLM_IC
						end
						if TT_TGTB_LM_MAXMN >= 70 and TT_TGTB_LM_MAXMN < 80 then
							TT_NPLM_IC:SetTexture(TT_NPLM_ICI[1].TT_NPLM_ICI_TX)
						elseif TT_TGTB_LM_MAXMN >= 80 and TT_TGTB_LM_MAXMN < 90 then
							TT_NPLM_IC:SetTexture(TT_NPLM_ICI[2].TT_NPLM_ICI_TX)
						elseif TT_TGTB_LM_MAXMN >= 90 and TT_TGTB_LM_MAXMN < 95 then
							TT_NPLM_IC:SetTexture(TT_NPLM_ICI[3].TT_NPLM_ICI_TX)
						elseif TT_TGTB_LM_MAXMN >= 95 and TT_TGTB_LM_MAXMN <= 100 then
							TT_NPLM_IC:SetTexture(TT_NPLM_ICI[4].TT_NPLM_ICI_TX)
						end
						TT_NPLM_IC:Show()
					end
				end
			end
			
			if TT_GRPRD_F and TT_GRPRI_F and TT_RITB then
				
				for i = 8,1,-1 do
				   	if TT_RITB[i] and TT_RITB[i].TT_TRRITG then
					
						TT_NPRI = TT_NPU(TT_RITB[i].TT_TRRITG)
						
						if TT_NPRI then
						
							local TT_NPRI_IC = TT_NPRI[TT_NPRI_ICK]
							if not TT_NPRI_IC then
								TT_NPRI_IC = TT_NPRI:CreateTexture(nil, "OVERLAY")
								TT_NPRI_IC:SetPoint("CENTER", 0, 0)
								TT_NPRI_IC:SetSize(128, 128)
								TT_NPRI[TT_NPRI_ICK] = TT_NPRI_IC
							end
							TT_NPRI_IC:SetTexture(TT_NPRI_ICI[i].TT_NPRI_ICI_TX)
							TT_NPRI_IC:Show()
						end
						break
					end
				end
			end
		end
	end
end)

TT_EVT_FRM:RegisterEvent("PLAYER_ENTERING_WORLD")
TT_EVT_FRM:RegisterEvent("ZONE_CHANGED")
TT_EVT_FRM:RegisterEvent("ZONE_CHANGED_INDOORS")
TT_EVT_FRM:RegisterEvent("ZONE_CHANGED_NEW_AREA")
TT_EVT_FRM:RegisterEvent("NAME_PLATE_UNIT_ADDED")
TT_EVT_FRM:RegisterEvent("PLAYER_STARTED_MOVING")
TT_EVT_FRM:RegisterEvent("PLAYER_STOPPED_MOVING")
TT_EVT_FRM:RegisterEvent("PLAYER_STARTED_LOOKING")
TT_EVT_FRM:RegisterEvent("PLAYER_STOPPED_LOOKING")
TT_EVT_FRM:RegisterEvent("PLAYER_STARTED_TURNING")
TT_EVT_FRM:RegisterEvent("PLAYER_STOPPED_TURNING")
TT_EVT_FRM:RegisterUnitEvent("UNIT_HEALTH", "target")
TT_EVT_FRM:RegisterUnitEvent("UNIT_ABSORB_AMOUNT_CHANGED", "target")
TT_EVT_FRM:RegisterUnitEvent("UNIT_POWER_UPDATE", "target")