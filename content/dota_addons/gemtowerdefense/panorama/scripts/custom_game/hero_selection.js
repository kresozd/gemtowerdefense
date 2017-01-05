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
  
  $.GetContextPanel().DeleteAsync(0);
}


(function(){
  $("#pick-hero-button").disabled = true;
})();