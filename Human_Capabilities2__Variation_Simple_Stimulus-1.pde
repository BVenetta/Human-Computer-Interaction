color startColor, testColor, errorColor, rectBlack, rectRed, rectBlue, buttonStroke, labelColor, randomColor;
boolean startTest, colorSwitched = false;
int startingTime, timeElapsed, reactionTime, delay, averageReaction;
float stdDev, errorRate, errorCount, error;
int CONSTANT = 1000;
IntList reactionTimes;

void setup() {
  size(690, 420);
  reactionTimes = new IntList();
  errorCount = 0;
  errorRate = 0;
  error = 1;
  startColor = color(255, 195, 0);
  testColor = color(224, 224, 224);
  errorColor = color( 144, 12, 63);
  labelColor = color(88, 24, 69);
  rectBlack = color(0, 0, 0);
  rectRed = color(199, 0, 57);
  rectBlue = color(0, 0, 251);
  randomColor = color(0, 0, 0);

  background(startColor);
  textAlign(CENTER);
  fill(labelColor);
  textSize(30);
  text("Reaction Test", width/2, height/3);
  textSize(25);
  text("Press 'r' or 'b' to Start", width/2, height/2);
}

void draw() {
  if (startTest) {
    doTest();
  }
}

void generateRandomColor() {
  color [] red_and_blue = { rectRed, rectBlue };
  int index = int(random(red_and_blue.length));
  randomColor = red_and_blue[index];
}

void doTest() {
  timeElapsed = millis() - startingTime;
  //print("Delay: " + delay + "\n" + "Millis: " + millis() + "\n" + "StartTime: " + startingTime + "\n" + "Time elapsed: " + timeElapsed + "\n\n");
  if (timeElapsed < delay) {
    stroke(0);
    fill(rectBlack);
    rectMode(CENTER);
    rect(width/2, height/2.5, width/2, height/3);
    colorSwitched = false;
  }
  else {
    stroke(0);
    fill(randomColor);
    rectMode(CENTER);
    rect(width/2, height/2.5, width/2, height/3);
    colorSwitched = true;
    }
  }

void keyPressed() {
  if (key == 'a' || key == 'A') {
    if ((reactionTimes.size() < 1) && (errorCount < 1)) {
      startTest = false;
      background(errorColor);
      fill(255);
      textSize(22);
      text("Press 'r' or 'b' to start the test", width/2, height/2);
      text("No results to show yet.", width/2, height/2 + 20);
    }
    else {
      startTest = false;
      background(startColor);
      calcAverageReaction();
      calcStdDev();
      calcErrorRate();
      fill(labelColor);
      textSize(30);
      text("Results", width/2, height/8);
      textSize(22);
      text("Average Reaction Time: " + averageReaction + "ms", width/2, height/4);
      text("Standard Deviation: " + stdDev, width/2, (height/4) + 50);
      text("Error count: " + errorCount, width/2, height/4 + 100);
      text("Error Rate: " + errorRate, width/2, height/4 + 150);
      textSize(20);
      text("Press 'r' or 'b' to start a new test", width/2, height - 20);
      reactionTimes.clear();
      errorCount = 0;
      errorRate = 0;
    }
  }
   
  if (key == 'r' || key == 'b') {
    if (!startTest) {
      background(testColor);
      fill(labelColor);
      textSize(15);
      text("Press 'r' when the box turns red and 'b' when the box turns blue", width/2, height/1.5);
      startTest = true;
      delay = int(random(2*CONSTANT, 6*CONSTANT + 1));  //+1 because the upper limit on random is exclusive
      startingTime = millis();  //time of day when test was started
      generateRandomColor();

    }
      
    else {
      startTest = false;
      if (colorSwitched) {
        if ((key == 'r' && randomColor == rectRed) || (key == 'b' && randomColor == rectBlue)) {
          //reactionTime is only calculated when a key is pressed correctly
          reactionTime = timeElapsed - delay;
          fill(labelColor);
          textSize(20);        
          text("Reaction Time (ms): " + reactionTime, width/2, height/8);
          reactionTimes.append(reactionTime);
          reactionTimes.size();        
        }
        if ((key == 'r' && randomColor == rectBlue) || (key == 'b' && randomColor == rectRed)) {
          fill(labelColor);
          textSize(20);        
          text("Wrong button! +1 Error", width/2, height/8);
          errorCount += error;
        }
      }
      else {
        background(errorColor);
        fill(255);
        textSize(36);
        text("Too early! Press 'r' or 'b' to restart", width/2, height/2.5);
        text("+1 Error", width/2, height/1.75);
        errorCount += error;
      }
    }
  }
}

void calcAverageReaction() {
  int sum = 0;
  for (int i = 0; i <= reactionTimes.size() - 1; i++) {
    sum += reactionTimes.get(i);
  }
  if (reactionTimes.size() != 0) {
    averageReaction = sum / reactionTimes.size();
  }
  else averageReaction = 0;
}

void calcStdDev() {
  int sum = 0;
  for (int i = 0; i <= reactionTimes.size() - 1; i++) {
    int time = reactionTimes.get(i);
    int xMinusMuSq = int(sq(abs(averageReaction - time)));
    sum += xMinusMuSq;
  }
  if (reactionTimes.size() != 0) {
    stdDev = sqrt(sum / reactionTimes.size());
  }
  else stdDev = 0;
}

void calcErrorRate() {
  errorRate = errorCount/ (reactionTimes.size() + errorCount);
}
