# EpiSim
This is a simple simulation of a viral outbreak using an agent-based population activity model.

![Epidemic Simulation by Ira Winder](screenshots/screenshot.png?raw=true "Epidemic Simulation by Ira Winder")

## Key features
- Includes simple city with reasonable land uses
  - Dwellings
  - Offices
  - Schools
  - Retail
  - Open Space
  - Hospitals
- Includes demographics
  - Children
  - Adults
  - Seniors
- Includes travel behavior model that implements a typical 5-day work week
- Includes two prototypical pathogens:
  - COVID-19
  - Common Cold
- User can enact quarantine of the population during run time
- User can Speed up, slow down, or pause simulation speed during run time
- User can view land use, demographics, gathering density, and infection status within the model
- User can view summary statistics of the population in the form of graphs and numbers
- Assumptions can be edited in the file 'A_ConfigModel.pde'

## How to open and run
Follow these steps to open and run the simulation in Processing. No coding skills are required.

	1. Make sure you have installed the latest version of Java
	https://www.java.com/verify/

	2. Download Processing 3
	https://processing.org/download/

	3. Clone this repository, preserving any files and folder structure
	
	4. Open and run "/Episim/Processing/Main/Main.pde" with Processing 3
