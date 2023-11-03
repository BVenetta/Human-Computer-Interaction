float random_x, random_y; 

void setup() {
  size(745, 745);
  background(200, 50, 150);
  textAlign(CENTER);
}

void draw() {
  background(200, 50, 150); 
  textSize(20);
  text("Press 'd' to reverse the mouse direction.", width / 2 , 30);
  text("Press 't' to swap the x and y coordinates.", width / 2, 60);
  text("Press 'r' to place the mouse in random position.", width / 2, 90);
  text("Press any other button to return to the original settings.", width / 2, 120);  
  noCursor();
  ellipse(mouseX, mouseY, 50, 50);
  if (key == 'd' || key == 't' || key == 'r' || key == 'n')  {
    keyPressed();
  }
}

void keyPressed()  {
  if (key == 'd') { //transfer function: reverse mouse direction
    background(200, 50,150);
    textSize(20);
    text("Press 'd' to reverse the mouse direction.", width / 2 , 30);
    text("Press 't' to swap the x and y coordinates.", width / 2, 60);
    text("Press 'r' to place the mouse in random position.", width / 2, 90);
    text("Press any other button to return to the original settings.", width / 2, 120);    
    float inverse_mouse_x = width - mouseX; // Inverse X
    float inverse_mouse_y = height - mouseY; // Inverse Y
    fill(250, 250);
    ellipse(inverse_mouse_x, inverse_mouse_y, 50, 50);
  }
  else if (key == 't') { //transfer function: x_coord becomes y_coord and vice versa
    background(200, 50,150);
    textSize(20);
    text("Press 'd' to reverse the mouse direction.", width / 2 , 30);
    text("Press 't' to swap the x and y coordinates.", width / 2, 60);
    text("Press 'r' to place the mouse in random position.", width / 2, 90);
    text("Press any other button to return to the original settings.", width / 2, 120);  
   fill(250, 250);
   ellipse(mouseY, mouseX, 50, 50);
  }
  else if (key == 'r') { //transfer function: place ellipse in random position around the mouse
    background(200, 50,150);
    textSize(20);
    text("Press 'd' to reverse the mouse direction.", width / 2 , 30);
    text("Press 't' to swap the x and y coordinates.", width / 2, 60);
    text("Press 'r' to place the mouse in random position.", width / 2, 90);
    text("Press any other button to return to the original settings.", width / 2, 120);  
    random_x = random(-100, 100);
    random_y = random(-100, 100);
    float mouse_x_and_rand = mouseX + random_x;
    float mouse_y_and_rand = mouseY + random_y;
    fill (250, 250); 
    ellipse(mouse_x_and_rand, mouse_y_and_rand, 50, 50); 
  }
}
