Select * From project1.covid_deaths;
Select * From project1.covid_vaccinations;

-- Order Tables by column 3 and 4
Select * from project1.covid_deaths order by 3,4;
Select * from project1.covid_vaccinations order by 3,4;

-- Select data that we are going to use
Select Location,date_D,total_cases,new_cases,total_deaths, population
from project1.covid_deaths
order by 1,2

-- Looking at total cases vs total deaths
Select Location, Date_D, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from project1.covid_deaths
where location like '%morocco%'
order by 1,2

-- looking at the total cases vs population
Select Location, Date_D, population, total_cases, (total_cases/population)*100 as population_infected
from project1.covid_deaths
-- where location like '%morocco%'
order by 1,2

-- looking at countries with highest infection rate compared to population
Select Location, population, max(total_cases) as highest_infection, max((total_cases/population))*100 as population_infected
from project1.covid_deaths
-- where location like '%morocco%'
group by Location, population
order by population_infected desc

-- looking at countries where highest death rate
Select Location, population, max(total_deaths) as highest_deaths, max((total_deaths/population))*100 as population_deaths
from project1.covid_deaths
-- where location like '%morocco%'
group by Location, population
order by population_deaths desc

-- Showing countries with highest death count per population
Select Location, max(total_deaths) as TotalDeathCount
from project1.covid_deaths
-- where location like '%morocco%'
group by Location
order by TotalDeathCount desc

-- Breaking it up by continent
Select continent, max(total_deaths) as TotalDeathCount
from project1.covid_deaths
-- where location like '%morocco%'
group by continent
order by TotalDeathCount desc

-- Global Data/Numbers
Select Date_D, SUM(new_cases) as Total_cases, SUM(new_deaths) as Total_Deaths, SUM(new_deaths)/SUM(new_cases) *100 as DeathPercentage
from project1.covid_deaths
-- where location like '%morocco%'
group by Date_D
order by 1,2

-- Total cases in the world
Select SUM(new_cases) as Total_cases, SUM(new_deaths) as Total_Deaths, SUM(new_deaths)/SUM(new_cases) *100 as DeathPercentage
from project1.covid_deaths
-- where location like '%morocco%'
order by 1,2

-- TABLE COVID VACCINATION
Select * From project1.covid_deaths dea
Join project1.covid_vaccinations vac
	on dea.location = vac.location
    and dea.date_D = vac.date_
    
-- Looking at total population vs vaccinations
Select dea.continent, dea.location, dea.date_D, dea.population, vac.new_vaccinations
, SUM(new_vaccinations) over (Partition by dea.location order by dea.location, dea.date_D) As Rolling_PeopleVaccinated
From project1.covid_deaths dea
Join project1.covid_vaccinations vac
	on dea.location = vac.location
    and dea.date_D = vac.date_
order by 2,3

-- USE CTE

With PopvsVac(continent, location, date_D, population, new_vaccinations, Rolling_PeopleVaccinated)
As
(
Select dea.continent, dea.location, dea.date_D, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) over (Partition by dea.location order by dea.location, dea.date_D) As Rolling_PeopleVaccinated
From project1.covid_deaths dea
Join project1.covid_vaccinations vac
	on dea.location = vac.location
    and dea.date_D = vac.date_
Where dea.location is not null
-- order by 2,3
)

Select * , (Rolling_PeopleVaccinated/Population)*100 As Percentage_RollingVac
From PopvsVac
-- Where location like '%morocco%'

-- TEMP TABLE
DROP TABLE IF exists PercentPopulationVaccinated
Create Table PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date_D datetime,
population numeric,
new_vaccinations numeric,
Rolling_PeopleVaccinated numeric
)

Insert into PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date_D, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) over (Partition by dea.location order by dea.location, dea.date_D) As Rolling_PeopleVaccinated
From project1.covid_deaths dea
Join project1.covid_vaccinations vac
	on dea.location = vac.location
    and dea.date_D = vac.date_
-- Where dea.location is not null
-- order by 2,3

Select * , (Rolling_PeopleVaccinated/population)*100
From PercentPopulationVaccinated

-- Creating View to store data for visualization
Create view  PercentPopulationVaccinated As
Select dea.continent, dea.location, dea.date_D, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) over (Partition by dea.location order by dea.location, dea.date_D) As Rolling_PeopleVaccinated
From project1.covid_deaths dea
Join project1.covid_vaccinations vac
	on dea.location = vac.location
    and dea.date_D = vac.date_
Where dea.location is not null
-- order by 2,3

Select * from PercentPopulationVaccinated











