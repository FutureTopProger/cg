//Слесарева Д.С. м80-307б
//Вариант 16
//NURB-кривая. n = 6, k = 3. Узловой вектор неравномерный. Веса точек различны и модифицируются.NURB-кривая. n = 6, k = 3. Узловой вектор неравномерный. Веса точек различны и модифицируются.

PVector tmp = new PVector(0, 0);
PVector prev = new PVector(0, 0);

//количество узлов
int pNum = 6;
//начальная степень
int deg = 3;
//максимальная степень
int degMax = 6;
PVector[] p = new PVector[pNum];//вектор точек
float w[] = new float[pNum];//вектор весов точек
int m = pNum + degMax + 1; //количество узлов
float nVec[] = new float[m]; //вектор узлов
int selected; //индекс выбранного узла
int wKey; //выбранная клавиша


void setup() {
  size(1000, 600);
  colorMode(RGB, 255);
  //вычисление случайных кординат точек  
  for (int i = 0; i<pNum; i++) {
    p[i] = new PVector((float)i/(float)(pNum-1)*width, random(height));
    w[i] = 1.0;
  }
  //заполнение вектора узлов
  m = pNum + deg + 1;
  for (int i = 0; i<m; i++) {
    if (i<deg+1) nVec[i] = 0;
    else if (i > m - (deg+1)) nVec[i] = m - 1 - 2 * deg;
    else nVec[i] = i - deg;
  }
  //сглаживание
  smooth();
}

//отрисовка точек
void drawNode() {
  int i;
  rectMode(CENTER);        
  int rectL = 15;               
  for (i=0; i<pNum; i++) {
    if (w[i] == 0) { //размер точки зависит от ее веса
      stroke(255, 50, 0, 200); 
      noFill(); 
      rect(p[i].x, p[i].y, rectL, rectL);
    } else {//при увеличении веса размер увеличивается
      noStroke();                   
      fill(255, 50, 0, 200);           
      rect(p[i].x, p[i].y, (float)rectL*w[i], (float)rectL*w[i]);
    }
  }

  strokeWeight(1);        
  fill(255, 50, 0, 200);   
  noFill();
  //соединение точек линиями
  stroke(255, 50, 0, 50);  
  for (i=0; i<pNum-1; i++) {
    line(p[i].x, p[i].y, p[i+1].x, p[i+1].y);
  }
}

//рекурсивная функция вычисления значения функции сплайна по параметру
float calc(int i, int k, float t) {
  float val;
  float w1 = 0.0, w2 = 0.0;
  if (k==0) {
    if (nVec[i] <= t && t < nVec[i+1]) val = 1.0;
    else val = 0.0;
  } else {
    if ((nVec[i+k+1]-nVec[i+1])!=0)  
      w1 = calc(i+1, k-1, t) * (nVec[i+k+1] - t) / (nVec[i+k+1] - nVec[i+1]);
    if ((nVec[i+k]-nVec[i])!=0)  
      w2 = calc(i, k-1, t) * (t - nVec[i]) / (nVec[i+k] - nVec[i]);
    val = w1 + w2;
  }
  return val;
}
//функция отрисовки кривой
void drawNURBS() {
  float[] b = new float[pNum];

  for (float t=nVec[deg]; t < nVec[m-deg-1]; t += 0.001) {
    stroke(255, 170, 0);
    strokeWeight(2.5);
    tmp = new PVector(0, 0);
    float wp = 0;
    for (int j =0; j<pNum; j++) {
      b[j] = calc(j, deg, t);

      tmp.x += p[j].x * b[j] * w[j];
      tmp.y += p[j].y * b[j] * w[j];

      wp += b[j] * w[j];
    }
    tmp.x /= wp;
    tmp.y /= wp;

    if (t != nVec[deg] && t != nVec[m-deg-1] && ((tmp.x!= -1) && (prev.x != -1))) {
      line(tmp.x, tmp.y, prev.x, prev.y);
    }
    prev.set(tmp);
  }
}


void draw() {  
  background(246, 196, 246);
  
  textSize(12); 
  text ("Увеличить вес узла можно с зажатой клавишей +(увеличение) или - (уменьшение)\nкликая при этом по нужному узлу\nстепень интерполяции можно выбирать, нажимая на клавиши 1-5", 5, 15);
  stroke(255, 50, 0);
  drawNURBS();
  drawNode();
}
//обработчик нажатия мыши   
void mousePressed() {
  selected = -1;
  float minD = 10;
  int i;
  for (i=0; i<pNum; i++) {
    //если мышь находится в момент нажатия на одной из точек мы запоминаем индекс этой точки
    float d = dist(mouseX, mouseY, p[i].x, p[i].y);
    float scale = (w[i]>1.)?w[i]:1.;
    if (d < minD*scale) {
      minD = d;
      selected = i;
    }
  }
  //и при нажатии на точку с зажатыми клавишами +- мы можем менять ее вес
  if (selected != -1) {
    if (wKey == 1) {
      println("up");
      w[selected] += 0.2;
    } else if (wKey == 2) {
      w[selected] -= 0.2;
      if (w[selected] <= 0) w[selected] = 0;
    } else {

      p[selected].x = mouseX;
      p[selected].y = mouseY;
    }
  }
}

//обработчик движения мыши
void mouseDragged() {
  if (selected != -1) { //перетягивание точки
    p[selected].x = mouseX;
    p[selected].y = mouseY;
  }
}

//обработчик нажатия на клавиатуру
void keyPressed() {
  if (key == '+') {
    println('!');
    wKey = 1;
  }
  if (key == '-') {
    wKey = 2;
  }
  switch(keyCode) {
  case 49:
  case 50:
  case 51:
  case 52:
  case 53:
  case 54://изменение степени интерполяции
    deg = keyCode - 48;
    m = pNum + deg + 1;
    for (int i = 0; i<m; i++) {
      if (i<deg+1) nVec[i] = 0;
      else if (i > m - (deg+1)) nVec[i] = m - 1 - 2 * deg;
      else nVec[i] = i - deg;
    }
    break;
  }
}


void keyReleased() {
  wKey = 0;
}
