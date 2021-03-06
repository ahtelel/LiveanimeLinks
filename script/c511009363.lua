--Spirit Reactor
--fixed by MLD
function c511009363.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c511009363.val)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c511009363.indcon)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(c511009363.indct)
	c:RegisterEffect(e2)
	-- copy scale
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(94585852,0))
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e8:SetCode(511002005)
	e8:SetRange(LOCATION_PZONE)
	e8:SetTarget(c511009363.sctg)
	e8:SetOperation(c511009363.scop)
	c:RegisterEffect(e8)
	if not c511009363.global_check then
		c511009363.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetOperation(c511009363.checkop)
		Duel.RegisterEffect(ge2,0)
	end
end
function c511009363.val(e,c)
	return Duel.GetMatchingGroupCount(c511009363.filter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)*500
end
function c511009363.filter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH+ATTRIBUTE_WATER+ATTRIBUTE_FIRE+ATTRIBUTE_WIND) and c:IsFaceup()
end
function c511009363.indcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c511009363.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c511009363.indct(e,re,r,rp)
	if r&REASON_BATTLE+REASON_EFFECT~=0 then
		return 1
	else return 0 end
end
function c511009363.cfilter(c)
	local seq=c:GetSequence()
	return c:GetFlagEffect(511002005+seq)==0 and (not c:IsPreviousLocation(LOCATION_PZONE) or c:GetPreviousSequence()~=seq)
end
function c511009363.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tot=Duel.GetMasterRule()>=4 and 4 or 13
	local g=Duel.GetMatchingGroup(c511009363.cfilter,tp,LOCATION_PZONE,LOCATION_PZONE,nil)
	local tc=g:GetFirst()
	while tc do
		tc:ResetFlagEffect(511002005+tot-tc:GetSequence())
		Duel.RaiseSingleEvent(tc,511002005,e,0,tp,tp,0)
		tc:RegisterFlagEffect(511002005+tc:GetSequence(),RESET_EVENT+0x1fe0000,0,1)
		tc=g:GetNext()
	end
end
function c511009363.scfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c511009363.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc~=e:GetHandler() and chkc:IsOnField() and c511009363.scfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511009363.scfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c511009363.scfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
end
function c511009363.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LSCALE)
		e1:SetValue(tc:GetLeftScale())
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RSCALE)
		e2:SetValue(tc:GetRightScale())
		c:RegisterEffect(e2)
	end
end
