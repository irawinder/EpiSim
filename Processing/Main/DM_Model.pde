/**
 * A Model is a static representation of the objects and rules that govern the 
 * abstraction of a phenomenon's elements. It's state is altered by by applying 
 * governing rules
 */ 
public interface Model {
  
  /**
   * Update the model's state over time and add result to series
   */
  public void update(ResultSeries outcome);
}
