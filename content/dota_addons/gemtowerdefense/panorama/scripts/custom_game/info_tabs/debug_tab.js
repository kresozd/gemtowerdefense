
function AddDebugButton(text, eventName) {
  var panel = $("#debug-panel");
  var button = $.CreatePanel("Button", panel, "");
  button.SetPanelEvent("onactivate", function(){
      GameEvents.SendCustomGameEventToServer(eventName, {});
  });

  $.CreatePanel("Label", button, "").text = text;

  return button;
}

function initDebugPanel() {
  AddDebugButton("Hit Throne", "debug_hit_throne");
  AddDebugButton("Heal Throne", "debug_heal_throne");
  AddDebugButton("Clear Wave", "debug_clear_wave");
  AddDebugButton("Level Up", "debug_level_up");
  AddDebugButton("Reset Level", "debug_reset_level");
}


(function() {
  initDebugPanel();
})();