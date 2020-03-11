void test() {
  
  int counter = 0;
  
  Environment home = new Environment();
  home.setUID(counter); counter++;
  home.setName("Ira' House");
  home.setUse(LandUse.DWELLING);
  home.setArea(100);
  
  Environment work = new Environment();
  work.setUID(counter); counter++;
  work.setName("EDGEof");
  work.setUse(LandUse.OFFICE);
  work.setArea(1000);
  
  Host adult = new Host();
  adult.setUID(counter); counter++;
  adult.setName("Ira");
  adult.setAge(32);
  adult.setPrimaryEnvironment(home);
  adult.setSecondaryEnvironment(work);
  
  Agent corona = new Agent();
  corona.setUID(counter); counter++;
  corona.setName("COVID-19");
  corona.setPathogen(Pathogen.COVID_19);
  
  println(home);
  println(work);
  println("---");
  
  println(adult);
  println("- Primary Loc: " + adult.getPrimaryEnvironment());
  println("- Secondary Loc: " + adult.getSecondaryEnvironment());
  println("---");
  
  println(corona);
  println("---");
  
  home.addElement(adult);
  
  println(home);
  for(Element e : home.getElements()) {
    println("- " + e);
  }
  println("---");
    
  home.addElement(adult); // test redundancy
  println("---");
  
  home.removeElement(adult);
  
  println(home);
  for(Element e : home.getElements()) {
    println("- " + e);
  }
  println("---");
  
  adult.addElement(corona);
  work.addElement(adult);
  work.addElement(corona);
  
  println(work);
  for(Element e : work.getElements()) {
    println("- " + e);
  }
  println("---");
  
    println(adult);
  for(Element e : adult.getElements()) {
    println("- " + e);
  }
  println("---");
  
  // create random object 
  Random ran = new Random(); 

  // generating next gaussian
  double nxt = ran.nextGaussian(); 

  // Printing the random Number 
  System.out.println("The next Gaussian value generated is : " + nxt); 
}
