function AddSandboxButton(text, eventName) {
  var panel = $("#sandbox-panel");
  var button = $.CreatePanel("Button", panel, "");

  button.SetPanelEvent("onactivate", function() {
      GameEvents.SendCustomGameEventToServer(eventName, {});
  });

  button.AddClass('sandbox-button');
  $.CreatePanel("Label", button, "").text = text;

  return button;
}


function initSandboxPanel() {
  AddSandboxButton("Hit Throne", "sandbox_hit_throne");
  AddSandboxButton("Heal Throne", "sandbox_heal_throne");
  AddSandboxButton("Clear Wave", "sandbox_clear_wave");
  AddSandboxButton("Level Up", "sandbox_level_up");
  AddSandboxButton("Reset Level", "sandbox_reset_level");
}


function toggleSandboxTab() {
  $('#sandbox-tab').ToggleClass('sandbox-tab-hidden');
}


(function() {
  initSandboxPanel();
})();