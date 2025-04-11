-- Exploratory Data Analysis

select * 
from layoffs_staging2;

select Max(total_laid_off),max(percentage_laid_off)
from layoffs_staging2;


-- Companies with 100% layoffs.
select * 
from layoffs_staging2
where percentage_laid_off = 1
order by industry desc;

-- Total layoffs per company. 
select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

-- dates layoffs started. 
select min(`date`), max(`date`)
from layoffs_staging2;

-- layoffs by Industry
select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

-- layoffs by Country
select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

-- Layoffs by Year
select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by  1 desc;

-- layoffs by the Stage the compnay is at. 
select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;

-- layoffs by month
select substring(`date`,1,7) as `MONTH`, sum(total_laid_off) as total_off
from layoffs_staging2
where 	substring(`date`,1,7) is not null
group by `MONTH`
order by 1 asc;

-- Rolling Total by month

with Rolling_Total as 
(
select substring(`date`,1,7) as `MONTH`, sum(total_laid_off) as total_off
from layoffs_staging2
where 	substring(`date`,1,7) is not null
group by `MONTH`
order by 1 asc
)
select `MONTH`, total_off, sum(total_off) over (order by `MONTH`) as rolling_total
from Rolling_total;

 
select company,Year(`date`),  sum(total_laid_off)
from layoffs_staging2
group by company, Year(`date`)
order by 3 desc;


-- TOP 5 Ranking yearly layoffs by company per year. 

with Company_Year (company,years, total_laid_off) as 
(select company,Year(`date`),  sum(total_laid_off)
from layoffs_staging2
group by company, Year(`date`)
), 
Company_Year_Rank as
(select * ,
dense_rank() over (partition by years order by total_laid_off DEsc) as Ranking
from Company_Year
where years is not null
)
select *
from Company_Year_Rank
where Ranking <= 5;

select * 
from layoffs_staging2;












































