Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
  
  -- Selecting data to work with
Select CovidDeaths.location,CovidDeaths.date,CovidDeaths.total_cases,CovidDeaths.population
From CovidDeaths
Order by 1,2

Select CovidDeaths.location,CovidDeaths.date,CovidDeaths.total_cases,(cast(total_deaths as bigint)/total_cases)*100 Deathpercentage
From CovidDeaths
where CovidDeaths.continent is not null
Order by 1,2

-- Total cases vs total deaths-probability of dying if you contract covid by continent
Select CovidDeaths.location,CovidDeaths.date,CovidDeaths.total_cases,(cast(total_deaths as bigint)/total_cases)*100 Deathpercentage
From CovidDeaths
Where CovidDeaths.continent like '%Asia%'
and CovidDeaths.continent is not null
Order by 1,2
  
-- Countries with Highest Infection Rate compared to Population
Select CovidDeaths.location,MAX(CovidDeaths.total_cases) HighestInfectioncount,MAX(CovidDeaths.total_cases/CovidDeaths.population)*100 Percentagepopulationinfected
From CovidDeaths
Group by CovidDeaths.location,CovidDeaths.population
Order by Percentagepopulationinfected
  
-- Locations with highest covid death count per population
Select CovidDeaths.location,MAX(CovidDeaths.total_deaths) as TotalDeathcount
From CovidDeaths
where continent is not null
Group by CovidDeaths.location
Order by TotalDeathcount Desc
  
-- Continents with highest covid death count per population
Select CovidDeaths.continent,MAX(CovidDeaths.total_deaths) as TotalDeathcount
From CovidDeaths
where continent is not null
Group by CovidDeaths.continent
Order by TotalDeathcount Desc
  
-- Global Numbers
Select SUM(CovidDeaths.new_deaths) Totalcases, Sum(CovidDeaths.new_deaths) Totaldeaths,
SUM(CovidDeaths.new_deaths)/SUM(CovidDeaths.new_cases)*100 as Deathpercentage
from CovidDeaths
Order by 1,2

  -- Total Population vs Vaccinations-Percentage of population vaccinated at least once
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location) as Rollingpeoplevaccinated
from CovidDeaths dea
Join CovdiVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3
  
-- Using CTE to perform Calculation on Partition By in previous query
with PopvsVac (continent,location,date,population,new_vaccinations,Rollingpeoplevaccinated)
as
(select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location) as Rollingpeoplevaccinated
from CovidDeaths dea
Join CovdiVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null)
Select *,(Rollingpeoplevaccinated/population)*100 percentagepopulationvaccinated from PopvsVac

-- Using Temp Table to perform Calculation on Partition By in previous query
Drop table if exists #percentpopulationvaccinated
Create Table #percentpopulationvaccinated
(Continent nvarchar(255),Location nvarchar(255),Date datetime, 
Population numeric, new_vaccinations numeric,Rollingpeoplevaccinated numeric)
Insert into  #percentpopulationvaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location) as Rollingpeoplevaccinated
from CovidDeaths dea
Join CovdiVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
Select *,(Rollingpeoplevaccinated/population)*100
from #percentpopulationvaccinated
  
-- Creating View to store data for later visualizations
Drop view if exists percentpopulationvaccinated 
GO
Create view percentpopulationvaccinated 
as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location) as Rollingpeoplevaccinated
from CovidDeaths dea
Join CovdiVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null

  
Select * from percentpopulationvaccinated
