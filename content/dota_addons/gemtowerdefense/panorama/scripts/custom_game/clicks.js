var cameraDistance = 1600;
var maxCameraDistance = 2600;
var minCameraDistance = 1100;
var cameraInterval = 35;
GameUI.SetCameraDistance(cameraDistance);


function zoomEvent(zoomDistance) {
  if (zoomDistance > maxCameraDistance) zoomDistance = maxCameraDistance;
  if (zoomDistance < minCameraDistance) zoomDistance = minCameraDistance;
  // $.Msg(cameraDistance);
  cameraDistance = zoomDistance;
  GameUI.SetCameraDistance(cameraDistance);
}


GameUI.SetMouseCallback(function (eventName, arg) {
  var CONSUME_EVENT = true;
  var CONTINUE_PROCESSING_EVENT = false;
  var LEFT_CLICK = (arg === 0);
  var RIGHT_CLICK = (arg === 1);

  if (GameUI.GetClickBehaviors() !== CLICK_BEHAVIORS.DOTA_CLICK_BEHAVIOR_NONE)
    return CONTINUE_PROCESSING_EVENT;

  if (eventName === "wheeled") {
    var value = arg == 1 ? -cameraInterval : cameraInterval;
    zoomEvent(cameraDistance + value);
    return CONSUME_EVENT;
  }
  return CONTINUE_PROCESSING_EVENT;
});