QuadTree root;
int nAttractors = 10;

ArrayList<PointType> nodes;
void setup()
{
  size(800, 800);
  root = new QuadTree( new Rectangle(new PVector(0,0), float (width),(float) height), 4, 0);
  nodes = new ArrayList<PointType>();
  for (int i =0; i<nAttractors; i++)
  {
    AddPoint();
  }
  
}

void draw()
{
  stroke(0, 0,0);
  fill(255, 255,255);
  root.Draw();
  

    DrawMouseSelector();
          AddPoint();
/*
    if(frameCount%10 ==0)
    {
      AddPoint();
    }
    */


}

void AddPoint()
{
    //PointType p = new PointType(random(width), random(height));
    
    PointType p = new PointType(min(width,random(50) +mouseX), min(height, random(50) +mouseY));

    if (!root.Insert(p))
    {
      println("Could not add point");
    }
}

void mouseMoved()
{
}

float mouseRadius = 25;
void DrawMouseSelector()
{
  stroke(150, 0,150);

  ellipse(mouseX, mouseY, mouseRadius*2, mouseRadius*2);

  ArrayList<PointType> points = root.QueryRadius(new PVector(mouseX, mouseY), mouseRadius);
  
  for (PointType p : points)
  {
    stroke(255, 0,0);
    fill(255,0,0);
    p.Draw();
  }
}


void mouseClicked()
{
  
}
