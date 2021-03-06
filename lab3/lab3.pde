//Слесарева Д.С. М8О-307Б
//16 вариант
//Прямой цилиндр, основание – сектор параболы.

float rotX = 0.0, rotY = 0.0;
float distX = 0.0, distY = 0.0;
int lastX, lastY;
int scale_value = 100;
boolean fillStatus = true;
boolean projectionStatus = false;
float last = 0;
PVector point, zero, curr;
int direction = 0;
float t = PI;
HScrollbar hs1, hs2;
void setup() {
  size(1500, 1000, P3D);
  zero = new PVector(0, 0, 0);

  hs1 = new HScrollbar(0, 10, width, 16, 16);
  hs2 = new HScrollbar(0, 30, width, 16, 16);
}

void draw() {
  background(246, 196, 246);
  if (hs1.getPos() != last) {
    last = hs1.getPos();
    print(last + "\n");
  }
  hs1.update();
  hs1.display();
  hs2.update();
  hs2.display();

  pushMatrix();
  translate(width/2, width/3, height/4);  //параметры освещения
 
  directionalLight(167, 243, 255, width/2, width/3, height/4); //направленное освещение
  ambientLight(102, 102, 102); //освещение внешней среды

  if (projectionStatus) { //по правому клику мыши через булевскую переменную меняем ортографическую на изометрическую проекции и наоборот
    ortho(-width/2, width/2, -height/2, height/2);
  } else {
    perspective();
  }
  rotateY(rotY + distX);   //вращение осей
  rotateX(rotX + distY);

  scale((float)scale_value * 1.21 / (float)100);
  color c1 = color(255);
  color c2 = color(167, 243, 255);
  int n = (int)pow(hs1.getPos(), 0.7); //n - параметр, задающий мелкость разбиения
  int n2 = (int)(hs2.getPos()/30);
  emissive(n2); //свойство материала - количество отражаемого света
  shininess(5);
  asixDraw();
  shapeFigure(9, 15, 150, n, c1, c2, fillStatus, zero);
  popMatrix();
}

void asixDraw() { //отрисовка осей
  strokeWeight(2);
  stroke(255, 0, 0);
  line(0, 0, 200, 0);       
  stroke(0, 255, 0);
  line(0, 200, 0, 0);
  stroke(0, 0, 255);
  line(0, 0, 0, 0, 0, 200); 
  strokeWeight(1);
}

void shapeFigure(int x1, int x2, int h, int n, color c1, color c2, boolean filling, PVector zero) { //построение поверхности фигуры
  if (filling) {
    fill(c2);
  } else {
    noFill();
  }
  
  strokeWeight(0);
  stroke(c1);
  ArrayList<PVector> nodes = new ArrayList<PVector>();
  ArrayList<PVector> nodes2 = new ArrayList<PVector>();
  for (float x = x1; x <= x2; x += (float)(x2-x1)/n) { //вычисление точек параболы
    float y = pow(x, 2);
    PVector v = new PVector(10*x + zero.x, y + zero.y, 0); //добавление точек в список точек
    nodes.add(v);
    PVector v2 = new PVector(-10*x + zero.x, y + zero.y, 0);
    nodes2.add(v2);
}

  int idx = 0;
  beginShape(QUADS);  //построение точек поверхности
  vertex(nodes.get(idx).x, nodes.get(idx).y, -h/2);  
  vertex(nodes.get(idx).x, nodes.get(idx).y, h/2);
  vertex(nodes2.get(idx).x, nodes2.get(idx).y, h/2);
  vertex(nodes2.get(idx).x, nodes2.get(idx).y, -h/2);
  endShape();
  for (int i = 0; i < nodes.size() - 1; i++) { //построение одной боковой поверхности
    PVector v1 = nodes.get(i);
    PVector v1next = nodes.get(i + 1);
    PVector v2 = nodes.get(i);
    PVector v2next = nodes.get(i + 1);
    beginShape(QUADS);
    vertex(v1next.x, v1next.y, -h/2);
    vertex(v1.x, v1.y, -h/2);
    vertex(v2.x, v2.y, h/2);
    vertex(v2next.x, v2next.y, h/2);
    endShape();
  }

  for (int i = 0; i < nodes2.size() - 1; i++) { //построение симметричной боковой поверхности
    PVector v1 = nodes2.get(i);
    PVector v1next = nodes2.get(i + 1);
    PVector v2 = nodes2.get(i);
    PVector v2next = nodes2.get(i + 1);
    beginShape(QUADS);
    vertex(v1next.x, v1next.y, -h/2);
    vertex(v1.x, v1.y, -h/2);
    vertex(v2.x, v2.y, h/2);
    vertex(v2next.x, v2next.y, h/2);
    endShape();
  }
  stroke(c1);

  for (int i = 0; i < nodes2.size() - 1; i++) { //построение двух оснований
    PVector v1 = nodes.get(i);
    PVector v1next = nodes.get(i + 1);
    PVector v2 = nodes2.get(i);
    PVector v2next = nodes2.get(i + 1);
    beginShape(QUADS);
    vertex(v1next.x, v1next.y, h/2);
    vertex(v1.x, v1.y, h/2);
    vertex(v2.x, v2.y, h/2);
    vertex(v2next.x, v2next.y, h/2);
    endShape();
    beginShape(QUADS);
    vertex(v1next.x, v1next.y, -h/2);
    vertex(v1.x, v1.y, -h/2);
    vertex(v2.x, v2.y, -h/2);
    vertex(v2next.x, v2next.y, -h/2);
    endShape();
  }
  int last = nodes.size() - 1;
  beginShape(QUADS);
  vertex(nodes.get(last).x, nodes.get(last).y, -h/2);
  vertex(nodes.get(last).x, nodes.get(last).y, h/2);
  vertex(nodes2.get(last).x, nodes2.get(last).y, h/2);
  vertex(nodes2.get(last).x, nodes2.get(last).y, -h/2);
  endShape();
}

void mousePressed() { //мемоизация координат мыши при нажатии на кнопку
  lastX = mouseX;
  lastY = mouseY;
}

void mouseDragged() { //вычисление разницы между начальным и текущим положением мыши
  if (mouseY > 46) {
    distX = radians(mouseX - lastX);
    distY = radians(lastY - mouseY);
  }
}

void mouseReleased() { //вычисление углов для поворота фигуры
  rotX += distY;
  rotY += distX;


  if (mouseButton == LEFT && (distX == 0) && (distY == 0)  && mouseY > 46) { //изменение проекции фигуры по нажатии на левую кнопку мыши
    projectionStatus = (projectionStatus) ? false : true;
  }
  distX = distY = 0.0;
}

void mouseWheel(MouseEvent event) { //изменение масштаба по движению колёсика мыши
  if (scale_value >= 1) {
    scale_value += event.getCount();
  }
}

class HScrollbar {
  int swidth, sheight;    // ширина и высота ползунков
  float xpos, ypos;       
  float spos, newspos;    
  float sposMin, sposMax; // максимальное и минимальное значения ползунков
  int loose;             
  boolean over;          
  boolean locked;
  float ratio;

  HScrollbar (float xp, float yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }

  void update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
      mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    noStroke();
    fill(255);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } else {
      fill(0, 0, 255);
    }
    rect(spos, ypos, sheight, sheight);
  }

  float getPos() {
    return spos * ratio;
  }
}
