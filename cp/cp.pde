//Слесарева Д.С. м80-307б
//Вариант 16
//Поверхность вращения. Образующая – Cardinal Spline 3D.

float rotX = 0.0, rotY = 0.0;
float distX = 0.0, distY = 0.0;
int lastX, lastY;
int scale_value = 100;
boolean projectionStatus = false;
ArrayList<PVector> points; //вектор точек
Boolean [] moving = {false, false, false, false}; //массив состояний (нужен для перемещения вершин)
String file = "";
PrintWriter output; 
PShape s; //фигура
float t = 0; 
int id = 0;
int r = 5; //радиус сфер 
float n = 0.01; //параметр аппроксимации
void setup() {   
  size(1000, 800, P3D); //создание сцены
  points = new ArrayList();
  //добавление четырёх ключевых точек для кривой
  points.add(new PVector(-60.0, 120.0, 28.0));  
  points.add(new PVector(-96.0, 76.0, -100.0));
  points.add(new PVector(64.0, 0.0, 116.0));
  points.add(new PVector(200.0, 0.0, 100.0));
}

void draw() {
  //ввод кординат точек из файла
  if (keyPressed && key == 'i') {
    selectInput("Select a file load:", "fileSelected");
  }

  if (file != "") { //запись из файла
    String[] lines = loadStrings(file);
    print(lines[0]);
    String[] nodes_str = lines[0].split("\\*");
    for (int i = 0; i < nodes_str.length; i++) {
      String[] node = nodes_str[i].split(" ");
      points.set(i, new PVector(float(node[0]), float(node[1]), float(node[2])));
    }
    file = "";
  }
  //запись текущих кординат точек в новый файл
  if (keyPressed && key == 'o') {
    PVector p1 = points.get(0).copy();
    PVector p2 = points.get(1).copy();
    PVector p3 = points.get(2).copy();
    PVector p4 = points.get(3).copy();
    output = createWriter("positions_" + str(id) + ".txt"); 
    String sp1 = str(p1.x) + " " + str(p1.y) +  " " + str(p1.z);
    String sp2 = str(p2.x) + " " + str(p2.y) +  " " + str(p2.z);
    String sp3 = str(p3.x) + " " + str(p3.y) +  " " + str(p3.z);
    String sp4 = str(p4.x) + " " + str(p4.y) +  " " + str(p4.z);

    output.print(sp1 + '*' + sp2 + '*' + sp3 + '*' + sp4);
    output.flush();
    output.close();
  }
  //регулирование точности аппроксимации
  if (keyPressed && key == '-' && n < 0.4)  n += 0.003;
  if (keyPressed && key == '+' && n > 0.01) n -= 0.003;

  background(246, 196, 246); 
  lights();
  textSize(20); 
  text ("Точность аппроксимации: (регулируется на +-)" + str(1/n), 10, 25);

  //транслирование координат в центр экрана
  translate(width/2, width/3, height/4);
  if (projectionStatus) {
    ortho(-width/2, width/2, -height/2, height/2);
  } else {
    perspective();
  }
  //вращение осей
  rotateY(rotY + distX);
  rotateX(rotX + distY);
  scale((float)scale_value * 1.21 / (float)100);
  //кординаты кривой
  PVector begin = points.get(0).copy();
  stroke(255, 0, 0);
  strokeWeight(1);
  //отрисовка направляющих
  for (int i = 1; i < points.size(); i++) {
    PVector end = points.get(i).copy();
    line(begin.x, begin.y, begin.z, end.x, end.y, end.z);
    begin = end;
  }
  //отрисовка вспомогательных элементов
  for (int i = 0; i < points.size(); i++) {
    PVector p = points.get(i).copy();
    PVector move = points.get(i);
    color c = color(255);
    color c1 = color(0, 200, 0);
    color c2 = color(200, 0, 0);
    color c3 = color(0, 0, 200);
    //перемещение узлов по всем осям
    if (moving[i]) {
      c = color(255, 255, 0);
      if (keyPressed && key == 'q') {
        c1 = color(255, 255, 0);
        points.set(i, new PVector(move.x, move.y+4, move.z));
      }
      if (keyPressed && key == 'a') {
        c1 = color(255, 255, 0);
        points.set(i, new PVector(move.x, move.y-4, move.z));
      }
      if (keyPressed && key == 'w') {
        c2 = color(255, 255, 0);
        points.set(i, new PVector(move.x+4, move.y, move.z));
      }
      if (keyPressed && key == 's') {
        c2 = color(255, 255, 0);
        points.set(i, new PVector(move.x-4, move.y, move.z));
      }
      if (keyPressed && key == 'e') {
        c3 = color(255, 255, 0);
        points.set(i, new PVector(move.x, move.y, move.z+4));
      }
      if (keyPressed && key == 'd') {
        c3 = color(255, 255, 0);
        points.set(i, new PVector(move.x, move.y, move.z-4));
      }
    }
    
    /*
    отрисовка вспомогательных осей
    у каждой из точек,
    изменеие цвета как вершин, так и вспомогательных осей
    при выборе и движении соответственно
    */
    strokeWeight(3);
    stroke(c2);
    line(p.x, p.y, p.z, p.x+100, p.y, p.z); //ось для х
    pushMatrix();
    strokeWeight(0);
    fill(c2);
    translate(p.x+100, p.y, p.z);
    sphere(r);
    popMatrix();
    strokeWeight(3);
    stroke(c1); 
    line(p.x, p.y, p.z, p.x, p.y+100, p.z); //ось для у
    pushMatrix();
    strokeWeight(0);
    fill(c1);
    translate(p.x, p.y+100, p.z);
    sphere(r);
    popMatrix();
    strokeWeight(3);
    stroke(c3);
    line(p.x, p.y, p.z, p.x, p.y, p.z+100); // ось для z
    pushMatrix();
    strokeWeight(0);
    fill(c3);
    translate(p.x, p.y, p.z+100);
    sphere(r);
    popMatrix();
    pushMatrix();
    translate(p.x, p.y, p.z);
    fill(c);
    noStroke();
    sphere(r);
    popMatrix();
  }
  
 //выбор точек при нажатии на клавиши
  if (keyPressed && key == '1') {
    moving[0] = true;
    moving[1] = false;  
    moving[2] = false;
    moving[3] = false;
  }
  if (keyPressed && key == '2') {
    moving[0] = false;
    moving[1] = true;
    moving[2] = false;
    moving[3] = false;
  }
  if (keyPressed && key == '3') {
    moving[0] = false;
    moving[1] = false;
    moving[2] = true;
    moving[3] = false;
  }
  if (keyPressed && key == '4') {
    moving[0] = false;
    moving[1] = false;
    moving[2] = false;
    moving[3] = true;
  }

  ArrayList<PVector> curves = new ArrayList<PVector>();
  //вычисление координат кривой
  for (float t = 0; t < 1; t += n) {
    curves.add(PointOnCurve(points.get(0), points.get(1), points.get(2), points.get(3), t));
  }
  //вращение кривой вдоль оси z
  for (float ang = 0; ang < 2*PI; ang += n*10) {
    pushMatrix();
    beginShape();
    noFill();
    stroke(255, 0, 0);
    strokeWeight(2);
    for (int i = 0; i < curves.size(); i++) {
      vertex(curves.get(i).x, curves.get(i).y, curves.get(i).z);
    }
    rotateZ(ang);
    endShape();
    popMatrix();
  }
}

// вычисление координат кривой для четырёх точек
PVector PointOnCurve(PVector p0, PVector p1, PVector p2, PVector p3, float t) {
  PVector ret = new PVector();
  float t2 = t * t;
  float t3 = t2 * t;

  ret.x = 0.5f * ((2.0f * p1.x) +
    (-p0.x + p2.x) * t +
    (2.0f * p0.x - 5.0f * p1.x + 4 * p2.x - p3.x) * t2 +
    (-p0.x + 3.0f * p1.x - 3.0f * p2.x + p3.x) * t3);

  ret.y = 0.5f * ((2.0f * p1.y) +
    (-p0.y + p2.y) * t +
    (2.0f * p0.y - 5.0f * p1.y + 4 * p2.y - p3.y) * t2 +
    (-p0.y + 3.0f * p1.y - 3.0f * p2.y + p3.y) * t3);

  ret.z = 0.5f * ((2.0f * p1.z) +
    (-p0.z + p2.z) * t +
    (2.0f * p0.z - 5.0f * p1.z + 4 * p2.z - p3.z) * t2 +
    (-p0.z + 3.0f * p1.z - 3.0f * p2.z + p3.z) * t3);

  return ret;
}


void asixDraw() {
  strokeWeight(2);
  stroke(237, 41, 57);
  line(-200, 0, 200, 0);       
  line(0, 200, 0, -200);       
  line(0, 0, -200, 0, 0, 200); 
  strokeWeight(1);
}

//обработчик ввода в файл
void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    file = selection.getAbsolutePath();
  }
}

void mousePressed() {
  lastX = mouseX;
  lastY = mouseY;
}

void mouseDragged() {
  if (mouseY > 46) {
    distX = radians(mouseX - lastX);
    distY = radians(lastY - mouseY);
  }
}

void mouseReleased() {
  rotX += distY;
  rotY += distX;


  if (mouseButton == LEFT && (distX == 0) && (distY == 0)  && mouseY > 46) {
    projectionStatus = (projectionStatus) ? false : true;
  }
  distX = distY = 0.0;
}

void mouseWheel(MouseEvent event) {
  if (scale_value >= 1) {
    scale_value += 3*event.getCount();
  }
}
