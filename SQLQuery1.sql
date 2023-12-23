select*
from PortfolioProject..CovidDeaths
order by 3,4

----select*
----from PortfolioProject..CovidVaccinations
----order by 3,4

------select Data that we arae going to be using

select location, date, total_cases, new_cases, total_deaths,population
from PortfolioProject..CovidDeaths
order by 1,2

--Looking at the total cases vs total deaths
--Showing the total case and death reported for india

select location,date, convert(float,total_cases) as totalcase, convert(float,total_deaths) as totaldeaths,(convert(float,total_deaths)/convert(float,total_cases))*100 as deathratio
from PortfolioProject..CovidDeaths
where location like 'india'
order by 1,2

--look at total cases vs population
--shows what percentage of population got covid

select location,date, population, convert(float,total_cases) as totalcase, (convert(float,total_cases)/population)*100 as affectedbycovid
from PortfolioProject..CovidDeaths
where location like 'india'
order by 1,2

---looking at countries with highest infection rate compared to population

select location, population, MAX(convert(int,total_cases)) as highestinfectioncount, MAX((convert(int,total_cases)/population)) *100 as percentagepopulationinfected
from PortfolioProject..CovidDeaths
---where location like 'india'
Group by location,population
order by percentagepopulationinfected desc


---showing countries with highest death count per population

select location, MAX(CONVERT(int,total_deaths)) as Totaldeathcount
from PortfolioProject..CovidDeaths
---where location like 'india'
where continent is not null
Group by location
order by Totaldeathcount desc


-- lets breakthings down by continent

select continent, MAX(CONVERT(int,total_deaths)) as Totaldeathcount
from PortfolioProject..CovidDeaths
---where location like 'india'
where continent is not null
Group by continent
order by Totaldeathcount desc


--showing the continent with highest death count

select location,date, convert(float,total_cases) as totalcase, convert(float,total_deaths) as totaldeaths,(convert(float,total_deaths)/convert(float,total_cases))*100 as deathratio
from PortfolioProject..CovidDeaths
--where location like 'india'
where continent is not null
order by 1,2
---looking at total population vs vaccinated

select dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
,sum(convert(float,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
order by 1,2,3

