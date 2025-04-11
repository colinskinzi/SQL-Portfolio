-- Data Cleaning

select *
from layoffs;

-- Steps
-- 1. remove Duplicates
-- 2.Standardize the Data
-- 3. Null values or Values
-- 4. Remove any Columns( Irrelevant columns)


Create Table Layoffs_staging
like layoffs;

select *
from layoffs_staging;

Insert layoffs_staging
select *
from layoffs;

Select *,
ROW_NUMBER() OVER(
Partition by company, industry, total_laid_off, Percentage_laid_off, 'date') AS row_num
from layoffs_staging;

with duplicate_cte as
(Select *,
ROW_NUMBER() OVER(
Partition by company,location, industry, total_laid_off, Percentage_laid_off, 'date', 
stage, country, funds_raised_millions) AS row_num
from layoffs_staging
)
select *
from duplicate_cte
where row_num > 1;


select *
from layoffs_staging
where company = 'Cazoo';

with duplicate_cte as
(Select *,
ROW_NUMBER() OVER(
Partition by company,location, industry, total_laid_off, Percentage_laid_off, 'date', 
stage, country, funds_raised_millions) AS row_num
from layoffs_staging
)
Delete 
from duplicate_cte
where row_num > 1;


select *
from layoffs_staging;
 
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from layoffs_staging2
where row_num > 1;


Insert into layoffs_staging2
Select *,
ROW_NUMBER() OVER(
Partition by company,location, industry, total_laid_off, Percentage_laid_off, 'date', 
stage, country, funds_raised_millions) AS row_num
from layoffs_staging;

delete
from layoffs_staging2
where row_num > 1;

select *
from layoffs_staging2;

-- Standardizing Data

select company, TRIM(company)
from layoffs_staging2;

Update layoffs_staging2
set company = TRIM(company)
;

select *
from layoffs_staging2
where industry like 'Crypto%';

Update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';


select distinct country, trim(trailing '.' from country)
from layoffs_staging2
order by 1;

Update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'United States%';
;

-- modify the date
/* select `date`, 
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2;

update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

alter table layoffs_staging2
modify column `date` DATE; */

select *
from layoffs_staging2
where total_laid_off is NULL
and percentage_laid_off is NULL;


select *
from layoffs_staging2
where industry is NULL 
or industry = '';

select *
from layoffs_staging2
where company like 'Bally%';

/* select t1.industry, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
where (t1.industry is NULL)
and t2.industry is not null;

update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
set t1.industry =t2.industry
where t1.industry is NULl
and t2.industry is not null;  

delete 
from layoffs_staging2
where total_laid_off is NULL
and percentage_laid_off is NULL;

alter table layoffs_staging2
drop column row_num;*/


select *
from layoffs_staging2;




























