-- Cleaning data in SQL

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing 

-- Standardise Date Format

SELECT  SaleDateConverted, CONVERT(Date,SaleDate)
FROM PortfolioProject.dbo.NashvilleHousing 


UPDATE NashvilleHousing 
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing 
ADD SaleDateConverted Date;


UPDATE NashvilleHousing 
SET SaleDateConverted = CONVERT(Date,SaleDate)


-- Property Address

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing 
--WHERE PropertyAddress is null
ORDER BY ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress) 
FROM PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
    ON a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is null


UPDATE a
SET PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
    ON a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is null


-- Breaking out address

SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing 
--WHERE PropertyAddress is null
--ORDER BY ParcelID

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

FROM PortfolioProject.dbo.NashvilleHousing 



ALTER TABLE NashvilleHousing 
ADD PropertySplitAddress nvarchar(255);

UPDATE NashvilleHousing 
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE NashvilleHousing 
ADD PropertySplitCity nvarchar(255);

UPDATE NashvilleHousing 
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


SELECT *
FROM PortfolioProject.dbo.NashvilleHousing 





--Separate OwnerAddress



SELECT OwnerAddress
FROM PortfolioProject.dbo.NashvilleHousing 

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM PortfolioProject.dbo.NashvilleHousing 




ALTER TABLE NashvilleHousing 
ADD OwnerSplitAddress nvarchar(255);

UPDATE NashvilleHousing 
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


ALTER TABLE NashvilleHousing 
ADD OwnerSplitCity nvarchar(255);

UPDATE NashvilleHousing 
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing 
ADD OwnerSplitSate nvarchar(255);

UPDATE NashvilleHousing 
SET OwnerSplitSate = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)




SELECT *
FROM PortfolioProject.dbo.NashvilleHousing 


--
SELECT DISTINCT (SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing 
GROUP BY SoldAsVacant
ORDER BY 2



SELECT SoldAsVacant, 
CASE WHEN SoldAsVacant = 'y' THEN 'YES'
     WHEN SoldAsVacant = 'n' THEN 'NO'
	 ELSE SoldAsVacant 
	 END
FROM PortfolioProject.dbo.NashvilleHousing 


UPDATE NashvilleHousing 
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'y' THEN 'YES'
     WHEN SoldAsVacant = 'n' THEN 'NO'
	 ELSE SoldAsVacant 
	 END



	 -- Remove Duplicates

WITH RowNumCTE as (
SELECT *,
        ROW_NUMBER() OVER(
		PARTITION By ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
		ORDER BY 
		UNIQUEID
		) row_num

FROM PortfolioProject.dbo.NashvilleHousing 
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress



--Delete Unused Columns


SELECT *
FROM PortfolioProject.dbo.NashvilleHousing 

ALTER TABLE PortfolioProject.dbo.NashvilleHousing 
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

ALTER TABLE PortfolioProject.dbo.NashvilleHousing 
DROP COLUMN SaleDate