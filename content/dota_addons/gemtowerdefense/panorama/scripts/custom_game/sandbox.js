// function AddSandboxButton(text, eventName) {
//   var panel = $("#sandbox-panel");
//   var button = $.CreatePanel("Button", panel, "");

//   button.SetPanelEvent("onactivate", function() {
//       GameEvents.SendCustomGameEventToServer(eventName, {});
//   });

//   button.AddClass('sandbox-button');
//   $.CreatePanel("Label", button, "").text = text;
// }


function changeRound() {
  updateNumValue(0);
  GameEvents.SendCustomGameEventToServer("sandbox_change_round", {round: $('#round-value').text})
}


function triggerEvent(eventName) {
  GameEvents.SendCustomGameEventToServer(eventName, {})
}


function toggleSandboxTab() {
  $('#sandbox-tab').ToggleClass('sandbox-tab-hidden');
}


(function() {

})();