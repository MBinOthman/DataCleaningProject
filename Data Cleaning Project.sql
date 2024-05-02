-- Data Cleaning.


SELECT *
FROM layoffs;

-- 1. Remove Duplicates.
-- 2. Standardize The Data.
-- 3. Null Values And Blank Values.
-- 4. Remove Any Unimportant Columns.



-- 1. Remove Duplicates

CREATE TABLE layoffs_staging
LIKE layoffs;


SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;



SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, 'date') AS row_num
FROM layoffs_staging;


WITH duplicates_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location,
industry, total_laid_off, percentage_laid_off, 'date', stage,
country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicates_cte
WHERE row_num > 1;


SELECT *
FROM layoffs_staging
WHERE company = 'TikTok';



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



SELECT *
FROM layoffs_staging2
WHERE row_num > 1;


INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location,
industry, total_laid_off, percentage_laid_off, 'date', stage,
country, funds_raised_millions) AS row_num
FROM layoffs_staging;




DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2;


-- 2. Standardizing Data

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);



SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';


UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT `date`
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');


ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


-- 3. Null Values Or Blank Values

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';


SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';


SELECT tb1.industry, tb2.industry
FROM layoffs_staging2 tb1
JOIN layoffs_staging2 tb2
	ON tb1.company = tb2.company
WHERE (tb1.industry IS NULL OR  tb1.industry = '')
AND  tb2.industry IS NOT NULL;   


UPDATE layoffs_staging2 tb1
JOIN layoffs_staging2 tb2
	ON tb1.company = tb2.company
SET tb1.industry = tb2.industry
WHERE tb1.industry IS NULL 
AND  tb2.industry IS NOT NULL;     


SELECT *
FROM layoffs_staging2;




SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;



DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

-- 4. Remove Any Columns Or Rows

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;


SELECT *
FROM layoffs_staging2;

