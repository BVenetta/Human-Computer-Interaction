"Present a binary stimulus: change the field from black to red or blue. The color (red or blue) is randomly chosen with equal probability. The user should be instructed to only press the SPACE key when the color changes to red. Pressing the key when the color is changed to blue is counted as an error. The results reported should include the average time, the standard deviation (SD), and the error rate."

var startColor, testColor, errorColor, rectBlack, rectRed, rectBlue, rectColor, buttonStroke, labelColor; //all colors
var startTest, colorSwitched = false;
var startingTime, timeElapsed, reactionTime, delay, averageReaction, errorCount, blueCount;
var stdDev;
const MILLIS = 1000;
const BLUEWAIT = 5000;
var reactionTimes;

function setup() {
  createCanvas(690, 420);
  reactionTimes = [];
  startColor = color(255, 195, 0);
  testColor = color(224, 224, 224);
  errorColor = color(144, 12, 63);
  labelColor = color(88, 24, 69);
  rectBlack = color(0, 0, 0);
  rectRed = color(199, 0, 57);
  rectBlue = color(16, 56, 205);
  errorCount = 0;
  blueCount = 0;
  background(startColor);
  textAlign(CENTER);
  fill(labelColor);
  textSize(30);
  text("Reaction Test", width / 2, height / 3);
  textSize(25);
  text("Press <SPACE> to Start", width / 2, height / 2);
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
    rect(width / 2, height / 2.5, width / 2, height / 3);
    colorSwitched = false;
  } else {
    if (rectColor == rectRed) {
      stroke(0);
      fill(rectColor);
      rectMode(CENTER);
      rect(width / 2, height / 2.5, width / 2, height / 3); 
      colorSwitched = true;
    }
    else {
      stroke(0);
      fill(rectColor);
      rectMode(CENTER);
      rect(width / 2, height / 2.5, width / 2, height / 3);
      colorSwitched = true;
      if (timeElapsed >= delay + BLUEWAIT) {
        blueCount++;
        rectColor = rectRed;
      }
    }
  }
}

function keyPressed() {
  if (key == 'a' || key == 'A') {
    if (reactionTimes.size < 1) {
      startTest = false;
      background(errorColor);
      fill(255);
      textSize(22);
      text("Press <SPACE> to start the test", width / 2, height / 2);
      text("No results to show yet.", width / 2, height / 2 + 20);
    } else {
      startTest = false;
      background(startColor);
      calcAverageReaction();
      calcStdDev();

      fill(labelColor);
      textSize(30);
      text("Results", width / 2, height / 8);
      textSize(22);
      text("Average Reaction Time: " + averageReaction + "ms", width / 2, height / 4);
      text("Standard Deviation: " + stdDev, width / 2, (height / 4) + 50);
      text("Error Rate: " + calcErrorRate() + "%", width / 2, (height / 4) + 100);
      textSize(20);
      text("Press <SPACE> to start a new test", width / 2, height - 20);
      reactionTimes = [];
      errorCount = 0;
    }
  }

  if (key == ' ') {
    if (!startTest) {
      background(testColor);
      fill(labelColor);
      textSize(15);
      text("Press <SPACE> when the box turns red", width / 2, height / 1.5);
      text("Do NOT press anything when the box turns blue", width / 2, height / 1.4);

      startTest = true;
      delay = int(random(2 * MILLIS, 6 * MILLIS + 1)); //+1 because the upper limit on random is exclusive
      selectColor();
      startingTime = millis(); //time of day when test was started
    } else {
      startTest = false;
      if (colorSwitched) {
        if (rectColor == rectRed) {
          reactionTime = timeElapsed - delay - (BLUEWAIT * blueCount);
          fill(labelColor);
          textSize(20);
          text("Reaction Time (ms): " + reactionTime, width / 2, height / 8);
          reactionTimes.push(reactionTime);
          blueCount = 0;
        } else {
          errorCount += 1;
          fill(labelColor);
          textSize(20);
          text("Error! Only press <SPACE> when the rectangle is RED", width / 2, height / 8);
        }
      } else {
        background(errorColor);
        fill(255);
        textSize(36);
        text("Too early! Press <SPACE> to restart", width / 2, height / 2.5);
      }
    }
  }
}

function calcErrorRate() {
  return ((errorCount / (reactionTimes.length + errorCount)) * 100).toFixed(2);
}

function selectColor() {
  var rand = Math.random();
  if (rand < 0.5) {
    rectColor = rectRed;
  } else if (rand >= 0.5) { //to make the odds even, it has to be >= because Math.random is from 0 (inlcusive) to 1 (exclusive)
    rectColor = rectBlue;
  }
}

function calcAverageReaction() {
  var sum = 0;
  for (var i = 0; i <= reactionTimes.length - 1; i += 1) {
    sum += reactionTimes[i];
  }
  averageReaction = Math.round((sum / reactionTimes.length));
}

function calcStdDev() {
  var sum = 0;
  for (var i = 0; i <= reactionTimes.length - 1; i += 1) {
    var time = reactionTimes[i];
    var xMinusMuSq = int(sq(abs(averageReaction - time)));
    sum += xMinusMuSq;
  }
  stdDev = (sqrt(sum / reactionTimes.length)).toFixed(2);
}