var MAX_ROUND = 48;
var MIN_ROUND = 0;


function updateNumValue(value) {
  var textEntry = $('#round-value');
  textEntry.text = textEntry.text.replace(/\D/g,'');

  var oldValue = textEntry.text ? parseInt(textEntry.text) : MIN_ROUND;
  var newValue = oldValue + parseInt(value);

  if (newValue <= MIN_ROUND) {
    newValue = MIN_ROUND;
  } else if (newValue > MAX_ROUND) {
    return;
  }
  textEntry.text = newValue;
}