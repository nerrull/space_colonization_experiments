

class Rectangle
{
  float _width;
  float _height;
  PVector topLeft;
  PVector bottomRight;
  
  public Rectangle(PVector tl, float w, float h )
  {
    topLeft = tl;
    _width = w;
    _height = h;
    bottomRight = new PVector(tl.x + w, tl.y+h);
  }
  
  public boolean Contains(PointType point)
  {
    PVector p = point.center;
    return p.x >=topLeft.x && p.x <bottomRight.x && p.y >= topLeft.y && p.y <bottomRight.y;
  }
  
  public boolean Intersects(Rectangle other)
  {
    return   (    other.topLeft.x     > this.bottomRight.x 
              || other.topLeft.y     < this.bottomRight.y
              || other.bottomRight.x > this.topLeft.x
              || other.bottomRight.y < this.topLeft.y);
  }
  
  public void Draw()
  {
    rect(topLeft.x, topLeft.y, _width, _height);
  }
}

class QuadTree
{
  Rectangle boundaries;
  int maxPoints;
  int nPoints;
  int depth;
  boolean divided;
  PointType[] points;
  QuadTree ne, nw,se, sw;
  
  public QuadTree(Rectangle b, int maxPoints, int depth)
  {
    boundaries = b;
    this.maxPoints = maxPoints;
    this.depth = depth;
    points =new PointType[maxPoints];
    nPoints = 0;
  }
  
  private void Divide()
  {
    float w=  boundaries._width/2; 
    float h = boundaries._height/2;
    PVector tl = boundaries.topLeft;
    nw = new QuadTree(new Rectangle(boundaries.topLeft,w,h), maxPoints, depth+1);
    sw = new QuadTree(new Rectangle(new PVector(tl.x, tl.y + h),  w,h), maxPoints, depth+1);
    ne = new QuadTree(new Rectangle(new PVector(tl.x+w, tl.y),  w,h), maxPoints, depth+1);
    se = new QuadTree(new Rectangle(new PVector(tl.x+w, tl.y + h),  w,h), maxPoints, depth+1);
    divided =true;
  }
  
  public boolean Insert(PointType p)
  {
    if (!boundaries.Contains(p))
    {
      return false;
    }
    
    else if (nPoints < maxPoints)
    {
      points[nPoints] =p;
      nPoints++;
      return true;
    }
    else if (!divided)
    {
      Divide();
    }
    
    return ne.Insert(p) || nw.Insert(p) ||  se.Insert(p) || sw.Insert(p);
  }
  
  public void Draw()
  {
    boundaries.Draw();
    if (divided)
    {
      fill(0,50,0);
      ne.Draw();
      fill(255);
      nw.Draw();
      se.Draw();
      sw.Draw();
    }
    for (int i= 0; i <nPoints;i++)
    {
      points[i].Draw(); 
    }
   
  }
  
  public  ArrayList<PointType> QueryRadius(PVector center, float radius)
  {
    Rectangle boundary = new Rectangle(new PVector(center.x-radius, center.y -radius), radius*2, radius*2);
    ArrayList<PointType> foundPoints = new ArrayList<PointType>();
    QueryCircle(boundary, center, radius, foundPoints);
    return foundPoints;
  }
  //boundary, center, radius
  public void QueryCircle(Rectangle b, PVector c, float r,  ArrayList<PointType> foundPoints)
  {
    
    if (!boundaries.Intersects(b))
    {
      return;
    }
    
    int i =0;
    for(PointType point : points)
    {
      if (i >=nPoints) break;
      if (b.Contains(point) && point.DistanceTo(c) <= r)
      {
        foundPoints.add(point);
      }
      i++;
    }
    
      //# Recurse the search into this node's children.
     if (divided)
     {
       nw.QueryCircle(b,c,r,foundPoints);
       ne.QueryCircle(b,c,r,foundPoints);
       se.QueryCircle(b,c,r,foundPoints);
       sw.QueryCircle(b,c,r,foundPoints);
     }
  }
}
