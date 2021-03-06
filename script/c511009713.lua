--Burn Hydradrive
function c511009713.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c511009713.matfilter,1,1)
	c:EnableReviveLimit()
	-- cannot link
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(c511009713.lnklimit)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(c511009713.dacon)
	c:RegisterEffect(e2)
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(511009713,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c511009713.tkcon)
	e3:SetTarget(c511009713.tktg)
	e3:SetOperation(c511009713.tkop)
	c:RegisterEffect(e3)
end
function c511009713.matfilter(c)
	return c:IsLinkSetCard(0x577) 
end
function c511009713.lnklimit(e,c)
	if not c then return false end
	return c:IsLink(1)
end
function c511009713.spfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c511009713.dacon(e)
	return  Duel.IsExistingMatchingCard(c511009713.spfilter,tp,0,LOCATION_MZONE,1,nil)
end



function c511009713.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c511009713.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,511009710,0x577,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c511009713.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,511009710,0x577,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,511009710)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
