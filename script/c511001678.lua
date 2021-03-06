--Pooch Party
function c511001678.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511001678.target)
	e1:SetOperation(c511001678.activate)
	c:RegisterEffect(e1)
end
function c511001678.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133) 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,511001679,0,0x4011,0,0,1,RACE_BEAST,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,0)
end
function c511001678.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133) 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,511001679,0,0x4011,0,0,1,RACE_BEAST,ATTRIBUTE_EARTH) then
		local fid=e:GetHandler():GetFieldID()
		local g=Group.CreateGroup()
		for i=1,2 do
			local token=Duel.CreateToken(tp,511001679)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			token:RegisterFlagEffect(51101678,RESET_EVENT+0x1fe0000,0,1,fid)
			g:AddCard(token)
		end
		Duel.SpecialSummonComplete()
		g:KeepAlive()
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCountLimit(1)
		e3:SetLabel(fid)
		e3:SetLabelObject(g)
		e3:SetCondition(c511001678.descon)
		e3:SetOperation(c511001678.desop)
		Duel.RegisterEffect(e3,tp)
	end
end
function c511001678.desfilter(c,fid)
	return c:GetFlagEffectLabel(51101678)==fid
end
function c511001678.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c511001678.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c511001678.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c511001678.desfilter,nil,e:GetLabel())
	Duel.Destroy(tg,REASON_EFFECT)
end
