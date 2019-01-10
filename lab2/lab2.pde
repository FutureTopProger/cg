//Слесарева Д.С. М80-307Б
//Вариант 16
// 16 – гранная прямая правильная пирамида

float rotX = 0.0, rotY = 0.0;
float distX = 0.0, distY = 0.0;
int lastX, lastY;
int scale_value = 100;
boolean fillStatus = false;
boolean projectionStatus = false;

void setup() {
  size(1500, 1000, P3D);
}

void draw() {
  background(246, 196, 246);
  translate(width/2, width/3, height/4);

  if (projectionStatus) { //по правому клику мыши через булевскую переменную меняем ортографическую на изометрическую проекции и наоборот
    ortho(-width/2, width/2, -height/2, height/2);
  } else {
    perspective();
  }

  rotateY(rotY + distX);
  rotateX(rotX + distY);

  scale((float)scale_value * 1.21 / (float)100);
  color c1 = color(255); 
  color c2 = color(222, 5, 252);
  shapePrism(70, 150, 16, c1, c2, fillStatus);
  asixDraw();
}

void asixDraw() {  //отрисовка осей
  strokeWeight(2);
  stroke(255, 0, 0);
  line(0, 0, 200, 0);       
  stroke(0, 255, 0);
  line(0, 200, 0, 0);
  stroke(0, 0, 255);
  line(0, 0, 0, 0, 0, 200); 
  strokeWeight(1);
}


void shapePrism(int R, int h, int n, color c1, color c2, boolean filling) { //постороение поверхности фигуры
  if (filling) {
    fill(c1);
  } else {
    noFill();
  }
  stroke(c2);
  ArrayList<PVector> nodes = new ArrayList<PVector>();
  for (int i = 0; i <= n; i++) {  //вычисляем координаты точек основания
    float xi = 0 + R * cos(0 + 2 * PI * i / n);
    float yi = 0 + R * sin(0 + 2 * PI * i / n);
    PVector v = new PVector(xi, yi, 0); //добавляем посчитанные координаты в вектор, а вектор затем в список векторов
    nodes.add(v);
  }
  for (int i = 0; i < nodes.size() - 1; i++) { //строим боковые стороны
    PVector v = nodes.get(i);
    PVector vnext = nodes.get(i + 1);
    beginShape();
    vertex(vnext.x, vnext.y, -h/2);
    vertex(v.x, v.y, -h/2);
    vertex(0, 0, h/2);
    endShape();
  }

  beginShape();
  for (int i = 0; i < nodes.size(); i++) { // строим основание
    PVector v = nodes.get(i);
    vertex(v.x, v.y, -h/2);
  }
  endShape();
}

void mousePressed() { //мемоизация координат мыши при нажатии на кнопку
  lastX = mouseX;
  lastY = mouseY;
}

void mouseDragged() { //вычисление разницы между начальным и текущим положением мыши
  distX = radians(mouseX - lastX);
  distY = radians(lastY - mouseY);
}

void mouseReleased() { //вычисление углов для поворота фигуры
  rotX += distY;
  rotY += distX;

  if (mouseButton == RIGHT && (distX == 0) && (distY == 0)) { //при разжатии правой кнопки мыши и неподвижной мыши нам надо залить фигуру
    fillStatus = (fillStatus) ? false : true;
  }
  if (mouseButton == LEFT && (distX == 0) && (distY == 0)) { //изменение проекции фигуры по нажатии на левую кнопку мыши
    projectionStatus = (projectionStatus) ? false : true;
  }
  distX = distY = 0.0;
}

void mouseWheel(MouseEvent event) { //изменение масштаба по движению колёсика мыши
  if (scale_value >= 1) {
    scale_value += event.getCount();
  }
}
