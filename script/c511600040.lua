--リンク・ディヴォーティー
--Link Devotee
--scripted by Larry126
function c511600040.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c511600040.matfilter,1,1)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c511600040.link)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511600040,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,511600040)
	e2:SetCondition(c511600040.spcon)
	e2:SetTarget(c511600040.sptg)
	e2:SetOperation(c511600040.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD_P)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetLabelObject(e2)
	e3:SetOperation(c511600040.chk)
	c:RegisterEffect(e3)
end
function c511600040.chk(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(e:GetHandler():GetMutualLinkedGroupCount())
end
function c511600040.matfilter(c,lc,sumtype,tp)
	return c:IsLevelBelow(4) and c:IsRace(RACE_CYBERSE,lc,sumtype,tp)
end
function c511600040.link(e,tp,eg,ep,ev,re,r,rp,c)
	--cannot link summon
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c511600040.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c511600040.splimit(e,c,tp,sumtp,sumpos)
	return c:GetLink()>=3 and bit.band(sumtp,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c511600040.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()>0
end
function c511600040.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,511600041,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c511600040.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,511600041,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_LIGHT) then return end
	for i=1,2 do
		local token=Duel.CreateToken(tp,511600041)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end