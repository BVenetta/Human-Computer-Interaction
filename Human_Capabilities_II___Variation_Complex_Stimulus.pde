color startColor, testColor, errorColor, rectBlack, rectRed, buttonStroke, labelColor;
boolean startTest, colorSwitched = false;
int startingTime, timeElapsed, reactionTime, delay, averageReaction, rand;
float stdDev, errorRate, error, errorCount;
int CONSTANT = 1000;
IntList reactionTimes;
StringList inventory;

void setup() {
  size(690, 420);
  reactionTimes = new IntList();
  errorCount = 0;
  errorRate = 0;
  error = 1;
  startColor = color(100, 100, 100);
  testColor = color(100, 100, 100);
  errorColor = color(144, 12, 63);
  labelColor = color(255,255,255);
  rectBlack = color(0, 0, 0);
  rectRed = color(255, 0, 0);
  background(startColor);
  textAlign(CENTER);
  fill(labelColor);
  textSize(30);
  text("Reaction Test", width/2, height/3);
  textSize(25);
  text("Press <SPACE> to Start", width/2, height/2);
  inventory = new StringList();
  inventory.append("9+12=21");
  inventory.append("Dogs meow");
  inventory.append("20+1=21");
  inventory.append("5+0=50");
  inventory.append("Dogs can bark");
  inventory.append("0-2=2");
  inventory.append("VU is in Amsterdam");
  inventory.append("10*8=108");
  inventory.append("11*2=22");
  inventory.append("21-1=22");
  inventory.append("21+1=22");
  inventory.append("This sentence is in Dutch");
  inventory.append("A circle is round");
  inventory.append("A circle is 180 degrees");
}

void draw() {
  if (startTest) {
    doTest();
  }
}

void doTest() {
  timeElapsed = millis() - startingTime;
  if (timeElapsed < delay) {
    stroke(0);
    fill(rectBlack);
    rectMode(CENTER);
    rect(width/2, height/2.5, width/2, height/3);
    colorSwitched = false;
  }
  else {
    background(testColor);
    fill(labelColor);
    textSize(25);
    text(inventory.get(rand), width/2, height/2);
    colorSwitched = true;
  }
}

void keyPressed() {
  if (key == 'a' || key == 'A') {
    if ((reactionTimes.size() < 1) && (errorCount <1)) {
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
      calcErrorRate();
      fill(labelColor);
      textSize(30);
      text("Results", width/2, height/8);
      textSize(22);
      text("Average Reaction Time: " + averageReaction + "ms", width/2, height/4);
      text("Standard Deviation: " + stdDev, width/2, (height/4) + 50);
      text("Error Rate: " + errorRate, width/2, height/4 + 100);
      textSize(20);
      text("Press <SPACE> to start a new test", width/2, height - 20);
      reactionTimes.clear();
      errorCount = 0;
      errorRate = 0;
    }
  }
   
  if (key == ' ') {
    if (!startTest) {
      background(testColor);
      fill(labelColor);
      textSize(15);
      text("Press <t> when the answer it is correct. Press <f> when the answer is incorrect.", width/2, height/1.5);
      startTest = true;
      delay = int(random(2*CONSTANT, 6*CONSTANT + 1));  //+1 because the upper limit on random is exclusive
      rand = int(random(14));  //generating a random integer from 0 to 14 inclusive
      startingTime = millis();  //time of day when test was started
    }
    else {
      startTest = false;
      background(errorColor);
      fill(labelColor);
      textSize(20);
      text("Press <t> or <f>, not <space> you dummy! Press <Space> to keep playing", width/2, height/2);
    }
  }
  
  if (key == 't' && startTest) {
    startTest = false;
    if (colorSwitched) {
      if (rand % 2 == 0) {
        //user correctly pressed TRUE for a question that is TRUE at the right time.
        reactionTime = timeElapsed - delay;
        fill(labelColor);
        textSize(20);
        text("Correct! Press <SPACE> to keep playing. Reaction Time (ms): " + reactionTime, width/2, height/8);
        reactionTimes.append(reactionTime);
      }
      else {
        //user answered question wrong (they said true when it actually was false)
        fill(labelColor);
        textSize(20);
        text("Wrong answer! Error. Press <SPACE> to keep playing.", width/2, height/8);
        errorCount += error;
      }
    }
    else {
      fill(labelColor);
      textSize(20);
      text("Too quick! Error. Press <SPACE> to keep playing.", width/2, height/8);
      errorCount += error;
    }
  }
  
  if (key == 'f' && startTest) {
    startTest = false;
    if (colorSwitched) {
      if (rand % 2 == 0) {
        //user answered question wrong (they said false when it actually was true)
        fill(labelColor);
        textSize(20);
        text("Wrong answer! Error. Press <Space> to continue.", width/2, height/8);
        errorCount += error;
      }
      else {
        //user correctly pressed FALSE for a question that is FALSE at the right time.
        reactionTime = timeElapsed - delay;
        fill(labelColor);
        textSize(20);
        text("Correct! Press <Space> to continue. Reaction Time (ms): " + reactionTime, width/2, height/8);
        reactionTimes.append(reactionTime);
      }
    }
    else {
      fill(labelColor);
      textSize(20);
      text("Too quick! Error. Press <SPACE> to keep playing.", width/2, height/8);
      errorCount += error;
    }
  }
}

void calcAverageReaction() {
  int sum = 0;
  for (int i = 0; i <= reactionTimes.size() - 1; i++) {
    sum += reactionTimes.get(i);
  }
  averageReaction = sum / reactionTimes.size();
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
