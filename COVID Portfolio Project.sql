SELECT *
  FROM [PortfolioProject].[dbo].[CovidDeaths$]
  where continent is not null
  order by 3,4


  SELECT Location, date, total_cases, new_cases,total_deaths,population
  FROM PortfolioProject..CovidDeaths$
  where continent is not null
  order by 1,2;

  --Looking at the Total Cases vs Total Deaths

  SELECT Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
  FROM PortfolioProject..CovidDeaths$
  where continent is not null
  order by 1,2;

  --Looking at the Total Cases vs Population
  --Shows the % of Population got Covid

  SELECT Location, date,population, total_cases, (total_cases/population)*100 as CasesPercentage
  FROM PortfolioProject..CovidDeaths$
  where location like '%Kenya%' and continent is not null
  order by 1,2;

  --Looking at Countries with Highest Infection Rate compared to Population. 

 SELECT Location, population, MAX(total_cases) as HighsestInfectionCount,  MAX((total_cases/population))*100 as PercentagePopulationInfected
  FROM PortfolioProject..CovidDeaths$
  where continent is not null
  group by Location, population
  order by PercentagePopulationInfected desc

--Showing Countrys with Highest Death Count per Population

select Location, MAX(cast(total_deaths as int)) as TotalDeathCount 
FROM PortfolioProject..CovidDeaths$
where continent is not null
group by Location 
order by TotalDeathCount desc

 
--Showing the ocntinents with the Highest Death Count per population
select continent, MAX(cast(total_deaths as int)) as TotalDeathCount 
from PortfolioProject..CovidDeaths$
where continent is not null
group by continent 
order by TotalDeathCount desc

--GLOBAL NUMBERS (Total Cases and Total Deaths)

select SUM(new_cases) as total_Cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(new_cases) *100 as DeathPercentage
from PortfolioProject..CovidDeaths$
where continent is not null
--group by date
order by 1,2

-- Looking at Total Population VS Vaccinations. 

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
,

from PortfolioProject ..CovidDeaths$ dea
Join PortfolioProject ..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- Use CTE
with PopVsVac (Continent, Location, Date, Population,new_vaccinations, RollingPeopleVaccinated)
as
(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject ..CovidDeaths$ dea
Join PortfolioProject ..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/Population) *100 as PercentageVaccinated
from PopVsVac


--TEMP Table

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject ..CovidDeaths$ dea
Join PortfolioProject ..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
Select *, (RollingPeopleVaccinated/Population)*100 as VaccinationPercentage
From #PercentPopulationVaccinated
where Continent is not null



-- Creating View to store data for Visualization.

Create view PercentagePopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject ..CovidDeaths$ dea
Join PortfolioProject ..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

Select * 
from PercentagePopulationVaccinated