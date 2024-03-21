Select *
From portfolioproject..CovidDeaths$
Where continent is not null
order by 3,4

--Select *
--From portfolioproject..CovidVaccinations$
--order by 3,4

Select Location,date, total_cases,new_cases,total_deaths, population
From PortfolioProject..CovidDeaths$
order by 1,2

--Looking at total cases vs Total Death

Select Location,date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
where location like '%Africa%'
order by 1,2
Select Location,date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
where location like '%SOUTH Africa%'
and continent is not null
order by 1,2

--Total Cases vs Population
--shows what percentage of population got covid
Select Location,date, total_cases,population,(total_cases/population)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
where location like '%SOUTH Africa%'
order by 1,2

Select Location,date, total_cases,population,(total_cases/population)*100 as DeathPercentaPercentpopulationInfectedge
From PortfolioProject..CovidDeaths$
where location like '%Africa%'
order by 1,2
Select Location,date, total_cases,population,(total_cases/population)*100 as PercentpopulationInfected
From PortfolioProject..CovidDeaths$
--where location like '%states%'
order by 1,2

--What country has the most infection rates compared to population

Select location, Population,Max (total_cases)as HigestestinfectionCount, Max (total_cases/population)*100 as 
PercentpopulationInfected
From PortfolioProject..CovidDeaths$
--where location like '%states%'
Group by location, Population
order by 1,2

Select location, Population,Max (total_cases)as HigestestinfectionCount, Max (total_cases/population)*100 as 
PercentpopulationInfected
From PortfolioProject..CovidDeaths$
--where location like '%Africa%'
Group by location, Population
order by 1,2

Select continent, Population,Max (total_cases)as HighestdeathCount, Max (total_cases/population)*100 as 
PercentpopulationInfected
From PortfolioProject..CovidDeaths$
--where location like '%Africa%'
Group by continent, Population
order by PercentpopulationInfected desc

--Showing Countries with Highest Death Count per Population

Select Location, Max (cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
--where location like '%Nigeria%'
Where continent is not null
Group by Location
order by TotalDeathCount desc

--LET'S BREAK THINGS DOWN BY CONTINENT

Select location, Max (cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
--where location like '%Nigeria%'
Where continent is null
Group by location
order by TotalDeathCount desc

Select continent, Max (cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
--where location like '%Nigeria%'
Where continent is not null
Group by continent
order by TotalDeathCount desc

--Showing the continents with the higest death count

Select continent, Max (cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
--where location like '%Nigeria%'
Where continent is not null
Group by continent
order by TotalDeathCount desc



--Global Numbers

Select date, SUM (new_cases)--, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
---where location like '%Nigeria%'
Where continent is not null
Group By date
order by 1,2

Select date, SUM (new_cases),Sum (cast(new_deaths as int)),SUM(cast (New_deaths as int))/Sum 
(New_Cases)* 100 as DeathPercentage
From PortfolioProject..CovidDeaths$
---where location like '%Nigeria%'
Where continent is not null
Group By date
order by 1,2

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_death, SUM(cast (New_deaths as int))
/SUM(New_Cases)* 100 as DeathPercentage
From PortfolioProject..CovidDeaths$
---where location like '%Nigeria%'
Where continent is not null
Group By date
order by 1,2

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_death, SUM(cast (New_deaths as int))
/SUM(New_Cases)* 100 as DeathPercentage
From PortfolioProject..CovidDeaths$
---where location like '%Nigeria%'
Where continent is not null
--Group By date
order by 1,2

--Total population vs Vaccination

Select *
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
 on dea.location = vac.location
 and dea.date = vac.date

Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
 on dea.location = vac.location
 and dea.date = vac.date
 Where dea.continent is not null
 order by 1,2,3

 Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
 , SUM (cast( vac.new_vaccinations as int)) Over (partition by dea.location)
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
 on dea.location = vac.location
 and dea.date = vac.date
 Where dea.continent is not null
 order by 2,3
 
 --Using CTE
 
 With Popvsvac (Continent, location, Date, Population,new_vaccinations, RollingpeopleVaccinated)
 as
 (
 Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
 , SUM (cast( vac.new_vaccinations as int)) Over (partition by dea.location order by dea.location,
 dea.Date) as RollingpeopleVaccinated
 --,(Rollingpeoplevaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
 on dea.location = vac.location
 and dea.date = vac.date
 Where dea.continent is not null
-- order by 2,3
 )
 Select *, (Rollingpeoplevaccinated/population)*100
 From PopvsVac



 --Temp Table
 Drop Table if exists #percentpopulationVaccinated

 Create Table #percentpopulationVaccinated
 (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 New_vaccinations numeric,
 RollingpeopleVaccinated numeric
 )

 Insert #percentpopulationVaccinated
 Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
 , SUM (cast( vac.new_vaccinations as int)) Over (partition by dea.location order by dea.location,
 dea.Date) as RollingpeopleVaccinated
 --,(Rollingpeoplevaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
 on dea.location = vac.location
 and dea.date = vac.date
-- Where dea.continent is not null
-- order by 2,3
Select *, (Rollingpeoplevaccinated/population)*100
 From #percentpopulationVaccinated



 --Creating view to store data for later visualizations
 
Create View percentpopulationVaccinated as
 Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
 , SUM (cast( vac.new_vaccinations as int)) Over (partition by dea.location order by dea.location,
 dea.Date) as RollingpeopleVaccinated
 --,(Rollingpeoplevaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
 on dea.location = vac.location
 and dea.date = vac.date
Where dea.continent is not null
 --order by 2,3
 
 Select*
 From #percentpopulationVaccinated

 Create View Rollingpeoplevaccinated as
 Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
 , SUM (cast( vac.new_vaccinations as int)) Over (partition by dea.location order by dea.location,
 dea.Date) as RollingpeopleVaccinated
 --,(Rollingpeoplevaccinated/population)*100
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
 on dea.location = vac.location
 and dea.date = vac.date
Where dea.continent is not null
 --order by 2,3