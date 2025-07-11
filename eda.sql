-- EDA

select * from layoffs_staging2;

select max(total_laid_off),max(percentage_laid_off)
from layoffs_staging2;

select *
from layoffs_staging2
where percentage_laid_off=1
order by funds_raised_millions;

select company,sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc  ;

select MAX(`date`),Min(`date`)
from layoffs_staging2;

select year(`date`),sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 2 desc  ;
with cte as
(
select substring(`date`,1,7) as month,sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month`
order by 1 asc
)
select `month`,total_off,sum(total_off) over (order by `month`)
from cte;

select company,year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company,year(`date`)
order by 3 desc;

with company_year (company,years,total_laid_off) as
(
select company,year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company,year(`date`)
order by 3 desc
),company_year_rank as(
select *,dense_rank() over (partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null
)
select * from company_year_rank where ranking<=5;


