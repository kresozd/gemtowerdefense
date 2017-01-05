var selectedHeroes = {};

var selectedHero = '';

function selectHero(heroName) {
  var hero = $('#hero_' + heroName);
  var notAvailable = hero.BHasClass('hero-not-available');
  if (selectedHero) {
    $('#hero_' + selectedHero).RemoveClass('hero-selected');
  }
  hero.AddClass('hero-selected');
  selectedHero = heroName;
  $('#pick-hero-button').disabled = notAvailable;
  $('#pick-hero-button').SetHasClass('pick-hero-disabled', notAvailable)
}

function pickHero() {
  if ($('#pick-hero-button').disabled || !selectedHero) {
    $.Msg('Scooby Doo where are you');
    return;
  }

  GameEvents.SendCustomGameEventToServer("player_selected_hero", {selected_hero : 'npc_dota_hero_' + selectedHero});
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
})();