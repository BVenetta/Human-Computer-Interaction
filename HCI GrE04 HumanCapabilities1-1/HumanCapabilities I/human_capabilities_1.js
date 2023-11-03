var startColor, testColor, errorColor, rectBlack, rectRed, buttonStroke, labelColor;
var startTest, colorSwitched = false;
var startingTime, timeElapsed, reactionTime, delay, averageReaction;
var stdDev;
var CONSTANT = 1000;
var reactionTimes;

function setup() {
  createCanvas(690, 420);
  reactionTimes = [];
  startColor = color(255, 195, 0);
  testColor = color(224, 224, 224);
  errorColor = color( 144, 12, 63);
  labelColor = color(88, 24, 69);
  rectBlack = color(0, 0, 0);
  rectRed = color(199, 0, 57);
  background(startColor);
  textAlign(CENTER);
  fill(labelColor);
  textSize(30);
  text("Reaction Test", width/2, height/3);
  textSize(25);
  text("Press <SPACE> to Start", width/2, height/2);
}

function draw() {
  if (startTest) {
    doTest();
  }
}

function doTest() {
  timeElapsed = millis() - startingTime;
  
  if (timeElapsed < delay) {
    stroke(0);
    fill(rectBlack);
    rectMode(CENTER);
    rect(width/2, height/2.5, width/2, height/3);
    colorSwitched = false;
  }
  else {
    stroke(0);
    fill(rectRed);
    rectMode(CENTER);
    rect(width/2, height/2.5, width/2, height/3);
    colorSwitched = true;
  }
}

function keyPressed() {
  if (key == 'a' || key == 'A') {
    if (reactionTimes.size < 1) {
      startTest = false;
      background(errorColor);
      fill(255);
      textSize(22);
      text("Press <SPACE> to start the test", width/2, height/2);
      text("No results to show yet.", width/2, height/2 + 20);
    }
    else {
      startTest = false;
      background(startColor);
      calcAverageReaction();
      calcStdDev();
      
      fill(labelColor);
      textSize(30);
      text("Results", width/2, height/8);
      textSize(22);
      text("Average Reaction Time: " + averageReaction + "ms", width/2, height/4);
      text("Standard Deviation: " + stdDev, width/2, (height/4) + 50);
      textSize(20);
      text("Press <SPACE> to start a new test", width/2, height - 20);
      reactionTimes = [];
    }
  }
   
  if (key == ' ') {
    if (!startTest) {
      background(testColor);
      fill(labelColor);
      textSize(15);
      text("Press <SPACE> when the box turns red", width/2, height/1.5);
      startTest = true;
      delay = int(random(2*CONSTANT, 6*CONSTANT + 1));  //+1 because the upper limit on random is exclusive
      startingTime = millis();  //time of day when test was started
    }
    else {
      startTest = false;
      if (colorSwitched) {
        reactionTime = timeElapsed - delay;
        fill(labelColor);
        textSize(20);
        text("Reaction Time (ms): " + reactionTime, width/2, height/8);
        reactionTimes.push(reactionTime);
      }
      else {
        background(errorColor);
        fill(255);
        textSize(36);
        text("Too early! Press <SPACE> to restart", width/2, height/2.5);
      }
    }
  }
}

function calcAverageReaction() {
  var sum = 0;
  for (var i = 0; i <= reactionTimes.length - 1; i += 1) {
    sum += reactionTimes[i];
  }
  averageReaction = sum / reactionTimes.length;
}

function calcStdDev() {
  var sum = 0;
  for (var i = 0; i <= reactionTimes.length - 1; i += 1) {
    var time = reactionTimes[i];
    var xMinusMuSq = int(sq(abs(averageReaction - time)));
    sum += xMinusMuSq;
  }
  stdDev = sqrt(sum / reactionTimes.length);
}