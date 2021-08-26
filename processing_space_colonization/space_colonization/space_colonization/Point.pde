class PointType
{
  public PVector center;
  public PointType(float x, float y )
  {
    center = new PVector(x,y);
  }
  
  public void Draw()
  {
    ellipse(center.x, center.y, 5,5);
  }
  
  public float DistanceTo(PointType p)
  {
    return center.dist(p.center);
  }
  
  public float DistanceTo(PVector p)
  {
    return center.dist(p);
  }
}
