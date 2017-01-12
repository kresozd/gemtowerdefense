// Temporary dynamic event setting, until we get full list of towers
function initTooltips() {
  var results = $("#formula").FindChildrenWithClassTraverse("formula-result");
  var resultContainer;
  for (var i = 0; i < results.length; i++) {
    
    resultContainer = results[i].GetParent();

    resultContainer.SetPanelEvent(
      "onmouseover",
      function(resultContainer) {
        return function() {
          // we need to apply tooltip target properly according to table state minimized/expanded
          var isMinimized = $.GetContextPanel().BHasClass('tab-formula-min');
          var resultInner = resultContainer.FindChildrenWithClassTraverse('formula-tower-inner')[0];
          var target = isMinimized ? resultContainer : resultInner;
          
          $.DispatchEvent("UIShowCustomLayoutParametersTooltip", target, "formulaTooltip", "file://{resources}/layout/custom_game/tooltips/formula_tooltip.xml", "nameid=" + resultContainer.id);
        }
      }(resultContainer));
      
    resultContainer.SetPanelEvent(
      "onmouseout",
      function() {
        $.DispatchEvent("UIHideCustomLayoutTooltip", "formulaTooltip");
      }
    ); 
  }
}



(function() {
  initTooltips();
})();