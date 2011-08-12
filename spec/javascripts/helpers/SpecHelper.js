beforeEach(function() {
  this.addMatchers({
    toBePlaying: function(expectedSong) {
      var player = this.actual;
      return player.currentlyPlayingSong === expectedSong
          && player.isPlaying;
    }
  })
});

(function() {
var __slice = Array.prototype.slice;
log = function() {
  var msg;
  msg = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
  if (typeof jasmine !== "undefined" && jasmine !== null) {
    return jasmine.log(msg);
  } else {
    return console.log(msg);
  }
};
})()
