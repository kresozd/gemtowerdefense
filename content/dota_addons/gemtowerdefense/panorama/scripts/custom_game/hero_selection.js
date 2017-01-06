var selectedHeroes = {};

var selectedHero = '';

function selectHero(heroName) {
  var hero = $('#' + heroName);
  var heroTitle = $('#hero-name-title');
  var isAvailable = hero.BHasClass('hero-not-available');

  if (selectedHero) {
    $('#' + selectedHero).RemoveClass('hero-selected');
  }

  hero.AddClass('hero-selected');
  heroTitle.text = $.Localize('#' + heroName).toUpperCase();
  selectedHero = heroName;

  $('#pick-hero-button').disabled = isAvailable;
  $('#pick-hero-button').SetHasClass('pick-hero-disabled', isAvailable)
}

function pickHero() {
  if ($('#pick-hero-button').disabled || !selectedHero) {
    $.Msg('Scooby Doo where are you');
    return;
  }

  GameEvents.SendCustomGameEventToServer("player_selected_hero", {selected_hero : selectedHero});
  endHeroSelection();
}

function endHeroSelection() {
  var Root = $.GetContextPanel();
  Root.style.opacity = 0;
  $.Schedule(1.5, function() {
    Root.DeleteAsync(0);
  });
}


(function(){
  $("#pick-hero-button").disabled = true;
  
  CustomNetTables.SubscribeNetTableListener('game_state', endHeroSelection);
  

  var players = Game.GetAllPlayerIDs();
  var panel = $("#players-states").FindChildrenWithClassTraverse('players-states-item');

  for (var i = 0; i < players.length; i++) {
    var playerInfo = Game.GetPlayerInfo(i);
    var target = panel[i];

    for (var j = 0; j < target.GetChildCount(); j++) {
      target.GetChild(j).steamid = playerInfo.player_steamid;
      target.style.visibility = 'visible';
    }
	}


  selectHero("npc_dota_hero_crystal_maiden");
})();