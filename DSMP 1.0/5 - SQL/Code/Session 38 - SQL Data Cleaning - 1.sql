USE practise;
-- total number of datas

-- Steps for data cleaning
-- (1) Copy the data 

CREATE TABLE laptop_backup LIKE laptop;

-- adding all the rows in the old data

INSERT INTO laptop_backup 
SELECT * FROM laptop;

-- (2) Check rows and Column 

SELECT COUNT(*) FROM laptop;

-- (3) Memory Consumption 

SELECT (DATA_LENGTH/1024)/1024 FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'practise' AND TABLE_NAME = 'laptop';

-- (4) Drop non important columns

-- Dropping column 
-- ALTER TABLE laptop DROP COLUMN 'unnamed:0'

-- Dropping all the rows where values are None

SELECT * 
FROM laptop
WHERE 	Company IS NULL AND
		TypeName IS NULL AND
        Inches IS NULL AND
        ScreenResolution IS NULL AND
        `Cpu` IS NULL AND
        Ram IS NULL AND 
        `Memory` IS NULL AND
        Gpu IS NULL AND
        OpSys IS NULL AND 
        Weight IS NULL AND
        Price IS NULL;
        
        
-- How to delete this  

DELETE  FROM laptop
WHERE `index` IN (SELECT `index` FROM laptop 
				  WHERE Company IS NULL AND
						TypeName IS NULL AND
						Inches IS NULL AND
						ScreenResolution IS NULL AND
						`Cpu` IS NULL AND
						Ram IS NULL AND 
						`Memory` IS NULL AND
						Gpu IS NULL AND
						OpSys IS NULL AND 
						Weight IS NULL AND
						Price IS NULL);
                        
-- Find Duplicate - no duplicate value

SELECT * FROM laptop
GROUP BY `Index`,Company,TypeName,Inches,ScreenResolution,Cpu,Ram,Memory,Gpu,OpSys,Weight,Price
HAVING COUNT(*) > 1;

-- How to remove this 
DELETE FROM laptop
WHERE ID NOT IN(SELECT MIN(`Index`) FROM laptop
GROUP BY `Index`,Company,TypeName,Inches,ScreenResolution,Cpu,Ram,Memory,Gpu,OpSys,Weight,Price
HAVING COUNT(*) > 1);


-- Clean column
-- (1) Company

SELECT DISTINCT(Company) FROM laptop; -- No Proble

-- (2) Type Name

SELECT DISTINCT(TypeName) FROM laptop; -- No Proble


-- (3) Inches

-- changing datatype

ALTER TABLE laptop MODIFY COLUMN Inches FLOAT(10,2); 

-- (4) ScreenResolution
ALTER TABLE laptop
ADD COLUMN resolution_width INTEGER AFTER ScreenResolution,
ADD COLUMN resolution_height INTEGER AFTER resolution_width;

-- laptop width and height

UPDATE laptop l1
SET resolution_width = (SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution,' ',-1),'x',1) FROM laptop l2 WHERE l1.Index = l2.Index),
resolution_height = (SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(ScreenResolution,' ',-1),'x',-1) FROM laptop l2 WHERE l1.Index = l2.Index);

-- laptop touchscreen

ALTER TABLE laptop
ADD COLUMN touchscreen INTEGER AFTER resolution_height;

UPDATE laptop l1
SET touchscreen = (SELECT CASE 
							WHEN ScreenResolution LIKE '%Touchscreen%' THEN 1
							ELSE 0
							END
					FROM laptop l2 WHERE l1.Index = l2.Index);
                    
ALTER TABLE laptop
DROP COLUMN ScreenResolution;


ALTER TABLE laptop
ADD COLUMN screen_size VARCHAR(255) AFTER Cpu;

-- (5) CPU
-- Three Column - CPU Name,CPU Core, CPU Speed

ALTER TABLE laptop
ADD COLUMN cpu_brand VARCHAR(255) AFTER Cpu,
ADD COLUMN cpu_name VARCHAR(255) AFTER cpu_brand,
ADD COLUMN cpu_speed DECIMAL(10,1) AFTER cpu_name;

ALTER TABLE laptop
ADD COLUMN cpu_core VARCHAR(255) AFTER cpu_name;

UPDATE laptop l1
SET cpu_brand = (SELECT SUBSTRING_INDEX(Cpu," ",1) FROM laptop l2 WHERE l2.Index = l1.Index);

UPDATE laptop l1
SET cpu_speed = (SELECT REPLACE(SUBSTRING_INDEX(Cpu," ",-1),"GHz","") FROM laptop  l2 WHERE l2.Index = l1.Index);

ALTER TABLE laptop MODIFY COLUMN cpu_speed FLOAT; 

-- SELECT t.name,SUBSTRING_INDEX(TRIM(t.name),' ',-1) 
-- FROM (SELECT REPLACE(REPLACE(Cpu,cpu_brand,""),CONCAT(cpu_speed,"GHz"),"") AS 'name' FROM laptop) t;

UPDATE laptop l1
SET cpu_name = (SELECT REPLACE(REPLACE(Cpu,cpu_brand,""),CONCAT(cpu_speed,"GHz"),"") FROM laptop l2 WHERE l2.Index = l1.Index);

ALTER TABLE laptop 
DROP COLUMN Cpu, 
DROP COLUMN Cpu_core;

UPDATE laptop l1
SET cpu_name = (SELECT SUBSTRING_INDEX(trim(cpu_name),' ',2) FROM laptop l2 WHERE l2.Index = l1.Index);

-- (6) RAM

UPDATE laptop l1
SET Ram = (SELECT TRIM(REPLACE(Ram,"GB",'')) FROM laptop  l2 WHERE l1.Index = l2.Index);

-- Update this column to Integer
ALTER TABLE laptop MODIFY COLUMN Ram INTEGER; 


-- (7) Memory

SELECT Memory FROM laptop;

ALTER TABLE laptop
ADD COLUMN memory_type VARCHAR(255) AFTER Memory,
ADD COLUMN primary_storage INTEGER AFTER memory_type,
ADD COLUMN secondary_storage INTEGER AFTER primary_storage;

UPDATE laptop l1
SET memory_type = CASE 
		WHEN Memory LIKE '%SSD%' AND Memory LIKE '%HDD%' THEN 'Hybrid'
        WHEN Memory LIKE '%Flash Storage%' AND Memory LIKE '%Hybrid%' THEN 'Hybrid'
		WHEN Memory LIKE '%Hybrid%' THEN 'Hybrid'
		WHEN Memory LIKE '%SSD%' THEN 'SSD'
		WHEN Memory LIKE '%HDD%' THEN 'HDD'
        WHEN Memory LIKE '%Flash Storage%' THEN 'Flash Storage'
        ELSE NULL
END;

-- SELECT memory,memory_type,
-- 	CASE 
-- 		WHEN memory_type = 'Hybrid' THEN SUBSTRING_INDEX(memory,'+',-1)
-- 		WHEN memory_type = 'Flash Storage' THEN SUBSTRING_INDEX(memory,' ',-1)
-- 		WHEN memory_type = 'SSD' THEN SUBSTRING_INDEX(memory,' ',-1)
-- 		WHEN memory_type = 'HDD' THEN SUBSTRING_INDEX(memory,' ',-1)
-- 	END
-- FROM laptop;

UPDATE laptop l1
SET primary_storage = REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',-1),'[0-9]+'),
secondary_storage = CASE
						WHEN Memory LIKE '%+%' THEN REGEXP_SUBSTR(SUBSTRING_INDEX(Memory,'+',-1),'[0-9]+') ELSE 0
					END;
				
SELECT 
	primary_storage,secondary_storage,
    CASE 
		WHEN primary_storage<=2 THEN primary_storage*1024 ELSE primary_storage
	END,
    CASE 
		WHEN secondary_storage<=2 THEN secondary_storage*1024 ELSE secondary_storage
	END
FROM laptop;

UPDATE laptop
SET primary_storage = CASE 
		WHEN primary_storage<=2 THEN primary_storage*1024 ELSE primary_storage
	END,
secondary_storage = 
	CASE 
		WHEN secondary_storage<=2 THEN secondary_storage*1024 ELSE secondary_storage
	END;
    
ALTER table laptop
DROP COLUMN Memory;

-- (8) Gpu

-- Devide this column to 
-- (1) GPU_brand (2) GPU_store
ALTER TABLE laptop
ADD COLUMN gpu_brand VARCHAR(255) AFTER gpu,
ADD COLUMN gpu_name VARCHAR(255) AFTER gpu_brand;

UPDATE laptop l1
SET gpu_brand = (SELECT SUBSTRING_INDEX(Gpu,' ',1) FROM laptop l2 WHERE l2.Index = l1.Index);

UPDATE laptop l1
SET gpu_name = (SELECT REPLACE(gpu,gpu_brand,"") FROM laptop l2 WHERE l2.Index = l1.Index);

ALTER TABLE laptop DROP COLUMN Gpu; 
ALTER table laptop DROP COLUMN gpu_name;


-- (9) OpSys

-- Total - mac/Windows/linux,no os

UPDATE laptop
SET OpSys = CASE 
	WHEN OpSys LIKE '%mac%' THEN 'macos'
	WHEN OpSys LIKE '%windows%' THEN 'windows'
	WHEN OpSys LIKE '%linux%' THEN 'linux'
	WHEN OpSys LIKE '%No%' THEN 'N/A'
	ELSE 'other'
END;

-- (9) Weight

UPDATE laptop l1
SET weight = (SELECT REPLACE(weight,"kg","") FROM laptop l2 WHERE l2.Index = l1.Index );
ALTER TABLE laptop MODIFY COLUMN weight FLOAT;

-- (10) Price

UPDATE laptop l1
SET Price = (SELECT ROUND(Price) FROM laptop l2 WHERE l2.Index = l1.Index);

ALTER TABLE laptop MODIFY COLUMN Price INTEGER;


