"use strict";


(function (SilenceState) {
	SilenceState[SilenceState["None"] = 0] = "None";
	SilenceState[SilenceState["Abilities"] = 1] = "Abilities";
	SilenceState[SilenceState["Passives"] = 2] = "Passives";
	SilenceState[SilenceState["All"] = 3] = "All";
})(SilenceState || (SilenceState = {}));
var m_AbilityPanels = []; // created up to a high-water mark, but reused when selection changes
var SilenceState;
var silenceState = SilenceState.None;
var previousUnit = Players.GetLocalPlayerPortraitUnit();
function OnLevelUpClicked()
{
	if ( Game.IsInAbilityLearnMode() )
	{
		Game.EndAbilityLearnMode();
	}
	else
	{
		Game.EnterAbilityLearnMode();
	}
	UpdateAbilityList();
}

function upAttributes()
{
	if (!Game.IsInAbilityLearnMode())
		return;

	var queryUnit = Players.GetLocalPlayerPortraitUnit();
	Abilities.AttemptToUpgrade(Entities.GetAbilityByName(queryUnit, "attribute_bonus"));
}

function OnAbilityLearnModeToggled( bEnabled )
{
	UpdateAbilityList();
}

function UpdateAbilityList()
{
	var abilityListPanel = $( "#ability_list1" );
	if ( !abilityListPanel )
		return;

	var queryUnit = Players.GetLocalPlayerPortraitUnit();
	if (queryUnit != previousUnit)
	{
		Game.EndAbilityLearnMode();
	}
    $("#Portrait").heroname = Entities.GetUnitName ( queryUnit );
	previousUnit = queryUnit;
	// see if we can level up
	var nRemainingPoints = Entities.GetAbilityPoints( queryUnit );
	var bPointsToSpend = ( nRemainingPoints > 0 );
	var bControlsUnit = Entities.IsControllableByPlayer( queryUnit, Game.GetLocalPlayerID() );
	$.GetContextPanel().SetHasClass( "could_level_up", ( bControlsUnit && bPointsToSpend ) );

	// update all the panels
	var nUsedPanels = 0;
	var uAbilityCount = 0;

	for ( var i = 0; i < Entities.GetAbilityCount( queryUnit ); ++i )
	{
		var ability = Entities.GetAbility( queryUnit, i );
		if ( ability == -1 )
			continue;
		if ( !Abilities.IsDisplayedAbility(ability) )
			continue;
		uAbilityCount++;
	}
	var uAbilityCountHalf = uAbilityCount/2;
	uAbilityCount = 0;

	for ( var i = 0; i < Entities.GetAbilityCount( queryUnit ); ++i )
	{
		var ability = Entities.GetAbility( queryUnit, i );
		if ( ability == -1 )
			continue;

		if ( !Abilities.IsDisplayedAbility(ability) )
			continue;

		uAbilityCount++;

		if ( nUsedPanels >= m_AbilityPanels.length )
		{
			// create a new panel
			var panel2 = $( "#ability_list2" );
			if (uAbilityCount<=4){
				var abilityPanel = $.CreatePanel( "Panel", abilityListPanel, "" );
				abilityPanel.BLoadLayout( "file://{resources}/layout/custom_game/action_bar_ability.xml", false, false );
				m_AbilityPanels.push( abilityPanel );
			}
			else{
				var abilityPanel = $.CreatePanel( "Panel", panel2, "" );
				abilityPanel.BLoadLayout( "file://{resources}/layout/custom_game/action_bar_ability.xml", false, false );
				m_AbilityPanels.push( abilityPanel );
			}
		}

		// update the panel for the current unit / ability
		var abilityPanel = m_AbilityPanels[ nUsedPanels ];
		abilityPanel.SetAbility( ability, queryUnit, Game.IsInAbilityLearnMode() );

		nUsedPanels++;
	}

	// clear any remaining panels
	for ( var i = nUsedPanels; i < m_AbilityPanels.length; ++i )
	{
		var abilityPanel = m_AbilityPanels[ i ];
		abilityPanel.SetAbility( -1, -1, false );
	}

	var nRemainingPoints = Entities.GetAbilityPoints( queryUnit );
	if (nRemainingPoints == 0)
		Game.EndAbilityLearnMode();

	onUpdate();
}

function getSilenceState(unit) {
	var state = SilenceState.None;
	if (Entities.IsSilenced(unit) || Entities.IsHexed(unit))
		state += SilenceState.Abilities;
	if (Entities.PassivesDisabled(unit))
		state += SilenceState.Passives;
	return state;
}

function onUpdate() {

    var currentUnit = Players.GetLocalPlayerPortraitUnit();
    $("#LevelNumber").text = Entities.GetLevel(currentUnit);
    $("#XPLabel").text = Entities.GetCurrentXP(currentUnit)+"/"+Entities.GetNeededXPToLevel(currentUnit);
	$("#HealthBarInner").style.width = (Entities.GetHealth(currentUnit) / Entities.GetMaxHealth(currentUnit)) * 100 + "%";
	$("#CurrentHealth").text = ""+(Entities.GetHealth(currentUnit))+"/"+Entities.GetMaxHealth(currentUnit)+" +"+Entities.GetHealthThinkRegen(currentUnit);

	var mana_pct = (Entities.GetMana(currentUnit) / Entities.GetMaxMana(currentUnit)) * 100;
	if (Entities.GetMaxMana(currentUnit) != 0) {
		$("#ManaBarInner").style.width = new String(mana_pct) + "%";
		$("#CurrentMana").text = ""+(Entities.GetMana(currentUnit))+"/"+Entities.GetMaxMana(currentUnit)+" +"+Entities.GetManaThinkRegen(currentUnit);
	}
	else {
		$("#ManaBarInner").style.width = 0 + "%";
		$("#CurrentMana").text = "-";
	}

	// Make ability state only visible to allies (this can be commented out to see enemy ability states!)
	var nUsedPanels = 0;
	if (!Entities.IsEnemy(currentUnit)) {
		// Check silence state
		var silenceS = getSilenceState(currentUnit);
		if (silenceS !== silenceState) {
			silenceState = silenceS;

			for ( var i = 0; i < Entities.GetAbilityCount( currentUnit ); ++i )
			{
				var ability = Entities.GetAbility( currentUnit, i );
				if ( ability == -1 )
					continue;

				if ( !Abilities.IsDisplayedAbility(ability) )
					continue;

				// update the panel for the current unit / ability
				m_AbilityPanels[ nUsedPanels ].setSilenceState(silenceState);
				nUsedPanels++;
			}
		}
	}


	var currentUnit = Players.GetLocalPlayerPortraitUnit();
	var newUnit = CustomNetTables.GetTableValue( "hero_attributes", currentUnit );
	if (Entities.IsHero( currentUnit )){
		if ( newUnit ){
			$("#attributeStrText").text = "Str:" + newUnit.str;
			$("#attributeAgiText").text = "Agi:" + newUnit.agi;
			$("#attributeIntText").text = "Int:" + newUnit.int;
			$("#attributeMoveSpeedText").text = "MS:" + newUnit.movespeed.toFixed(2);
		}
	}
	else {
		if ( currentUnit ){
			$("#attributeStrText").text = "";
			$("#attributeAgiText").text = "";
			$("#attributeIntText").text = "";
		}
	}
	$("#attributeMagicResistance").text = "MR:" + Entities.GetMagicalArmorValue(currentUnit).toFixed(2);
	$("#attributeArmorText").text = "Amr:" + Entities.GetPhysicalArmorValue(currentUnit).toFixed(2);
	$("#attributeDamageText").text = "Dmg:\n" + Math.floor((Entities.GetDamageMax(currentUnit)+Entities.GetDamageMin(currentUnit))/2) + " + "+Entities.GetDamageBonus(currentUnit);
	if (Entities.GetAttacksPerSecond(currentUnit).toFixed(2) < 3000)
		$("#attributeAttackSpeedText").text = "AS:" + Entities.GetAttacksPerSecond(currentUnit).toFixed(2);
	else
		$("#attributeAttackSpeedText").text = "AS: -";


	$.Schedule(0.03, onUpdate);
}

function OnNettableChanged() {
	onUpdate();
}

(function()
{
	GameEvents.Subscribe( "dota_portrait_ability_layout_changed", UpdateAbilityList );
	GameEvents.Subscribe( "dota_player_update_selected_unit", UpdateAbilityList );
	GameEvents.Subscribe( "dota_player_update_query_unit", UpdateAbilityList );
	GameEvents.Subscribe( "dota_ability_changed", UpdateAbilityList );
	GameEvents.Subscribe( "dota_hero_ability_points_changed", UpdateAbilityList );
	CustomNetTables.SubscribeNetTableListener( "hero_attributes", OnNettableChanged );

	var unit = Players.GetQueryUnit(Players.GetLocalPlayer());
    if (unit === -1) {
        unit = Players.GetLocalPlayerPortraitUnit();
    }
	onUpdate();


})();
